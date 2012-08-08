//
//  LuaScript.m
//  Lua
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import "LuaScript.h"

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

@implementation LuaScript

@synthesize scriptPath, packagePath, packageCpath;

lua_State *L;

- (id)init {
    if(self = [super init]) {
        L = lua_open();
        
        if(L == NULL) {
            printf("error initing lua!\n");
            return nil;
        }
    }
    
    return self;
}

- (void)dealloc {
    lua_close(L);
}

- (void)run {
    luaL_openlibs(L);
    
    // set package.path
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "path"); // top of the stack
    const char *path = lua_tostring(L, -1);
    
    //NSMutableString *newPath = [NSMutableString stringWithCString:path encoding:NSUTF8StringEncoding];
    //[newPath appendFormat:@";%@", packagePath];
    NSString *newPath = [NSString stringWithFormat:@"%@;", packagePath];
    
    lua_pop(L, 1);
    lua_pushstring(L, [newPath cStringUsingEncoding:NSUTF8StringEncoding]);
    lua_setfield(L, -2, "path");
    lua_pop(L, 1);
    
    // set package.cpath for native modules
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "cpath"); // top of the stack
    path = lua_tostring(L, -1);
    
    newPath = [NSString stringWithFormat:@"%@;", packageCpath];
    
    lua_pop(L, 1);
    lua_pushstring(L, [newPath cStringUsingEncoding:NSUTF8StringEncoding]);
    lua_setfield(L, -2, "cpath");
    lua_pop(L, 1);
    
    // run the script
    if(luaL_dofile(L, [scriptPath cStringUsingEncoding:NSUTF8StringEncoding]) == 1) {
        NSLog(@"error running lua script: %@", scriptPath);
    }
}

- (void)pushObjectToLua:(id)arg withArrayIndex:(NSInteger)index withTableKey:(NSString *)key {
    // for tables, push the index/key first
    if(index > -1) {
        lua_pushnumber(L, index);
    } else if(key) {
        lua_pushstring(L, [key cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    
    // second, push the value
    if([arg isKindOfClass:[NSString class]]) {
        lua_pushstring(L, [arg cStringUsingEncoding:NSUTF8StringEncoding]);
    } else if([arg isKindOfClass:[NSArray class]]) {
        //lua_newtable(L);
        lua_createtable(L, (int) [arg count], 0);
        int count = 1;
        
        for(id obj in arg) {
            [self pushObjectToLua:obj withArrayIndex:count++ withTableKey:nil];
        }
    } else if([arg isKindOfClass:[NSNumber class]]) {
        lua_pushnumber(L, [arg floatValue]);
    } else {
        lua_pushnil(L);
    }
    
    if(index > -1 || key) {
        // finally reference the table
        lua_rawset(L, -3);
    }
}

- (id)popObjectFromLua {
    if(lua_isstring(L, -1)) {
        return [NSString stringWithCString:lua_tostring(L, -1) encoding:NSUTF8StringEncoding];
    } else if(lua_istable(L, -1)) {
        BOOL hasArray = NO;
        BOOL hasDict = NO;
        NSMutableArray *array;
        NSMutableDictionary *dict;
        
        lua_pushnil(L);
        //const char *key, *value;
        
        id value;
        
        while(lua_next(L, -2)) {
            value = [self popObjectFromLua];
            
            lua_pop(L, 1);
            
            if(lua_isnumber(L, -1)) {
                // array index
                if(!array) {
                    array = [NSMutableArray array];
                    hasArray = YES;
                }
                
                int index = (int) lua_tointeger(L, -1);
                
                [array addObject:value];
            } else if(lua_isstring(L, -1)) {
                if(!dict) {
                    dict = [NSMutableDictionary dictionary];
                    hasDict = YES;
                }
                
                [dict setObject:value forKey:[NSString stringWithCString:lua_tostring(L, -1) encoding:NSUTF8StringEncoding]];
            }
        }
        
        if(hasArray && hasDict) {
            // combine array items into dictionary
            for(int i = (int) [array count] - 1; i > -1; i--) {
                [dict setObject:[array objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
            }
            
            return dict;
        } else if(hasArray) {
            return array;
        } else if(hasDict) {
            return dict;
        } else {
            return nil;
        }
    } else if(lua_isboolean(L, -1)) {
        return lua_toboolean(L, -1) ? @"true" : @"false";
    } else if(lua_isnumber(L, -1)) {
        return [NSNumber numberWithFloat:lua_tonumber(L, -1)];
    } else if(lua_isnoneornil(L, -1)) {
        lua_pop(L, -1);
        
        return nil;
    } else {
        return nil;
    }
}

- (id)callFunction:(NSString *)aName withArguments:(id)firstObj, ... {
    @synchronized(self) {
        va_list args;
        va_start(args, firstObj);
        int count = 0;
        
        lua_getglobal(L, [aName cStringUsingEncoding:NSUTF8StringEncoding]);
        
        for(id arg = firstObj; arg != nil; arg = va_arg(args, id)) {
            count++;
            [self pushObjectToLua:arg withArrayIndex:-1 withTableKey:nil];
        }
        
        va_end(args);
        
        int err;
        
        if((err = lua_pcall(L, count, 1, 0)) != 0) {
            switch(err) {
                case LUA_ERRRUN:
                    NSLog(@"Lua: runtime error");
                    break;
                    
                case LUA_ERRMEM:
                    NSLog(@"Lua: memory allocation error");
                    break;
                    
                case LUA_ERRERR:
                    NSLog(@"Lua: error handler error");
                    break;
                    
                default:
                    NSLog(@"Lua: unknown error");
                    return nil;
            }
            
            NSLog(@"Lua: %s", lua_tostring(L, -1));
            return nil;
        }
        
        return [self popObjectFromLua];
    }
}

@end
