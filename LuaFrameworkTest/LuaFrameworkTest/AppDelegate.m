//
//  AppDelegate.m
//  LuaFrameworkTest
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    LuaScript *script = [Lua luaScriptWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"lua"]];
    
    // override package.path (default is Resources dir inside the main bundle)
    //script.packagePath = @"/foo/bar/?.lua";
    
    [script run]; // prime the script to define globals
    
    // call a function with one argument, ignoring return value
    [script callFunction:@"hello" withArguments:@"world", nil];
    
    // call a function that we know returns mixed results
    NSDictionary *table = [script callFunction:@"test" withArguments:@"foo", [NSNumber numberWithInt:1337], @"baz", nil];
    
    for(id item in table) {
        NSLog(@"%@ -> %@", item, [table objectForKey:item]);
    }
}

@end
