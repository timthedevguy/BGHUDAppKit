//
//  BGHUDSliderCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/30/08.
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

#import "BGHUDSliderCell.h"


@implementation BGHUDSliderCell

@synthesize themeKey;

#pragma mark Init/Dealloc

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

-(void)dealloc {
	
	[super dealloc];
}

#pragma mark -
#pragma mark Drawing Methods

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped {
	
	if([self sliderType] == NSLinearSlider) {
		
		if(![self isVertical]) {
			
			[self drawHorizontalBarInFrame: aRect];
		} else {
			
			[self drawVerticalBarInFrame: aRect];
		}
	} else {
		
		//Placeholder for when I figure out how to draw NSCircularSlider
	}
}

- (void)drawKnob:(NSRect)aRect {
	
	if([self sliderType] == NSLinearSlider) {
		
		if(![self isVertical]) {
			
			[self drawHorizontalKnobInFrame: aRect];
		} else {
			
			[self drawVerticalKnobInFrame: aRect];
		}
	} else {
		
		//Place holder for when I figure out how to draw NSCircularSlider
	}
}

- (void)drawHorizontalBarInFrame:(NSRect)frame {
	
	// Adjust frame based on ControlSize
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkBelow) {
					
					frame.origin.y += 4;
				} else {
					
					frame.origin.y += frame.size.height - 10;
				}
			} else {
				
				frame.origin.y = frame.origin.y + (((frame.origin.y + frame.size.height) /2) - 2.5);
			}
			
			frame.origin.x += 2.5;
			frame.origin.y += 0.5;
			frame.size.width -= 5;
			frame.size.height = 5;
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkBelow) {
					
					frame.origin.y += 2;
				} else {
					
					frame.origin.y += frame.size.height - 8;
				}
			} else {
				
				frame.origin.y = frame.origin.y + (((frame.origin.y + frame.size.height) /2) - 2.5);
			}
			
			frame.origin.x += 0.5;
			frame.origin.y += 0.5;
			frame.size.width -= 1;
			frame.size.height = 5;
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkBelow) {
					
					frame.origin.y += 2;
				} else {
					
					frame.origin.y += frame.size.height - 6;
				}
			} else {
				
				frame.origin.y = frame.origin.y + (((frame.origin.y + frame.size.height) /2) - 2);
			}
			
			frame.origin.x += 0.5;
			frame.origin.y += 0.5;
			frame.size.width -= 1;
			frame.size.height = 3;
			break;
	}
	
	//Draw Bar
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame xRadius: 2 yRadius: 2];
	
	if([self isEnabled]) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] sliderTrackColor] set];
		[path fill];
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[path stroke];
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledSliderTrackColor] set];
		[path fill];
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
		[path stroke];
	}
}

- (void)drawVerticalBarInFrame:(NSRect)frame {
	
	//Vertical Scroller
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkRight) {
					
					frame.origin.x += 4;
				} else {
					
					frame.origin.x += frame.size.width - 9;
				}
			} else {
				
				frame.origin.x = frame.origin.x + (((frame.origin.x + frame.size.width) /2) - 2.5);
			}
			
			frame.origin.x += 0.5;
			frame.origin.y += 2.5;
			frame.size.height -= 6;
			frame.size.width = 5;
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkRight) {
					
					frame.origin.x += 3;
				} else {
					
					frame.origin.x += frame.size.width - 8;
				}
				
			} else {
				
				frame.origin.x = frame.origin.x + (((frame.origin.x + frame.size.width) /2) - 2.5);
			}
			
			frame.origin.y += 0.5;
			frame.size.height -= 1;
			frame.origin.x += 0.5;
			frame.size.width = 5;
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkRight) {
					
					frame.origin.x += 2.5;
				} else {
					
					frame.origin.x += frame.size.width - 6.5;
				}
			} else {
				
				frame.origin.x = frame.origin.x + (((frame.origin.x + frame.size.width) /2) - 2);
			}
			
			frame.origin.x += 1;
			frame.origin.y += 0.5;
			frame.size.height -= 1;
			frame.size.width = 3;
			break;
	}
	
	//Draw Bar
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame xRadius: 2 yRadius: 2];
	
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] sliderTrackColor] set];
	[path fill];
	
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	[path stroke];
}

