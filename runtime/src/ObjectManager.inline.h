// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


#ifndef MRT_OBJECT_MANAGER_INLINE_H
#define MRT_OBJECT_MANAGER_INLINE_H

// inlined object model functions
// common headers
// inter-module headers
#include "ExceptionManager.h"

// module internal headers
#include "ObjectManager.h"
#include "ObjectModel/MArray.inline.h"
#include "ObjectModel/MClass.inline.h"
#include "ObjectModel/MObject.inline.h"

#include "Common/TypeDef.h"

namespace MapleRuntime {
inline ObjRef ObjectManager::NewObject(const TypeInfo* ti, MSize size, AllocType allocType)
{
    CHECK_DETAIL(ti != nullptr, "ti is nullptr");
    auto obj = MObject::NewObject(const_cast<TypeInfo*>(ti), size, allocType);
    return static_cast<ObjRef>(obj);
}

inline ObjRef ObjectManager::NewObjectAndInit(const TypeInfo* ti, MSize size, void* args, AllocType allocType)
{
    CHECK_DETAIL(ti != nullptr, "ti is nullptr");
    ObjRef obj = MObject::NewObject(const_cast<TypeInfo*>(ti), size, allocType);
    CJRawArray* cjRawArray = static_cast<CJArray*>(args)->rawPtr;
    U64 argCnt = cjRawArray->len;
    ObjRef rawArray = reinterpret_cast<ObjRef>(cjRawArray);
    RefField<false>* refField = reinterpret_cast<RefField<false>*>(&(cjRawArray->data));
    for (U64 idx = 0; idx < argCnt; ++idx) {
        ObjRef argObj = static_cast<ObjRef>(Heap::GetBarrier().ReadReference(rawArray, *refField));
        // 从argObj中取出值，放入ObjRef
        TypeInfo* argType = ti->GetFieldType(idx);
        U32 offset = ti->GetFieldOffset(idx);
        Uptr argAddr = reinterpret_cast<Uptr>(obj) + TYPEINFO_PTR_SIZE + offset;
        if (argType->IsRef()) {
            obj->StoreRef(offset + TYPEINFO_PTR_SIZE, argObj);
        } else if (argType->IsStruct() || argType->IsTuple()) {
            MSize argSize = argType->GetInstanceSize();
            void* tmp = malloc(argSize);
            Heap::GetBarrier().ReadStruct(reinterpret_cast<MAddress>(tmp), argObj, 
                reinterpret_cast<Uptr>(argObj) + TYPEINFO_PTR_SIZE, argSize);
            Heap::GetBarrier().WriteStruct(obj, argAddr, argSize, reinterpret_cast<MAddress>(tmp), argSize);
            free(tmp);
        } else if (argType->IsPrimitiveType()) {
            if (memcpy_s(reinterpret_cast<void*>(argAddr),
                         argType->GetInstanceSize(),
                         reinterpret_cast<void*>(reinterpret_cast<Uptr>(argObj) + TYPEINFO_PTR_SIZE),
                         argType->GetInstanceSize()) != EOK) {
                LOG(RTLOG_ERROR, "NewObjectAndInit memcpy_s fail");
            }
        } else if (argType->IsVArray()) {
            // VArray is only used to store value types,
            // so we can copy the memory directly
            MSize vArraySize = argType->GetFieldNum() * argType->GetComponentTypeInfo()->GetInstanceSize();
            if (memcpy_s(reinterpret_cast<void*>(argAddr), vArraySize,
                         reinterpret_cast<void*>(reinterpret_cast<Uptr>(argObj) + TYPEINFO_PTR_SIZE),
                         vArraySize) != EOK) {
                LOG(RTLOG_ERROR, "NewObjectAndInit memcpy_s fail");
            }   
        } else {
            LOG(RTLOG_FATAL, "%s not to supported", argType->GetName());
        }
        refField++;
    }
    return obj;
}

inline ObjRef ObjectManager::NewWeakRefObject(const TypeInfo* ti, MSize size, AllocType allocType)
{
    CHECK_DETAIL(ti != nullptr, "klass is nullptr");
    auto obj = MObject::NewObject(const_cast<TypeInfo*>(ti), size, allocType);
    return static_cast<ObjRef>(obj);
}

inline ObjRef ObjectManager::NewPinnedObject(const TypeInfo* ti, MSize size, bool isFinalizer)
{
    CHECK_DETAIL(ti != nullptr, "ti is nullptr");
    auto obj = MObject::NewPinnedObject(const_cast<TypeInfo*>(ti), size);
    if (isFinalizer && obj != nullptr) {
        static_cast<ObjRef>(obj)->OnFinalizerCreated();
    }
    return static_cast<ObjRef>(obj);
}

inline ObjRef ObjectManager::NewFinalizer(const TypeInfo* ti, MSize size)
{
    CHECK_DETAIL(ti != nullptr, "ti is nullptr");
    auto obj = MObject::NewFinalizer(ti, size);
    return static_cast<ObjRef>(obj);
}

inline GCTib ObjectManager::GetGCInfo(const TypeInfo* ti) { return ti->GetGCTib(); }

// general array creation
inline ArrayRef ObjectManager::NewArray(MIndex nElems, const TypeInfo* arrayTi, AllocType allocType)
{
    CHECK_DETAIL(arrayTi != nullptr, "arrayTi is nullptr");
    return MArray::NewArray(nElems, *const_cast<TypeInfo*>(arrayTi), allocType);
}

inline ArrayRef ObjectManager::NewObjArray(MIndex nElems, const TypeInfo* arrayTi, AllocType allocType)
{
    CHECK_DETAIL(arrayTi != nullptr, "arrayTi is nullptr");
    return MArray::NewRefArray(nElems, *const_cast<TypeInfo*>(arrayTi), allocType);
}

inline ArrayRef ObjectManager::NewKnownWidthArray(MIndex nElems, const TypeInfo* arrayTi, ArrayElemBits elemBits,
                                                  AllocType allocType)
{
    CHECK_DETAIL(arrayTi != nullptr, "arrayTi is nullptr");
    constexpr U32 bitsToByte = 3;
    // Note here we need Bytes instead of Bits
    return MArray::NewKnownWidthArray(nElems, *const_cast<TypeInfo*>(arrayTi),
                                      (static_cast<U32>(elemBits) >> bitsToByte), allocType);
}
} // namespace MapleRuntime

#endif // MRT_OBJECT_MANAGER_INLINE_H
