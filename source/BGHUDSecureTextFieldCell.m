//
//  BGHUDSecureTextFieldCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDSecureTextFieldCell.h"


@implementation BGHUDSecureTextFieldCell

#pragma mark Drawing Functions

- (id)initTextCell:(NSString *)aString {
	
	self = [super initTextCell: aString];
	
	if(self) {
		
		themeManager = [[BGGradientTheme alloc] init];
		[self setTextColor: [themeManager textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *) aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		themeManager = [[BGGradientTheme alloc] init];
		[self setTextColor: [themeManager textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
	}
	
	return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	if(themeManager) {
		
		//Adjust Rect
		cellFrame.origin.x += .5;
		cellFrame.origin.y += .5;
		cellFrame.size.width -= 1;
		cellFrame.size.height -= 1;
		
		//Draw Background
		if(fillsBackground) {
			
			[[themeManager textFillColor] set];
			NSRectFill(cellFrame);
		}
		
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: cellFrame
															 xRadius: 3
															 yRadius: 3];
		
		if([self isBezeled] || [self isBordered]) {
			
			[[themeManager strokeColor] set];
			[path setLineWidth: 1.0];
			[path stroke];
		}
		
		[super drawInteriorWithFrame: cellFrame inView: controlView];
	} else {
		[super drawWithFrame: cellFrame inView: controlView];
	}
}

#pragma mark -
#pragma mark Helper Methods

-(void)setThemeManager:(BGThemeManager *)manager {
	
	themeManager = [manager retain];
	[self setTextColor: [themeManager textColor]];
}

-(void)dealloc {
	
	[themeManager release];
	[super dealloc];
}

#pragma mark -

@end
