//
//  Lua.m
//  Lua
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import "Lua.h"

@implementation Lua

+ (LuaScript *)luaScriptWithContentsOfFile:(NSString *)path {
    LuaScript *script = [[LuaScript alloc] init];
    script.scriptPath = path;
    script.packagePath = [NSString stringWithFormat:@"%@/?.lua", [[NSBundle mainBundle] resourcePath]];
    script.packageCpath = [NSString stringWithFormat:@"%@/?.so", [[NSBundle mainBundle] resourcePath]];
    
    return script;
}

@end
