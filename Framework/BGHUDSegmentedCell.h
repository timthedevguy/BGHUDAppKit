//
//  BGHUDSegmentedCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/1/08.
//  Copyright 2008 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDSegmentedCell : NSSegmentedCell {

	NSString *themeKey;
}

@property (retain) NSString *themeKey;

-(NSRect)rectForSegment:(int)segment inFrame:(NSRect)frame;

@end
