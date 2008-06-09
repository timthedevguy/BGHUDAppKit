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

/*-(void)drawRect:(NSRect)rect {

	NSLog(@"Drawing");
	
	[super drawRect: rect];
}*/

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		[self setupGradient];
	}
	
	return self;
}

- (void)_drawThemeBackground
{
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x -= 1;
			frame.origin.y += .5;
			frame.size.width += 2;
			frame.size.height -= 5;
			break;
		case NSSmallControlSize:
			
			
			break;
		case NSMiniControlSize:
			
			
			break;
	}
	
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: frame];
	
	[NSGraphicsContext saveGraphicsState];
	[[self dropShadow] set];
	[[self strokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
}

- (void)_drawThemeProgressArea:(BOOL)flag {
	
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 2;
			frame.origin.y += .5;
			frame.size.width -= 4;
			frame.size.height -= 5;
			break;
		case NSSmallControlSize:
			
			
			break;
		case NSMiniControlSize:
			
			
			break;
	}
	
	if([self isIndeterminate]) {
		
		//Adjust Frame to Draw in Based On Animation Index
		frame.origin.x += -37 + ((struct NSProgressIndicator_t*)self)->_animationIndex;
		frame.size.width += 32;
		frame.origin.y += 1;
		frame.size.height -= 2;
		
		//Fill with Gradient
		NSBezierPath *path1 = [NSBezierPath bezierPathWithRect: frame];
		[progressGradient drawInBezierPath: path1 angle: -45];
	} else {
		
	}
	
	//[super _drawThemeProgressArea: flag];
}

-(void)setupGradient {
	
	//NSRect frame = [self bounds];
	//frame.size.width += 100;
	
	NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity: 0];
	
	int segmentCount = ([self bounds].size.width /9);
	float stopIncrement = (1.0 / segmentCount);
	int currentSegment = 0;
	BOOL useAlternate = NO;
	
	CGFloat test[segmentCount*2];
	//CGFloat test[200];
	
	while(currentSegment < segmentCount) {
		
		test[currentSegment] = currentSegment * stopIncrement;
		currentSegment++;
		test[currentSegment] = currentSegment * stopIncrement;
		
		if(!useAlternate) {
			
			[colors addObject: [self indeterminateColor]];
			[colors addObject: [self indeterminateColor]];
			useAlternate = YES;
		} else {
			
			[colors addObject: [self indeterminateAlternateColor]];
			[colors addObject: [self indeterminateAlternateColor]];
			useAlternate = NO;
		}
		
		currentSegment++;
	}
	
	progressGradient = [[NSGradient alloc] initWithColors: colors
											  atLocations: test
											   colorSpace: [NSColorSpace deviceRGBColorSpace]];
	
	[self _drawThemeBackground];
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

-(NSGradient *)normalComplexGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324 green: 0.331 blue: 0.347 alpha: [self alphaValue]],
			(CGFloat)0, [NSColor colorWithDeviceRed: 0.245 green: 0.253 blue: 0.269 alpha: [self alphaValue]], (CGFloat).5,
			[NSColor colorWithDeviceRed: 0.206 green: 0.214 blue: 0.233 alpha: [self alphaValue]], (CGFloat).5,
			[NSColor colorWithDeviceRed: 0.139 green: 0.147 blue: 0.167 alpha: [self alphaValue]], (CGFloat)1.0, nil];
}

-(NSGradient *)highlightComplexGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524 green: 0.531 blue: 0.547 alpha: [self alphaValue]],
			(CGFloat)0, [NSColor colorWithDeviceRed: 0.445 green: 0.453 blue: 0.469 alpha: [self alphaValue]], (CGFloat).5,
			[NSColor colorWithDeviceRed: 0.406 green: 0.414 blue: 0.433 alpha: [self alphaValue]], (CGFloat).5,
			[NSColor colorWithDeviceRed: 0.339 green: 0.347 blue: 0.367 alpha: [self alphaValue]], (CGFloat)1.0, nil];
}

-(NSColor *)indeterminateColor {
	
	return [NSColor colorWithDeviceRed: 0.451 green: 0.451 blue: 0.455 alpha: .5];
}

-(NSColor *)indeterminateAlternateColor {
	
	return [NSColor colorWithDeviceRed: 0.218 green: 0.218 blue: 0.218 alpha: 1.0];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 1.0];
}

-(NSColor *)darkStrokeColor {
	
	return [NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: 0.5];
}

-(float)alphaValue {
	
	if([self isHighlighted]) {
		
		return 1.0;
	} else {
		
		return 0.6;
	}
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
