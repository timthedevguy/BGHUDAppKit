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

struct NSProgressIndicator_t {
    @defs(NSProgressIndicator)
};

@implementation BGHUDProgressIndicator

#pragma mark Drawing Functions

- (void)_drawThemeBackground {
	
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 2.5;
			frame.origin.y += .5;
			frame.size.width -= 5;
			frame.size.height -= 5;
			break;
		case NSSmallControlSize:
			
			
			break;
		case NSMiniControlSize:
			
			
			break;
	}
	
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: frame];
	
	//Draw border
	[NSGraphicsContext saveGraphicsState];
	[[self dropShadow] set];
	[[self strokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	//Draw Fill
	[[self fillGradient] drawInRect: NSInsetRect(frame, 0, 0) angle: 90];
	
	if(![self isIndeterminate]) {

		frame.size.width = ((frame.size.width / ([self maxValue] - [self minValue])) * ([self doubleValue] - [self minValue]));
		[[self highlightGradient] drawInRect: frame angle: 90];
		
	} else {
		
		//Setup Our Complex Path
		//Adjust Frame width
		frame.origin.x -= 40;
		frame.size.width += 80;
		
		NSPoint position = NSMakePoint(frame.origin.x, frame.origin.y);
		progressPath = [[NSBezierPath alloc] init];
		
		while(position.x <= (frame.origin.x + frame.size.width)) {
			
			[progressPath moveToPoint: NSMakePoint(position.x, position.y)];
			[progressPath lineToPoint: NSMakePoint(position.x + frame.size.height, position.y)];
			[progressPath lineToPoint: NSMakePoint(position.x + ((frame.size.height *2)), position.y + frame.size.height)];
			[progressPath lineToPoint: NSMakePoint(position.x + (frame.size.height), position.y + frame.size.height)];
			[progressPath closePath];
			
			position.x += ((frame.size.height *2));
		}
	}
	
	path = nil;
}

- (void)_drawThemeProgressArea:(BOOL)flag {
	
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 2.5;
			frame.origin.y += .5;
			frame.size.width -= 5;
			frame.size.height -= 5;
			break;
		case NSSmallControlSize:
			
			
			break;
		case NSMiniControlSize:
			
			
			break;
	}
	
	if([self isIndeterminate]) {
		
		//Setup Cliping Rect
		[NSBezierPath clipRect: NSInsetRect(frame, 1, 1)];
		
		//Fill Background
		[[self normalGradient] drawInRect: frame angle: 90];
		
		//Create XFormation
		NSAffineTransform *trans = [NSAffineTransform transform];
		[trans translateXBy: (-37 + ((struct NSProgressIndicator_t*)self)->_animationIndex) yBy: 0];
		
		//Apply XForm to path
		NSBezierPath *newPath = [trans transformBezierPath: progressPath];
		
		//[[self highlightGradient] set];
		//[newPath fill];
		[[self highlightGradient] drawInBezierPath: newPath angle: 90];
		
		trans = nil;
		newPath = nil;
		
	} else {
		
		
	}
}

#pragma mark -
#pragma mark Helper Methods

-(NSGradient *)normalGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251 green: 0.251 blue: 0.255 alpha: [self alphaValue]]
										 endingColor: [NSColor colorWithDeviceRed: 0.118 green: 0.118 blue: 0.118 alpha: [self alphaValue]]];
}

-(NSGradient *)highlightGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451 green: 0.451 blue: 0.455 alpha: [self alphaValue]]
										 endingColor: [NSColor colorWithDeviceRed: 0.318 green: 0.318 blue: 0.318 alpha: [self alphaValue]]];
}

-(NSGradient *)fillGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed: 0.125 green: 0.125 blue: 0.125 alpha: 1.0]
										 endingColor: [NSColor colorWithCalibratedRed: 0.208 green: 0.208 blue: 0.208 alpha: 1.0]];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 1.0];
}

-(NSColor *)darkStrokeColor {
	
	return [NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: 0.5];
}

-(float)alphaValue {
	
	return 1.0;
}

-(NSShadow *)dropShadow {
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [NSColor blackColor]];
	[shadow setShadowBlurRadius: 2];
	[shadow setShadowOffset: NSMakeSize( 0, -1)];
	
	return shadow;
}

#pragma mark -

@end
