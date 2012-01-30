# Lua.framework

**EXPERIMENTAL AND INCOMPLETE!!!**

This is a framework that you can add to any Objective-C project to add Lua
scripting. The API is kept very simple, compared to other Lua/Obj-C bridges
that have more features.

## Usage

Add `Lua.framework` to your project, and:

    @import <Lua/Lua.h>

to import the interface. To run a Lua script, for example:

    function hello(s)
      return "hello " .. s
    end

Set up the script to define global variables:

    LuaScript *script = [Lua luaScriptWithContentsOfURL:scriptURL];
    [script run];

And finally call your function:

    NSLog(@"%@", [script callFunction:@"hello" withArguments:@"world", nil]);

Functions can return arrays, tables, and primitive values.
