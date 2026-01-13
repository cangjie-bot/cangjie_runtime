// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


#ifndef MRT_FREE_REGION_MANAGER_H
#define MRT_FREE_REGION_MANAGER_H

#include "CartesianTree.h"
#include "RegionInfo.h"
#include "Common/ScopedObjectAccess.h"

namespace MapleRuntime {
class RegionManager;

// This class is and should be accessed only for region allocation. we do not rely on it to check region status.
class FreeRegionManager {
    using UnitIndex = CartesianTree::Index;
    using UnitCount = CartesianTree::Count;

public:
    explicit FreeRegionManager(RegionManager& manager) : regionManager(manager) {}

    virtual ~FreeRegionManager()
    {
        dirtyUnitTree.Fini();
        releasedUnitTree.Fini();
    }

    void Initialize(UnitCount regionCnt)
    {
        releasedUnitTree.Init(regionCnt);
        dirtyUnitTree.Init(regionCnt);
    }

    RegionInfo* TakeRegion(size_t num, RegionInfo::UnitRole uclass, bool expectPhysicalMem)
    {
        UnitIndex idx = 0;
        bool tryDirtyTree = true;
        bool tryReleasedTree = true;

        // try as hard as we can to take free regions for allocation.
        while (tryDirtyTree || tryReleasedTree) {
            // first try to get a dirty region.
            if (tryDirtyTree && dirtyUnitTreeMutex.try_lock()) {
                if (dirtyUnitTree.TakeUnits(num, idx)) {
                    DLOG(REGION, "c-tree %p alloc dirty units[%u+%u, %u) @[0x%zx, 0x%zx), %u dirty-units left",
                        &dirtyUnitTree, idx, num, idx + num, RegionInfo::GetUnitAddress(idx),
                        RegionInfo::GetUnitAddress(idx + num), dirtyUnitTree.GetTotalCount());

                    // it makes sense to slow down allocation by clearing region memory.
                    RegionInfo::ClearUnits(idx, num);
                    RegionInfo* region = RegionInfo::InitRegion(idx, num, uclass);
                    dirtyUnitTreeMutex.unlock();
                    return region;
                }
                tryDirtyTree = false; // once we fail to take units, stop trying.
                dirtyUnitTreeMutex.unlock();
            }

            // then try to get a released region.
            if (tryReleasedTree && releasedUnitTreeMutex.try_lock()) {
                if (releasedUnitTree.TakeUnits(num, idx)) {
#ifdef _WIN64
                    MemMap::CommitMemory(
                        reinterpret_cast<void*>(RegionInfo::GetUnitAddress(idx)), num * RegionInfo::UNIT_SIZE);
#endif
                    DLOG(REGION, "c-tree %p alloc released units[%u+%u, %u) @[0x%zx, 0x%zx), %u released-units left",
                        &releasedUnitTree, idx, num, idx + num, RegionInfo::GetUnitAddress(idx),
                        RegionInfo::GetUnitAddress(idx + num), releasedUnitTree.GetTotalCount());
                    RegionInfo* region = RegionInfo::InitRegion(idx, num, uclass);
                    releasedUnitTreeMutex.unlock();
                    PrehandleReleasedUnit(expectPhysicalMem, idx, num);
                    return region;
                }
                tryReleasedTree = false; // once we fail to take units, stop trying.
                releasedUnitTreeMutex.unlock();
            }
            ScopedEnterSaferegion enterSaferegion(true);
        }

        return nullptr;
    }

    // add units [idx, idx + num)
    void AddGarbageUnits(UnitIndex idx, UnitCount num)
    {
        ScopedEnterSaferegion enterSaferegion(true);
        std::lock_guard<std::mutex> lg(dirtyUnitTreeMutex);
        if (UNLIKELY(!dirtyUnitTree.MergeInsert(idx, num, true))) {
            LOG(RTLOG_FATAL, "tid %d: failed to add dirty units [%u+%u, %u)", GetTid(), idx, num, idx + num);
        }
    }

    void AddReleaseUnits(UnitIndex idx, UnitCount num)
    {
        ScopedEnterSaferegion enterSaferegion(true);
        std::lock_guard<std::mutex> lg(releasedUnitTreeMutex);
        if (UNLIKELY(!releasedUnitTree.MergeInsert(idx, num, true))) {
            LOG(RTLOG_FATAL, "tid %d: failed to add release units [%u+%u, %u)", GetTid(), idx, num, idx + num);
        }
    }

    UnitCount GetDirtyUnitCount() const { return dirtyUnitTree.GetTotalCount(); }
    UnitCount GetReleasedUnitCount() const { return releasedUnitTree.GetTotalCount(); }

    // 收集 dirtyUnitTree 中不同大小的节点信息
    struct SizeDistribution {
        size_t countLess2 = 0; // 小于2个单元的节点数量
        size_t count2To4 = 0; // 大于等于2个且小于4个单元的节点数量
        size_t count4To6 = 0; // 大于等于4个且小于6个单元的节点数量
        size_t count6To8 = 0; // 大于等于6个且小于8个单元的节点数量
        size_t count8To16 = 0; // 大于等于8个且小于16个单元的节点数量
        size_t count16To32 = 0; // 大于等于16个且小于等于32个单元的节点数量
        size_t countGreater32 = 0; // 大于等于32个单元的节点数量
        size_t totalSizeLess2 = 0; // 小于2个单元节点的总大小
        size_t totalSize2To4 = 0; // 大于等于2个且小于4个单元节点的总大小
        size_t totalSize4To6 = 0; // 大于等于4个且小于6个单元节点的总大小
        size_t totalSize6To8 = 0; // 大于等于6个且小于8个单元节点的总大小
        size_t totalSize8To16 = 0; // 大于等于8个且小于16个单元节点的总大小
        size_t totalSize16To32 = 0; // 大于等于16个且小于等于32个单元节点的总大小
        size_t totalSizeGreater32 = 0; // 大于等于32个单元节点的总大小
    };
    SizeDistribution GetDirtyTreeSizeDistribution() const;
    SizeDistribution GetReleasedTreeSizeDistribution() const;

#if defined(MRT_DEBUG)
    void DumpReleasedUnitTree() const { releasedUnitTree.DumpTree("released-unit tree"); }
    void DumpDirtyUnitTree() const { dirtyUnitTree.DumpTree("dirty-unit tree"); }
#endif

    size_t CalculateBytesToRelease() const;
    size_t ReleaseGarbageRegions(size_t targetCachedSize);

private:
    inline void PrehandleReleasedUnit(bool expectPhysicalMem, size_t idx, size_t num) const
    {
        if (expectPhysicalMem) {
            RegionInfo::ClearUnits(idx, num);
        }
    }
    RegionManager& regionManager;

    // physical pages of released units are probably released and they are prepared for allocation.
    std::mutex releasedUnitTreeMutex;
    CartesianTree releasedUnitTree;

    // dirty units are neither cleared nor released, thus must be zeroed explicitly for allocation.
    std::mutex dirtyUnitTreeMutex;
    CartesianTree dirtyUnitTree;
};
} // namespace MapleRuntime
#endif // MRT_FREE_REGION_MANAGER_H
