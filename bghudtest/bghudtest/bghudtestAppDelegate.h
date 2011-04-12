//
//  bghudtestAppDelegate.h
//  bghudtest
//
//  Created by Timothy Davis on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BGHUDAppKit/BGHUDAppKit.h>

@interface bghudtestAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    BGHUDTabView *tabView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet BGHUDTabView *tabView;

@end
