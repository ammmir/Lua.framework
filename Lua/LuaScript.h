//
//  LuaScript.h
//  Lua
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaScript : NSObject {
    const char *scriptPath;
}

- (id)initWithURL:(NSURL *)aURL;
- (void)run;
- (id)callFunction:(NSString *)aName withArguments:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

@end
