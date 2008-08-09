//
//  BGHUDSegmentedCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/1/08.
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

#import "BGHUDSegmentedCell.h"

@implementation BGHUDSegmentedCell

@synthesize themeKey;

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

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	
	NSBezierPath *border;
	
	switch ([self segmentStyle]) {
			
		case NSSegmentStyleTexturedRounded:
			
			//Adjust frame for shadow
			frame.origin.x += 1.5;
			frame.origin.y += .5;
			frame.size.width -= 3;
			frame.size.height -= 3;
			
			border = [[NSBezierPath alloc] init];
			
			[border appendBezierPathWithRoundedRect: frame
											xRadius: 4.0 yRadius: 4.0];
			
			//Setup to Draw Border
			[NSGraphicsContext saveGraphicsState];
			
			//Set Shadow + Border Color
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] dropShadow] set];
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
			
			//Draw Border + Shadow
			[border stroke];
			
			[NSGraphicsContext restoreGraphicsState];
			
			[border release];
			break;
	}
	
	int segCount = 0;
	
	while (segCount <= [self segmentCount] -1) {
	
		[self drawSegment: segCount inFrame: frame withView: view];
		segCount++;
	}
}

- (void)drawSegment:(int)segment inFrame:(NSRect)frame withView:(NSView *)view {
	
	//Calculate rect for this segment
	NSRect fillRect = [self rectForSegment: segment inFrame: frame];
	NSBezierPath *fillPath;
	
	switch ([self segmentStyle]) {
			
		case NSSegmentStyleTexturedRounded:
			
			if(segment == 0) {
				
				fillPath = [[NSBezierPath alloc] init];
				
				[fillPath appendBezierPathWithRoundedRect: fillRect xRadius: 3 yRadius: 3];
				
				//Setup our joining rect
				NSRect joinRect = fillRect;
				joinRect.origin.x += 4;
				joinRect.size.width -= 4;
				
				[fillPath appendBezierPathWithRect: joinRect];
				
			} else if (segment == ([self segmentCount] -1)) {
				
				fillPath = [[NSBezierPath alloc] init];
				
				[fillPath appendBezierPathWithRoundedRect: fillRect xRadius: 3 yRadius: 3];
				
				//Setup our joining rect
				NSRect joinRect = fillRect;
				joinRect.size.width -= 4;
				
				[fillPath appendBezierPathWithRect: joinRect];
				
			} else if (segment != 0 && segment != ([self segmentCount] -1)) {
			
				fillPath = [[NSBezierPath alloc] init];
				[fillPath appendBezierPathWithRect: fillRect];
			}
			
			if([self selectedSegment] == segment) {
				
				[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath: fillPath angle: 90];
			} else {
				
				[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInBezierPath: fillPath angle: 90];
			}
			
			[fillPath release];
			
			break;
			
	}
	
	//Draw Segment dividers ONLY if they are
	//inside segments
	if(segment != ([self segmentCount] -1)) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[NSBezierPath strokeLineFromPoint: NSMakePoint(fillRect.origin.x + fillRect.size.width , fillRect.origin.y)
								  toPoint: NSMakePoint(fillRect.origin.x + fillRect.size.width, fillRect.origin.y + fillRect.size.height)];
	}
}

-(NSRect)rectForSegment:(int)segment inFrame:(NSRect)frame {

	//Setup base values
	float x = frame.origin.x + .5;
	float y = frame.origin.y + .5;
	float w = [self widthForSegment: segment] + .5;
	float h = frame.size.height - 1;
	
	int segCount = 0;
	
	while (segCount < segment) {
		
		x += [self widthForSegment: segCount] + 1;
		
		if(segCount == 0 || segCount == ([self segmentCount] -1)) {
			
			x += 1;
		}
		
		if([self widthForSegment: segCount] == 0) {
			
			x += 12;
		}
		
		segCount++;
	}
	
	if(segment == 0 || segment == ([self segmentCount] -1)) {
		
		w += 1;
	}
	
	if(w == .5) {
		
		w += 12;
		[self setWidth: 12 forSegment: segment];
	}
	
	return NSMakeRect(x, y, w, h);
}

@end
