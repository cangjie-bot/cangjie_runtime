// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


#ifndef MRT_EXTENSION_DATA_H
#define MRT_EXTENSION_DATA_H

#include "Common/TypeDef.h"
#include "MClass.h"

namespace MapleRuntime {
union OuterTiUnion {
    using OuterTiFunc = TypeInfo* (*)(TypeInfo* childTi);
    TypeInfo* outerTypeInfo;
    OuterTiFunc outerTiFunc;
};

class ATTR_PACKED(4) ExtensionData {
public:
    bool TargetIsTypeInfo() { return argNum == 0; }
    void* GetTargetType() const
    {
        if (argNum == 0) {
            return ti;
        }
        return tt;
    }
    TypeInfo* GetInterfaceTypeInfo(U32 argsNum = 0U, TypeInfo** args = nullptr) const;
    FuncPtr GetWhereCondFn() const { return whereCondFn; }
    FuncPtr* GetFuncTable() const { return funcTable; }
    void UpdateFuncTable(U16 ftSize, FuncPtr* newFt) { funcTableSize  = ftSize; funcTable = newFt; }
    U16 GetFuncTableSize() const { return funcTableSize; }
    bool HasOuterTiFastPath() const { return (flag & 0b1) != 0; }
    TypeInfo* GetOuterTiSlow(TypeInfo* childTi, U64 index) const
    {
        OuterTiUnion* outerTiUnionStart = reinterpret_cast<OuterTiUnion*>(
            reinterpret_cast<uint8_t*>(funcTable) + sizeof(FuncPtr) * funcTableSize);
        return outerTiUnionStart[index].outerTiFunc(childTi);
    }

    TypeInfo* GetOuterTiFast(U64 index) const
    {
        OuterTiUnion* outerTiUnionStart = reinterpret_cast<OuterTiUnion*>(
            reinterpret_cast<uint8_t*>(funcTable) + sizeof(FuncPtr) * funcTableSize);
        return outerTiUnionStart[index].outerTypeInfo;
    }

//private: // temporary solution
public:
    U32 argNum;
    U8 isInterfaceTypeInfo;
    // optimization: use 1 byte to speed up the search of mtable.
    U8 flag;
    U16 funcTableSize;
    union {
        TypeTemplate* tt;
        TypeInfo* ti;
    };
    union {
        FuncPtr interfaceFn;
        TypeInfo* interfaceTypeInfo;
    };
    FuncPtr whereCondFn;
    FuncPtr* funcTable;
    // The OuterTiUnion array is behind funcTable in memory, the offset depends on funcTableSize.
};
} // namespace MapleRuntime
#endif // MRT_EXTENSION_DATA_H
