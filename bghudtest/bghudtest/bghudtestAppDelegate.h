//
//  bghudtestAppDelegate.h
//  bghudtest
//
//  Created by Timothy Davis on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface bghudtestAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
