//
//  Lua.h
//  Lua
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LuaScript.h"

@interface Lua : NSObject

+ (LuaScript *)luaScriptWithContentsOfFile:(NSString *)path;

@end
