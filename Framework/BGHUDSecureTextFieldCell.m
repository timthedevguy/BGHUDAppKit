//
//  BGHUDSecureTextFieldCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDSecureTextFieldCell.h"


@implementation BGHUDSecureTextFieldCell

@synthesize themeKey;

#pragma mark Drawing Functions

-(id)initTextCell:(NSString *)aString {
	
	self = [super initTextCell: aString];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			self.themeKey = @"gradientTheme";
		}
		
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	//Adjust Rect
	cellFrame.origin.x += .5;
	cellFrame.origin.y += .5;
	cellFrame.size.width -= 1;
	cellFrame.size.height -= 1;
	
	//Draw Background
	if(fillsBackground) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textFillColor] set];
		NSRectFill(cellFrame);
	}
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: cellFrame
														 xRadius: 3
														 yRadius: 3];
	
	if([self isBezeled] || [self isBordered]) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[path setLineWidth: 1.0];
		[path stroke];
	}
	
	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[super dealloc];
}

#pragma mark -

@end
