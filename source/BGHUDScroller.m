//
//  BGHudScroller.m
//  HUDScroller
//
//  Created by BinaryGod on 5/22/08.
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

// Special thanks to Matt Gemmell (http://mattgemmell.com/) for helping me solve the
// transparent drawing issues.  Your awesome man!!!

#import "BGHUDScroller.h"


@implementation BGHUDScroller

#pragma mark Drawing Functions

- (void)drawRect:(NSRect)rect {
	
	if(themeManager) {
		
		arrowPosition = [[NSDictionary dictionaryWithContentsOfFile:
						  [@"~/Library/Preferences/.GlobalPreferences.plist" stringByExpandingTildeInPath]] objectForKey: @"AppleScrollBarVariant"];
		
		NSDisableScreenUpdates();
		
		[[NSColor colorWithCalibratedWhite: 0.0 alpha: 0.7] set];
		NSRectFill([self bounds]);
		
		// Draw knob-slot.
		[self drawKnobSlotInRect: [self bounds] highlight: YES];
		
		// Draw knob
		[self drawKnob];
		
		// Draw arrows
		[self drawArrow: NSScrollerIncrementArrow highlight: ([self hitPart] == NSScrollerIncrementLine)];
		[self drawArrow: NSScrollerDecrementArrow highlight: ([self hitPart] == NSScrollerDecrementLine)];
		
		[[self window] invalidateShadow];
		
		NSEnableScreenUpdates();
	} else {
		
		[super drawRect: rect];
	}
}

- (void)drawKnob {
	
	if(themeManager) {
		
		//Draw Knob
		NSBezierPath *knob = [[NSBezierPath alloc] init];
		NSRect knobRect = [self rectForPart: NSScrollerKnob];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5) /2), (knobRect.origin.y + ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 180
									   endAngle: 0];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5) /2), ((knobRect.origin.y + knobRect.size.height) - ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 0
									   endAngle: 180];
		
		[[themeManager scrollerStroke] set];
		[knob fill];
		
		knobRect.origin.x += 1;
		knobRect.origin.y += 1;
		knobRect.size.width -= 2;
		knobRect.size.height -= 2;
		
		[knob release];
		knob = [[NSBezierPath alloc] init];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5) /2), (knobRect.origin.y + ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 180
									   endAngle: 0];
		
		[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5) /2), ((knobRect.origin.y + knobRect.size.height) - ((knobRect.size.width -2) /2)))
										 radius: (knobRect.size.width -2) /2
									 startAngle: 0
									   endAngle: 180];
		
		[[themeManager scrollerKnobGradient] drawInBezierPath: knob angle: 0];
		
		[knob release];
	} else {
		
		[super drawKnob];
	}
}

- (void)drawArrow:(NSScrollerArrow)arrow highlightPart:(int)part {
	
	if(themeManager) {
		
		if(arrow == NSScrollerDecrementArrow) {
			
			if(part == -1 || part == 0) {
				
				[self drawDecrementArrow: NO];
			} else {
				
				[self drawDecrementArrow: YES];
			}
		}
		
		if(arrow == NSScrollerIncrementArrow) {
			
			if(part == 1 || part == -1) {
				
				[self drawIncrementArrow: NO];
			} else {
				
				[self drawIncrementArrow: YES];
			}
		}
	} else {
		
		//[super drawArrow: arrow highlight: part];
	}
}

- (void)drawKnobSlotInRect:(NSRect)rect highlight:(BOOL)highlight {
	
	if(themeManager) {
		
		//Draw Knob Slot
		[[themeManager scrollerTrackGradient] drawInRect: rect angle: 0];
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Adjust rect height for top base
			rect.size.height = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.size.width /2, rect.size.height + (rect.size.width /2) -5)
											 radius: (rect.size.width ) /2
										 startAngle: 180
										   endAngle: 0];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[themeManager scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
			
			[path release];
		}
	} else {
		
		[super drawKnobSlotInRect: rect highlight: highlight];
	}
}

