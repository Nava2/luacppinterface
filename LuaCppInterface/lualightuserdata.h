#ifndef LUALIGHTUSERDATA_H
#define LUALIGHTUSERDATA_H

#include <cassert>
#include <memory>
#include "luareference.h"
#include "luatype.h"
#include "luauserdata.h"

template <typename T>
class LuaLightUserdata : public LuaReference
{
    T* pointer;

public:
    LuaLightUserdata(std::shared_ptr<lua_State> state, int index) : LuaReference(state, index)
    {
        auto type = GetType();
        assert(type == LuaType::userdata || type == LuaType::lightuserdata);

        if (type == LuaType::lightuserdata)
        {
            pointer = (T*)lua_touserdata(state.get(), index);
        }
        else if (type == LuaType::userdata)
        {
            auto wrap = (typename LuaUserdata<T>::UserdataWrapper*)lua_touserdata(state.get(), index);
            pointer   = wrap->actualData;
        }
    }

    T* GetPointer() const { return pointer; }
};

#endif // LUALIGHTUSERDATA_H