- (void)drawHorizontalKnobInFrame:(NSRect)frame {
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkAbove) {
					
					frame.origin.y += 2;
				}
				
				frame.origin.x += 2;
				frame.size.height = 19.0f;
				frame.size.width = 15.0f;
			} else {
				
				frame.origin.x += 3;
				frame.origin.y += 3;
				frame.size.height = 15;
				frame.size.width = 15;
			}
			break;
			
		case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkAbove) {
					
					frame.origin.y += 1;
				}
				
				frame.origin.x += 1;
				frame.size.height = 13.0f;
				frame.size.width = 11.0f;
			} else {
				
				frame.origin.x += 2;
				frame.origin.y += 2;
				frame.size.height = 11;
				frame.size.width = 11;
			}
			break;
			
		case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				frame.origin.x += 1;
				frame.size.height = 11.0f;
				frame.size.width = 9.0f;
			} else {
				
				frame.origin.x += 2;
				frame.origin.y += 1;
				frame.size.height = 9;
				frame.size.width = 9;
			}
			break;
	}
	
	NSBezierPath *pathOuter = [[NSBezierPath alloc] init];
	NSBezierPath *pathInner = [[NSBezierPath alloc] init];
	NSPoint pointsOuter[5];
	NSPoint pointsInner[5];
	int gradientAngle = 90;
	
	if([self numberOfTickMarks] != 0) {
		
		if([self tickMarkPosition] == NSTickMarkBelow) {
			
			pointsOuter[0] = NSMakePoint(frame.origin.x, frame.origin.y);
			pointsOuter[1] = NSMakePoint(frame.origin.x, (frame.size.height /2) +2);
			pointsOuter[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + frame.size.height);
			pointsOuter[3] = NSMakePoint(frame.origin.x + frame.size.width, (frame.size.height /2) +2);
			pointsOuter[4] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y);
		} else {
			
			pointsOuter[0] = NSMakePoint(frame.origin.x, frame.origin.y + frame.size.height);
			pointsOuter[1] = NSMakePoint(frame.origin.x, frame.origin.y + (frame.size.height - (frame.size.height /2) -2));
			pointsOuter[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y);
			pointsOuter[3] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + (frame.size.height - (frame.size.height /2) -2));
			pointsOuter[4] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
			
			gradientAngle = 270;
		}
		
		[pathOuter appendBezierPathWithPoints: pointsOuter count: 5];
		
		frame.origin.x += 1;
		frame.origin.y += 1;
		frame.size.width -= 2;
		frame.size.height -= 2;
		
		if([self tickMarkPosition] == NSTickMarkBelow) {
			
			pointsInner[0] = NSMakePoint(frame.origin.x, frame.origin.y);
			pointsInner[1] = NSMakePoint(frame.origin.x, (frame.size.height /2) +2);
			pointsInner[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + frame.size.height);
			pointsInner[3] = NSMakePoint(frame.origin.x + frame.size.width, (frame.size.height /2) +2);
			pointsInner[4] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y);
		} else {
			
			pointsInner[0] = NSMakePoint(frame.origin.x, frame.origin.y + frame.size.height);
			pointsInner[1] = NSMakePoint(frame.origin.x, frame.origin.y + (frame.size.height - (frame.size.height /2) -2));
			pointsInner[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y);
			pointsInner[3] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + (frame.size.height - (frame.size.height /2) -2));
			pointsInner[4] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
		}
		
		[pathInner appendBezierPathWithPoints: pointsInner count: 5];
	} else {
		
		[pathOuter appendBezierPathWithOvalInRect: frame];
		
		frame.origin.x += 1;
		frame.origin.y += 1;
		frame.size.width -= 2;
		frame.size.height -= 2;
		
		[pathInner appendBezierPathWithOvalInRect: frame];
	}
	
	//I use two NSBezierPaths here to create the border because doing a simple
	//[path stroke] leaves ghost lines when the knob is moved.
	
	//Draw Base Layer
	if([self isEnabled]) {
		
		[NSGraphicsContext saveGraphicsState];
		
		if([self isHighlighted] && ([self focusRingType] == NSFocusRingTypeDefault ||
									[self focusRingType] == NSFocusRingTypeExterior)) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] focusRing] set];
		}
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[pathOuter fill];
		
		[NSGraphicsContext restoreGraphicsState];
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
		[pathOuter fill];
	}
	
	//Draw Inner Layer
	if([self isEnabled]) {
		
		if([self isHighlighted]) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightKnobColor] drawInBezierPath: pathInner angle: gradientAngle];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] knobColor] drawInBezierPath: pathInner angle: gradientAngle];
		}
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledKnobColor] drawInBezierPath: pathInner angle: gradientAngle];
	}
	
	[pathOuter release];
	[pathInner release];
}

