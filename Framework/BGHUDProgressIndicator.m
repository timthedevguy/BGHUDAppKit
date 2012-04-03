//
//  BGHUDProgressIndicator.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/6/08.
//
//  Copyright (c) 2008, Tim Davis (BinaryMethod.com, binary.god@gmail.com)
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice, this
//	list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright notice,
//	this list of conditions and the following disclaimer in the documentation and/or
//	other materials provided with the distribution.
//
//		Neither the name of the BinaryMethod.com nor the names of its contributors
//	may be used to endorse or promote products derived from this software without
//	specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
//	OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//	POSSIBILITY OF SUCH DAMAGE.

#import "BGHUDProgressIndicator.h"

#import <objc/runtime.h>

@implementation BGHUDProgressIndicator

@synthesize themeKey;

#pragma mark Drawing Functions

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
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
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

- (void)_drawThemeBackground {
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
		case NSRegularControlSize:
			frame.origin.y += 1.0f;
			frame.size.height -= 2.0f;
			break;
		case NSSmallControlSize:
			break;
	}
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:2.0f yRadius:2.0f];
	[path setClip];
	
	//Draw Fill
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] progressTrackGradient] drawInBezierPath:path angle:90];
	
	if(![self isIndeterminate]) {
		frame.size.width = (CGFloat)((frame.size.width / ([self maxValue] - [self minValue])) * ([self doubleValue] - [self minValue]));
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath:[NSBezierPath bezierPathWithRect:frame] angle: 90];
	} else {
		//Setup Our Complex Path
		//Adjust Frame width
		frame.origin.x -= frame.size.height;
		frame.size.width += frame.size.height * 4;
		
		NSPoint position = NSMakePoint(frame.origin.x + 1, frame.origin.y + 1);
		
		if(progressPath) {[progressPath release];}
		progressPath = [[NSBezierPath alloc] init];
		
		CGFloat step = frame.size.height - 2;
		CGFloat double_step = step * 2;
		while(position.x <= (frame.origin.x + frame.size.width)) {
			[progressPath moveToPoint: NSMakePoint(position.x,					position.y)];
			[progressPath lineToPoint: NSMakePoint(position.x + step,			position.y)];
			[progressPath lineToPoint: NSMakePoint(position.x + double_step,	position.y + step)];
			[progressPath lineToPoint: NSMakePoint(position.x + step,			position.y + step)];
			[progressPath closePath];
			position.x += double_step;
		}
	}
	
	//Draw border
	[NSGraphicsContext saveGraphicsState];
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
}

- (void)_drawThemeProgressArea:(BOOL)flag {
	
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
		case NSRegularControlSize:
			frame.origin.y += 1.0f;
			frame.size.height -= 2.0f;
			break;
		case NSSmallControlSize:
			break;
	}
	
	if([self isIndeterminate]) {
		//Setup Cliping Rect
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1, 1) xRadius:2.0f yRadius:2.0f];
		[path setClip];
		
		//Fill Background
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: frame angle: 90];
		
        //Get the animation index (private)
        int animationIndex = 0;
        object_getInstanceVariable( self, "_animationIndex", (void **)&animationIndex );

		//Create XFormation
		NSAffineTransform *trans = [NSAffineTransform transform];
		[trans translateXBy:animationIndex - 16 yBy: 0];
		
		//Apply XForm to path
		NSBezierPath *newPath = [trans transformBezierPath: progressPath];
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath: newPath angle: 90];
		
	} else {
		
		
	}
}

- (void)drawRect:(NSRect)dirtyRect {
	[self _drawThemeBackground];
	[self _drawThemeProgressArea:YES];
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[progressPath release];
	[super dealloc];
}

#pragma mark -

@end
