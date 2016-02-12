
#include <string>

#include <luacppinterface.h>

#include <iostream>

#define CATCH_CONFIG_MAIN
#include <catch.hpp>

class Foo
{
};

SCENARIO("Invalid pointers still return, but null")
{
    GIVEN("Lua with a Foo() method returning a bad Userdata")
    {
        Lua lua;

        auto ctor = lua.CreateFunction<LuaUserdata<Foo>(void)>([&]() -> LuaUserdata<Foo>
                                                               {
                                                                   return lua.CreateUserdata<Foo>(nullptr);
                                                               });

        auto gbl = lua.GetGlobalEnvironment();
        gbl.Set("Foo", ctor);

        THEN("Storing the result of Foo() is valid but `null`")
        {
            auto result = lua.RunScript("foo = Foo()");
            REQUIRE(result == "No errors");

            auto ud = gbl.Get<LuaUserdata<Foo>>("foo");
            REQUIRE_FALSE(ud.GetPointer());

            auto foo = gbl.Get<Foo*>("foo");
            REQUIRE_FALSE(foo);
        }
    }
}
