//
//  Lua.m
//  Lua
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import "Lua.h"

@implementation Lua

+ (LuaScript *)luaScriptWithContentsOfURL:(NSURL *)aURL {
    return [[LuaScript alloc] initWithURL:aURL];
}

@end
