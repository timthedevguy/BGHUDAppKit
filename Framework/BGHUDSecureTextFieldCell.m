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
	cellFrame = NSInsetRect(cellFrame, 1.5, 1.5);
	
	//Create Path
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	if([self bezelStyle] == NSTextFieldRoundedBezel) {
		
		[path appendBezierPathWithArcWithCenter: NSMakePoint(cellFrame.origin.x + (cellFrame.size.height /2), cellFrame.origin.y + (cellFrame.size.height /2))
										 radius: cellFrame.size.height /2
									 startAngle: 90
									   endAngle: 270];
		
		[path appendBezierPathWithArcWithCenter: NSMakePoint(cellFrame.origin.x + (cellFrame.size.width - (cellFrame.size.height /2)), cellFrame.origin.y + (cellFrame.size.height /2))
										 radius: cellFrame.size.height /2
									 startAngle: 270
									   endAngle: 90];
		
		[path closePath];
	} else {
		
		[path appendBezierPathWithRoundedRect: cellFrame xRadius: 3.0 yRadius: 3.0];
	}
	
	//Draw Background
	if(fillsBackground) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textFillColor] set];
		[path fill];
	}
	
	if([self isBezeled] || [self isBordered]) {
		
		[NSGraphicsContext saveGraphicsState];
		
		if([super showsFirstResponder] && [[[self controlView] window] isKeyWindow] && 
		   ([self focusRingType] == NSFocusRingTypeDefault ||
			[self focusRingType] == NSFocusRingTypeExterior)) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] focusRing] set];
		}
		
		//Check State
		if([self isEnabled]) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
		}
		
		[path setLineWidth: 1.0];
		[path stroke];
		
		[NSGraphicsContext restoreGraphicsState];
	}
	
	//Get TextView for this editor
	NSTextView* view = (NSTextView*)[[controlView window] fieldEditor: NO forObject: controlView];
	
	//Get Attributes of the selected text
	NSMutableDictionary *dict = [[[view selectedTextAttributes] mutableCopy] autorelease];	
	
	//If window/app is active draw the highlight/text in active colors
	if([self showsFirstResponder] && [[[self controlView] window] isKeyWindow])
	{
		[dict setObject: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionHighlightActiveColor]
				 forKey: NSBackgroundColorAttributeName];
		
		[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor]
					 range: [view selectedRange]];
	}
	else
	{
		[dict setObject: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionHighlightInActiveColor]
				 forKey: NSBackgroundColorAttributeName];
		
		[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor]
					 range: [view selectedRange]];
	}
	
	[view setSelectedTextAttributes:dict];
	
	if([self isEnabled]) {
		
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
	} else {
		
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor]];
	}
	
	// Check to see if the attributed placeholder has been set or not
	if(![self placeholderAttributedString]) {
		
		//Nope lets create it
		NSDictionary *attribs = [[NSDictionary alloc] initWithObjectsAndKeys: 
								 [[[BGThemeManager keyedManager] themeForKey: self.themeKey] placeholderTextColor] , NSForegroundColorAttributeName];
		
		//Set it
		[self setPlaceholderAttributedString: [[[NSAttributedString alloc] initWithString: [self placeholderString] attributes: attribs] autorelease]];
	}
	
	[self drawInteriorWithFrame: cellFrame inView: controlView];
}

-(void)drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	
	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[super dealloc];
}

#pragma mark -

@end
