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
		
		[self setTextColor: [NSColor whiteColor]];
		
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
		
		[self setTextColor: [self textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
	}
	
	return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	//Adjust Rect
	cellFrame.origin.x += .5;
	cellFrame.origin.y += .5;
	cellFrame.size.width -= 1;
	cellFrame.size.height -= 1;
	
	//Draw Background
	if(fillsBackground) {
		
		[[self fillColor] set];
		NSRectFill(cellFrame);
	}
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: cellFrame
														 xRadius: 3
														 yRadius: 3];
	
	if([self isBezeled] || [self isBordered]) {
		
		[[self strokeColor] set];
		[path setLineWidth: 1.0];
		[path stroke];
	}
	
	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

#pragma mark -
#pragma mark Helper Methods

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 1.0];
}

-(NSColor *)fillColor {
	
	return [NSColor colorWithDeviceRed: .224 green: .224 blue: .224 alpha: .95];
}

-(NSColor *)textColor {
	
	return [NSColor whiteColor];
}

#pragma mark -

@end