- (void)drawDecrementArrow:(BOOL)highlighted {
	
	if([arrowPosition isEqualToString: @"DoubleMax"]) {
		
		//Draw Decrement Button
		NSRect rect = [self rectForPart: NSScrollerDecrementLine];
		NSBezierPath *path = [[NSBezierPath alloc] init];
		NSPoint basePoints[4];
		
		//Add Notch
		[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.width ) /2, (rect.origin.y  - ((rect.size.width ) /2) + 1))
										 radius: (rect.size.width ) /2
									 startAngle: 0
									   endAngle: 180];
		
		//Add the rest of the points
		basePoints[0] = NSMakePoint( rect.origin.x, rect.origin.y);
		basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
		basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
		basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
		
		//Add Points to Path
		[path appendBezierPathWithPoints: basePoints count: 4];
		
		//Fill Path
		if(!highlighted) {
			
			[[themeManager scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
		} else {
			
			[[themeManager scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
		}
		
		//Create Arrow Glyph
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) -3);
		points[1] = NSMakePoint( (rect.size.width /2) +3.5, rect.origin.y + (rect.size.height /2) +3);
		points[2] = NSMakePoint( (rect.size.width /2) -3.5, rect.origin.y + (rect.size.height /2) +3);
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		[[themeManager scrollerStroke] set];
		[arrow fill];
		
		//Create Devider Line
		[[themeManager scrollerStroke] set];
		
		[NSBezierPath strokeLineFromPoint: NSMakePoint(0, (rect.origin.y + rect.size.height) +.5)
								  toPoint: NSMakePoint(rect.size.width, (rect.origin.y + rect.size.height) +.5)];
		
		[path release];
		[arrow release];
		
	} else {
		
		NSRect rect = [self rectForPart: NSScrollerDecrementLine];
		
		NSBezierPath *path = [[NSBezierPath alloc] init];
		NSPoint basePoints[4];
		
		[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.size.width /2, rect.size.height + (rect.size.width /2) -3)
										 radius: (rect.size.width ) /2
									 startAngle: 180
									   endAngle: 0];
		
		//Add the rest of the points
		basePoints[3] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
		basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y);
		basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
		basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
		
		[path appendBezierPathWithPoints: basePoints count: 4];
		
		//Fill Path
		if(!highlighted) {
			
			[[themeManager scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
		} else {
			
			[[themeManager scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
		}
		
		//Create Arrow Glyph
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) -3);
		points[1] = NSMakePoint( (rect.size.width /2) +3.5, rect.origin.y + (rect.size.height /2) +3);
		points[2] = NSMakePoint( (rect.size.width /2) -3.5, rect.origin.y + (rect.size.height /2) +3);
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		[[themeManager scrollerStroke] set];
		[arrow fill];
		
		[path release];
		[arrow release];
	}
}

- (void)drawIncrementArrow:(BOOL)highlighted {
	
	if([arrowPosition isEqualToString: @"DoubleMax"]) {
		
		//Draw Increment Button
		NSRect rect = [self rectForPart: NSScrollerIncrementLine];
		
		if(!highlighted) {
			
			[[themeManager scrollerArrowNormalGradient] drawInRect: rect angle: 0];
		} else {
			
			[[themeManager scrollerArrowPushedGradient] drawInRect: rect angle: 0];
		}
		
		//Create Arrow Glyph
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) +3);
		points[1] = NSMakePoint( (rect.size.width /2) +3.5, rect.origin.y + (rect.size.height /2) -3);
		points[2] = NSMakePoint( (rect.size.width /2) -3.5, rect.origin.y + (rect.size.height /2) -3);
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		[[themeManager scrollerStroke] set];
		[arrow fill];
		
		[arrow release];
	} else {
		
		//Draw Decrement Button
		NSRect rect = [self rectForPart: NSScrollerIncrementLine];
		NSBezierPath *path = [[NSBezierPath alloc] init];
		NSPoint basePoints[4];
		
		//Add Notch
		[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.width ) /2, (rect.origin.y  - ((rect.size.width ) /2) + 2))
										 radius: (rect.size.width ) /2
									 startAngle: 0
									   endAngle: 180];
		
		//Add the rest of the points
		basePoints[0] = NSMakePoint( rect.origin.x, rect.origin.y);
		basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
		basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
		basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
		
		//Add Points to Path
		[path appendBezierPathWithPoints: basePoints count: 4];
		
		//Fill Path
		if(!highlighted) {
			
			[[themeManager scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
		} else {
			
			[[themeManager scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
		}
		
		//Create Arrow Glyph
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) +3);
		points[1] = NSMakePoint( (rect.size.width /2) +3.5, rect.origin.y + (rect.size.height /2) -3);
		points[2] = NSMakePoint( (rect.size.width /2) -3.5, rect.origin.y + (rect.size.height /2) -3);
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		[[themeManager scrollerStroke] set];
		[arrow fill];
		
		[path release];
		[arrow release];
	}
}

-(void)dealloc {

	[themeManager release];
	[super dealloc];
}

#pragma mark -
#pragma mark Helper Methods

-(void)setThemeManager:(BGThemeManager *)manager {

	themeManager = [manager retain];
}

#pragma mark -

@end
