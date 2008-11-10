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

@interface NSSegmentedCell (private)
-(NSRect)rectForSegment:(int)segment inFrame:(NSRect)frame;
@end

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
			
			//If this is the first segment, draw rounded corners
			if(segment == 0) {
				
				fillPath = [[NSBezierPath alloc] init];
				
				[fillPath appendBezierPathWithRoundedRect: fillRect xRadius: 3 yRadius: 3];
				
				//Setup our joining rect
				NSRect joinRect = fillRect;
				joinRect.origin.x += 4;
				joinRect.size.width -= 4;
				
				[fillPath appendBezierPathWithRect: joinRect];
			
			//If this is the last segment, draw rounded corners
			} else if (segment == ([self segmentCount] -1)) {
				
				fillPath = [[NSBezierPath alloc] init];
				fillRect.size.width -= 3;
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
	
	[self drawTextInSegment: segment inFrame: fillRect];
}

-(void)drawTextInSegment:(int)segment inFrame:(NSRect)frame {

	if([self labelForSegment: segment] != nil) {
	
		NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithCapacity: 0];
		
		[textAttributes setValue: [NSFont controlContentFontOfSize: [NSFont systemFontSizeForControlSize: [self controlSize]]] forKey: NSFontAttributeName];
		[textAttributes setValue: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] forKey: NSForegroundColorAttributeName];
		
		NSAttributedString *newTitle = [[NSAttributedString alloc] initWithString: [self labelForSegment: segment] attributes: textAttributes];
		
		frame.origin.y += (BGCenterY(frame) - ([newTitle size].height /2));
		frame.origin.x += (BGCenterX(frame) - ([newTitle size].width /2));
		frame.size.height = [newTitle size].height;
		frame.size.width = [newTitle size].width;
		
		if(frame.origin.x < 3) { frame.origin.x = 3; }
		
		[newTitle drawInRect: frame];
		
		[textAttributes release];
		[newTitle release];
	}
}

@end