- (void)drawVerticalKnobInFrame:(NSRect)frame {
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				if([self tickMarkPosition] == NSTickMarkRight) {
					
					frame.origin.x -= 3;
				}
				
				frame.origin.x += 3;
				frame.origin.y += 2;
				frame.size.height = 15;
				frame.size.width = 19;
			} else {
				
				frame.origin.x += 3;
				frame.origin.y += 3;
				frame.size.height = 15;
				frame.size.width = 15;
			}
			break;
			
			case NSSmallControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				frame.origin.x += 1;
				frame.origin.y += 1;
				frame.size.height = 11;
				frame.size.width = 13;
			} else {
				
				frame.origin.x += 2;
				frame.origin.y += 2;
				frame.size.height = 11;
				frame.size.width = 11;
			}
			break;
			
			case NSMiniControlSize:
			
			if([self numberOfTickMarks] != 0) {
				
				frame.origin.y += 1;
				frame.size.height = 9;
				frame.size.width = 11;
			} else {
				
				frame.origin.x += 1;
				frame.origin.y += 1;
				frame.size.height = 9;
				frame.size.width = 9;
			}
			break;
	}
	
	NSBezierPath *pathOuter = [[NSBezierPath alloc] init];
	NSBezierPath *pathInner = [[NSBezierPath alloc] init];
	NSPoint pointsOuter[5];
	NSPoint pointsInner[5];
	int gradientAngle = 90;
	
	if([self numberOfTickMarks] != 0) {
		
		if([self tickMarkPosition] == NSTickMarkRight) {
			
			pointsOuter[0] = NSMakePoint(frame.origin.x, frame.origin.y);
			pointsOuter[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + 2), frame.origin.y);
			pointsOuter[2] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + (frame.size.height /2));
			pointsOuter[3] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + 2), frame.origin.y + frame.size.height);
			pointsOuter[4] = NSMakePoint(frame.origin.x, frame.origin.y + frame.size.height);
			
			gradientAngle = 0;
		} else {
			
			pointsOuter[0] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y);
			pointsOuter[1] = NSMakePoint(frame.origin.x + (frame.size.width - (frame.size.width /2) -2), frame.origin.y);
			pointsOuter[2] = NSMakePoint(frame.origin.x, frame.origin.y + (frame.size.height /2));
			pointsOuter[3] = NSMakePoint(frame.origin.x + (frame.size.width - (frame.size.width /2) -2), frame.origin.y + frame.size.height);
			pointsOuter[4] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
			
			gradientAngle = 180;
		}
		
		[pathOuter appendBezierPathWithPoints: pointsOuter count: 5];
		
		frame.origin.x += 1;
		frame.origin.y += 1;
		frame.size.width -= 2;
		frame.size.height -= 2;
		
		if([self tickMarkPosition] == NSTickMarkRight) {
			
			pointsInner[0] = NSMakePoint(frame.origin.x, frame.origin.y);
			pointsInner[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + 2), frame.origin.y);
			pointsInner[2] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + (frame.size.height /2));
			pointsInner[3] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + 2), frame.origin.y + frame.size.height);
			pointsInner[4] = NSMakePoint(frame.origin.x, frame.origin.y + frame.size.height);
		} else {
			
			pointsInner[0] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y);
			pointsInner[1] = NSMakePoint(frame.origin.x + (frame.size.width - (frame.size.width /2) -2), frame.origin.y);
			pointsInner[2] = NSMakePoint(frame.origin.x, frame.origin.y + (frame.size.height /2));
			pointsInner[3] = NSMakePoint(frame.origin.x + (frame.size.width - (frame.size.width /2) -2), frame.origin.y + frame.size.height);
			pointsInner[4] = NSMakePoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
		}
		
		[pathInner appendBezierPathWithPoints: pointsInner count: 5];
	} else {
		
		[pathOuter appendBezierPathWithOvalInRect: frame];
		
		frame.origin.x += 1;
		frame.origin.y += 1;
		frame.size.width -= 2;
		frame.size.height -= 2;
		
		[pathInner appendBezierPathWithOvalInRect: frame];
	}
	
	//I use two NSBezierPaths here to create the border because doing a simple
	//[path stroke] leaves ghost lines when the knob is moved.
	
	//Draw Base Layer
	if([self isEnabled]) {
		
		[NSGraphicsContext saveGraphicsState];
		
		if([self isHighlighted] && ([self focusRingType] == NSFocusRingTypeDefault ||
									[self focusRingType] == NSFocusRingTypeExterior)) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] focusRing] set];
		}
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[pathOuter fill];
		
		[NSGraphicsContext restoreGraphicsState];
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
		[pathOuter fill];
	}
	
	//Draw Inner Layer
	if([self isEnabled]) {
		
		if([self isHighlighted]) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightKnobColor] drawInBezierPath: pathInner angle: gradientAngle];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] knobColor] drawInBezierPath: pathInner angle: gradientAngle];
		}
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledKnobColor] drawInBezierPath: pathInner angle: gradientAngle];
	}
	
	[pathOuter release];
	[pathInner release];
}

#pragma mark -
#pragma mark Overridden Methods

- (BOOL)_usesCustomTrackImage {
	
	return YES;
}

#pragma mark -

@end
