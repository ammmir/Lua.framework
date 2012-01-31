# Lua.framework

**EXPERIMENTAL AND INCOMPLETE!!!**

This is a framework that you can add to any Objective-C project to add Lua
scripting. The API is kept very simple, compared to other Lua/Obj-C bridges
that have more features.

## Usage

Grab the source:

    git clone git://github.com/ammmir/Lua.framework.git

Download and compile [LuaJIT](http://luajit.org/) (2.0.0-beta9):

    curl -s http://luajit.org/download/LuaJIT-2.0.0-beta9.tar.gz | tar zxv
    cd LuaJIT-2.0.0-beta9
    make -j amalg

Next, add `Lua.framework` to your project, and bring in the interface:

    #import <Lua/Lua.h>

To run a Lua script, for example:

    function hello(s)
      return "hello " .. s
    end

Set up the script to define global variables:

    LuaScript *script = [Lua luaScriptWithContentsOfFile:@"/tmp/foo.lua"];
    [script run];

And finally call your function:

    NSLog(@"%@", [script callFunction:@"hello" withArguments:@"world", nil]);

Functions can return arrays, tables, and primitive values.
