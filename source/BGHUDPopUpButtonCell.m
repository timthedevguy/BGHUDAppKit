//
//  BGHUDPopUpButtonCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/31/08.
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

#import "BGHUDPopUpButtonCell.h"


@implementation BGHUDPopUpButtonCell

#pragma mark Drawing Functions

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		NSRect frame = [[self controlView] frame];
		frame.origin.x -= 3;
		frame.origin.y -= 3;
		frame.size.width += 6;
		frame.size.height += 3;
		
		[[self controlView] setFrame: frame];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		NSRect frame = [[self controlView] frame];
		frame.origin.x -= 3;
		frame.origin.y -= 3;
		frame.size.width += 6;
		frame.size.height += 3;
		
		[[self controlView] setFrame: frame];
	}
	
	return self;
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
		
	// Adjust frame to account for drop shadow
	cellFrame.origin.x += 3;
	cellFrame.size.width -= 6;
	cellFrame.size.height -= 3;
	
	NSRect frame = cellFrame;
	
	//Adjust frame by .5 so lines draw true
	frame.origin.x += .5;
	frame.origin.y += .5;
	frame.size.height = [self cellSize].height;
	
	//Make Adjustments to Frame based on Cell Size
	switch ([self controlSize]) {
		
		case NSRegularControlSize:
			
			frame.origin.x += 3;
			frame.size.width -= 7;
			frame.origin.y += 2;
			frame.size.height -= 7;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.y += 1;
			frame.size.height -= 5;
			frame.origin.x += 3;
			frame.size.width -= 6;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 1;
			frame.size.width -= 2;
			frame.size.height -= 1;
			break;
	}
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame
														 xRadius: 4
														 yRadius: 4];
	
	[NSGraphicsContext saveGraphicsState];
	[[self dropShadow] set];
	[[self darkStrokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	[[self normalGradient] drawInBezierPath: path angle: 90];
	
	[[self strokeColor] set];
	[path setLineWidth: 1.0 ];
	[path stroke];
	
	//Draw the arrows
	[self drawArrowsInRect: frame];
	
	//Adjust rect for title drawing
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 1;
			frame.size.width -= 29;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 2;
			frame.size.width -= 29;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += .5;
			frame.size.width -= 26;
			break;
	}
	
	NSMutableAttributedString *aTitle = [[NSMutableAttributedString alloc] initWithAttributedString: [self attributedTitle]];
	
	[aTitle beginEditing];
	
	[aTitle removeAttribute: NSForegroundColorAttributeName range: NSMakeRange(0, [aTitle length])];
	
	[aTitle addAttribute: NSForegroundColorAttributeName
					  value: [NSColor whiteColor]// [self titleColor]
					  range: NSMakeRange(0, [aTitle length])];
	
	[aTitle endEditing];
	
	[super drawTitle: aTitle withFrame: frame inView: controlView];
	
	path = nil;
}

- (void)drawArrowsInRect:(NSRect) frame {
	
	float arrowsWidth;
	float arrowsHeight;
	float arrowWidth;
	float arrowHeight;
	
	//Adjust based on Control size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += (frame.size.width -21);
			frame.size.width = 21;
			
			arrowWidth = 3.5;
			arrowHeight = 2.5;
			arrowsHeight = 2;
			arrowsWidth = 2.5;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += (frame.size.width -18);
			frame.size.width = 18;
			
			arrowWidth = 3.5;
			arrowHeight = 2.5;
			arrowsHeight = 2;
			arrowsWidth = 2.5;
			
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += (frame.size.width - 15);
			frame.size.width = 15;
			
			arrowWidth = 2.5;
			arrowHeight = 1.5;
			arrowsHeight = 1.5;
			arrowsWidth = 2;
			break;
	}
	
	if([self pullsDown]) {
		
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		
		points[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
		points[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
		points[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + arrowHeight));
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		[[self strokeColor] set];
		[arrow fill];
		
		arrow = nil;
		
	} else {
	
		NSBezierPath *topArrow = [[NSBezierPath alloc] init];
		
		NSPoint topPoints[3];
		
		topPoints[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowsWidth), frame.origin.y + ((frame.size.height /2) - arrowsHeight));
		topPoints[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowsWidth), frame.origin.y + ((frame.size.height /2) - arrowsHeight));
		topPoints[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) - ((arrowsHeight * 2) + 2)));
		
		[topArrow appendBezierPathWithPoints: topPoints count: 3];
		
		[[self strokeColor] set];
		[topArrow fill];
		
		NSBezierPath *bottomArrow = [[NSBezierPath alloc] init];
		
		NSPoint bottomPoints[3];
		
		bottomPoints[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowsWidth), frame.origin.y + ((frame.size.height /2) + arrowsHeight));
		bottomPoints[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowsWidth), frame.origin.y + ((frame.size.height /2) + arrowsHeight));
		bottomPoints[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + ((arrowsHeight * 2) + 2)));
		
		[bottomArrow appendBezierPathWithPoints: bottomPoints count: 3];
		
		[[self strokeColor] set];
		[bottomArrow fill];
		
		topArrow = nil;
		bottomArrow = nil;
	}
}

#pragma mark -
#pragma mark Helper Methods

-(NSGradient *)normalGradient {
	
	return [[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251 green: 0.251 blue: 0.255 alpha: [self alphaValue]]
										 endingColor: [NSColor colorWithDeviceRed: 0.118 green: 0.118 blue: 0.118 alpha: [self alphaValue]]];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 1.0];
}

-(NSColor *)darkStrokeColor {
	
	return [NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: 0.5];
}

-(NSColor *)titleColor {
	
	return [NSColor whiteColor];
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
