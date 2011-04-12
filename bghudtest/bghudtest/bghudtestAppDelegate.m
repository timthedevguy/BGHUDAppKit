//
//  bghudtestAppDelegate.m
//  bghudtest
//
//  Created by Timothy Davis on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "bghudtestAppDelegate.h"

@implementation bghudtestAppDelegate

@synthesize window;
@synthesize tabView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"Done with initialization");
    NSLog(@"TabView: %@", tabView);
}

@end
