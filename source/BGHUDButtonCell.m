//
//  BGHUDButtonCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/25/08.
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

#import "BGHUDButtonCell.h"


@implementation BGHUDButtonCell

#pragma mark Draw Functions

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
		themeManager = [[BGGradientTheme alloc] init];
	}
	
	return self;
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	if(themeManager) {
		
		// Make sure our own height is right, and not using
		// a NSMatrix parents height.
		cellFrame.size.height = [self cellSize].height;
		
		// Adjust frame to account for drop shadow
		cellFrame.origin.x += 3;
		cellFrame.size.width -= 6;
		cellFrame.size.height -= 3;
		
		switch ([self bezelStyle]) {
				
			case NSTexturedRoundedBezelStyle:
				
				[self drawTexturedRoundedButtonInFrame: cellFrame];
				break;
				
			case NSRoundRectBezelStyle:
				
				[self drawRoundRectButtonInFrame: cellFrame];
				break;
				
			case NSSmallSquareBezelStyle:
				
				[self drawSmallSquareButtonInFrame: cellFrame];
				break;
				
			case NSRoundedBezelStyle:
				
				[self drawRoundedButtonInFrame: cellFrame];
				break;
		}
		
		if([[_normalImage name] isEqualToString: @"NSSwitch"] ||
		   [[_normalImage name] isEqualToString: @"NSRadioButton"]) {
			
			if([self imagePosition] != NSNoImage) {
				
				[self drawImage: [self image] withFrame: cellFrame inView: [self controlView]];
			}
		}
	} else {
		
		[super drawWithFrame: cellFrame inView: controlView];
	}
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView {
	
	if(themeManager) {
		
		NSMutableAttributedString *newTitle = [[NSMutableAttributedString alloc] initWithAttributedString: title];
		
		//Setup per State and Highlight Settings
		if([self showsStateBy] == 0 && [self highlightsBy] == 1) {
			
			if([self isHighlighted]) {
				
				if([self alternateTitle]) {
					
					[newTitle setAttributedString: [self attributedAlternateTitle]];
				}
			}
		}
		
		if([self showsStateBy] == 1 && [self highlightsBy] == 3) {
			
			if([self state] == 1) {
				
				if([self alternateTitle]) {
					
					[newTitle setAttributedString: [self attributedAlternateTitle]];
				}
			}
		}
		
		[newTitle beginEditing];
		
		[newTitle removeAttribute: NSShadowAttributeName
							range: NSMakeRange(0, [newTitle length])];
		
		[newTitle addAttribute: NSForegroundColorAttributeName
						 value: [themeManager textColor]
						 range: NSMakeRange(0, [newTitle length])];
		
		[newTitle endEditing];
		
		NSRect textRect = frame;
		
		// Adjust Text Rect based on control type and size
		if([[_normalImage name] isEqualToString: @"NSSwitch"] ||
		   [[_normalImage name] isEqualToString: @"NSRadioButton"]) {
			
		} else {
			
			textRect.origin.x += 5;
			textRect.size.width -= 10;
			textRect.size.height -= 2;
		}
		
		//Make the super class do the drawing
		[super drawTitle: newTitle withFrame: textRect inView: controlView];
		
		[newTitle release];
		
		return textRect;
	} else {
		
		return [super drawTitle: title withFrame: frame inView: controlView];
	}
}

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView {
	
	if(themeManager) {
		
		//Ugly hack to determine if this is a Check or Radio button.
		if([[_normalImage name] isEqualToString: @"NSSwitch"]) {
			
			[self drawCheckInFrame: frame isRadio: NO];		
		} else if([[_normalImage name] isEqualToString: @"NSRadioButton"]) {
			
			[self drawCheckInFrame: frame isRadio: YES];
		} else {
			
			//Setup per State and Highlight Settings
			if([self showsStateBy] == 0 && [self highlightsBy] == 1) {
				
				if([self isHighlighted]) {
					
					if([self alternateImage]) {
						
						image = [self alternateImage];
					}
				}
			}
			
			if([self showsStateBy] == 1 && [self highlightsBy] == 3) {
				
				if([self state] == 1) {
					
					if([self alternateImage]) {
						
						image = [self alternateImage];
					}
				}
			}
			
			NSRect imageRect = frame;
			imageRect.size.height = [image size].height;
			imageRect.size.width = [image size].width;
			imageRect.origin.y += (frame.size.height /2) - (imageRect.size.height /2);
			
			//Setup Position
			switch ([self imagePosition]) {
					
				case NSImageLeft:
					
					imageRect.origin.x += 5;
					break;
					
				case NSImageOnly:
					
					imageRect.origin.x += (frame.size.width /2) - (imageRect.size.width /2);
					break;
					
				case NSImageRight:
					
					imageRect.origin.x = ((frame.origin.x + frame.size.width) - imageRect.size.width) - 5;
					break;
					
				case NSImageBelow:
					
					break;
					
				case NSImageAbove:
					
					break;
					
				case NSImageOverlaps:
					
					break;
					
				default:
					
					imageRect.origin.x += 5;
					break;
			}
			
			[image setFlipped: YES];
			[image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: [themeManager alphaValue]];
		}
	} else {
		
		[super drawImage: image withFrame: frame inView: controlView];
	}
}

-(void)drawTexturedRoundedButtonInFrame:(NSRect)frame {
	
	//Adjust Rect so strokes true
	frame.origin.y += 0.5;
	frame.origin.x += 0.5;
	frame.size.width -= 1;
	frame.size.height -= 1;
	
	//Adjust Rect based on ControlSize
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.y += 1;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.y += 3;
			frame.size.height += 2;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.y += 5;
			frame.size.height += 1;
			break;
	}
	
	//Draw Outer-most ring
	NSBezierPath *path = [[NSBezierPath alloc] init];
	[path appendBezierPathWithRoundedRect: frame xRadius: 4.0 yRadius: 4.0];
	
	//Save Graphics State
	[NSGraphicsContext saveGraphicsState];
	
	[[themeManager dropShadow] set];
	
	//Draw Dark Border
	[[themeManager darkStrokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	//Restore Graphics State
	[NSGraphicsContext restoreGraphicsState];
	
	//Draw Background
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[themeManager highlightGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[themeManager normalGradient] drawInBezierPath: path angle: 90];
		}
	} else {
		
		if([self isHighlighted]) {
			
			[[themeManager pushedGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[themeManager normalGradient] drawInBezierPath: path angle: 90];
		}
	}
	
	//Draw Border
	[[themeManager strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	//path = nil;
	[path release];
	
	if([self imagePosition] != NSImageOnly) {
	 
		[self drawTitle: [self attributedTitle] withFrame: frame inView: [self controlView]];
	}
	
	if([self imagePosition] != NSNoImage) {
		
		[self drawImage: [self image] withFrame: frame inView: [self controlView]];
	}
}

-(void)drawRoundRectButtonInFrame:(NSRect)frame {
	
	// Adjust Rect so stroke draws true
	frame.origin.x += .5;
	frame.size.height -= 1;
	frame.size.width -= 1;
	
	//Adjust Rect based on ControlSize
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.size.height += 3;
			break;
			
		case NSSmallControlSize:
			
			frame.size.height += 3;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.y += 1;
			frame.size.height += 1;
			break;
	}
	
	//Create Path
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	[path appendBezierPathWithArcWithCenter: NSMakePoint(frame.origin.x + (frame.size.height /2), (frame.size.height /2) +.5+frame.origin.y)
										   radius: (frame.size.height /2)
									   startAngle: 90
										 endAngle: 270];
	
	[path appendBezierPathWithArcWithCenter: NSMakePoint((frame.size.width + frame.origin.x) - (frame.size.height /2), (frame.size.height /2) +.5+frame.origin.y)
										   radius: (frame.size.height /2)
									   startAngle: 270
										 endAngle: 90];
	
	[path closePath];
	
	[NSGraphicsContext saveGraphicsState];
	
	//Draw dark border color
	[[themeManager dropShadow] set];
	[[themeManager darkStrokeColor] set];
	[path stroke];
	
	[NSGraphicsContext restoreGraphicsState];
	
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[themeManager highlightGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[themeManager normalGradient] drawInBezierPath: path angle: 90];
		}
	} else {
		
		if([self isHighlighted]) {
			
			[[themeManager pushedGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[themeManager normalGradient] drawInBezierPath: path angle: 90];
		}
	}
	
	//Draw Border
	[[themeManager strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	//path = nil;
	[path release];
	
	if([self imagePosition] != NSImageOnly) {
		
		[self drawTitle: [self attributedTitle] withFrame: frame inView: [self controlView]];
	}
	
	if([self imagePosition] != NSNoImage) {
		
		[self drawImage: [self image] withFrame: frame inView: [self controlView]];
	}
}

-(void)drawSmallSquareButtonInFrame:(NSRect)frame {

	//Adjust rect so stroke is true
	frame.origin.x += 0.5;
	frame.origin.y += 1.5;
	frame.size.width -= 1;
	
	//Adjust Rect based on ControlSize
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			//frame.origin.y += 1;
			break;
			
		case NSSmallControlSize:
			
			//frame.origin.y += 3;
			//frame.size.height += 2;
			break;
			
		case NSMiniControlSize:
			
			//frame.origin.y += 5;
			//frame.size.height += 1;
			break;
	}
	
	//Draw Outer-most ring
	NSBezierPath *path = [[NSBezierPath alloc] init];
	[path appendBezierPathWithRect: frame];
	
	[NSGraphicsContext saveGraphicsState];
	
	[[themeManager dropShadow] set];
	[[themeManager darkStrokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	[NSGraphicsContext restoreGraphicsState];
	
	//Draw Background
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[themeManager highlightComplexGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[themeManager normalComplexGradient] drawInBezierPath: path angle: 90];
		}
	} else {
		
		if([self isHighlighted]) {
			
			[[themeManager pushedComplexGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[themeManager normalComplexGradient] drawInBezierPath: path angle: 90];
		}
	}
	
	//Draw Border
	[[themeManager strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	//path = nil;
	[path release];
	
	if([self imagePosition] != NSImageOnly) {
		
		[self drawTitle: [self attributedTitle] withFrame: frame inView: [self controlView]];
	}
	
	if([self imagePosition] != NSNoImage) {
		
		[self drawImage: [self image] withFrame: frame inView: [self controlView]];
	}
}

-(void)drawRoundedButtonInFrame:(NSRect)frame {
	
	// Adjust Rect so stroke draws true
	frame.origin.x += .5;
	frame.origin.y += .5;
	frame.size.height -= 1;
	frame.size.width -= 1;
	
	//Adjust Rect based on ControlSize
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 4;
			frame.origin.y += 4;
			frame.size.width -= 8;
			frame.size.height -= 7;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += 4;
			frame.origin.y += 4;
			frame.size.width -= 8;
			frame.size.height -= 7;
			break;
			
		case NSMiniControlSize:
			
			//frame.origin.x += 4;
			frame.origin.y -= 1;
			//frame.size.width -= 8;
			frame.size.height += 3;
			break;
	}
	
	//Create Path
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	[path appendBezierPathWithArcWithCenter: NSMakePoint(frame.origin.x + (frame.size.height /2), (frame.size.height /2) +.5+frame.origin.y)
									 radius: (frame.size.height /2)
								 startAngle: 90
								   endAngle: 270];
	
	[path appendBezierPathWithArcWithCenter: NSMakePoint((frame.size.width + frame.origin.x) - (frame.size.height /2), (frame.size.height /2) +.5+frame.origin.y)
									 radius: (frame.size.height /2)
								 startAngle: 270
								   endAngle: 90];
	
	[path closePath];
	
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[themeManager highlightSolidFill] set];
			[path fill];
		} else {
			
			[[themeManager normalSolidFill] set];
			[path fill];
		}
	} else {
		
		if([self isHighlighted]) {
			
			[[themeManager pushedSolidFill] set];
			[path fill];
		} else {
			
			[[themeManager normalSolidFill] set];
			[path fill];
		}
	}
	
	//path = nil;
	[path release];
	
	if([self imagePosition] != NSImageOnly) {
		
		[self drawTitle: [self attributedTitle] withFrame: frame inView: [self controlView]];
	}
	
	if([self imagePosition] != NSNoImage) {
		
		[self drawImage: [self image] withFrame: frame inView: [self controlView]];
	}
}

-(void)drawCheckInFrame:(NSRect)frame isRadio:(BOOL)radio{
	
	//Adjust by .5 so lines draw true
	frame.origin.x += .5;
	frame.origin.y += .5;

	// Create Check Rect
	NSRect innerRect = frame;
	NSRect textRect = frame;
	
	//Make adjustments based on ControlSize
	//Set checkbox size
	if([self controlSize] == NSRegularControlSize) {
		
		innerRect.size.height = 12;
		innerRect.size.width = 13;
		innerRect.origin.y += 2;
	} else if([self controlSize] == NSSmallControlSize) {
		
		innerRect.size.height = 10;
		innerRect.size.width = 11;
		innerRect.origin.y += 3;
	} else {
		
		innerRect.size.height = 8;
		innerRect.size.width = 9;
		innerRect.origin.y += 5;
	}
	
	if(radio) {
	
		innerRect.size.height = innerRect.size.width;
	}
	
	// Determine Horizontal Placement
	switch ([self imagePosition]) {
			
		case NSImageLeft:
			
			//Make adjustments to horizontal placement
			//Create Text Rect so text is drawn properly
			if([self controlSize] == NSRegularControlSize) {
				
				innerRect.origin.x += 2;

				textRect.size.width -= (innerRect.origin.x + innerRect.size.width + 5) ;
				textRect.origin.x = innerRect.origin.x + innerRect.size.width + 5;
				
			} else if([self controlSize] == NSSmallControlSize) {
				
				innerRect.origin.x += 3;
				
				textRect.size.width -= (innerRect.origin.x + innerRect.size.width + 6) ;
				textRect.origin.x = innerRect.origin.x + innerRect.size.width + 6;
			} else {
				
				innerRect.origin.x += 4;
				
				textRect.size.width -= (innerRect.origin.x + innerRect.size.width + 4) ;
				textRect.origin.x = innerRect.origin.x + innerRect.size.width + 4;
			}
			
			break;
			
		case NSImageOnly:
			
			//Adjust slightly so lines draw true, and center really is
			//center
			if([self controlSize] == NSRegularControlSize) {
				
				innerRect.origin.x -= .5;
			} else if([self controlSize] == NSMiniControlSize) {
				
				innerRect.origin.x += .5;
			}
			
			innerRect.origin.x += (frame.size.width /2) - (innerRect.size.width /2);
			break;
			
		case NSImageRight:
			
			if([self controlSize] == NSRegularControlSize) {
				
				innerRect.origin.x = (frame.size.width - innerRect.size.width) +.5;
				
				textRect.origin.x += 2;
				textRect.size.width = innerRect.origin.x - textRect.origin.x -5;
			} else if([self controlSize] == NSSmallControlSize) {
				
				innerRect.origin.x = frame.size.width - innerRect.size.width -.5;
				
				textRect.origin.x += 2;
				textRect.size.width = innerRect.origin.x - textRect.origin.x -5;
			} else {
				
				innerRect.origin.x = frame.size.width - innerRect.size.width -1.5;
				
				textRect.origin.x += 2;
				textRect.size.width = innerRect.origin.x - textRect.origin.x -5;
			}
			
			break;
			
		case NSImageBelow:
			
			break;
			
		case NSImageAbove:
			
			break;
			
		case NSImageOverlaps:
			
			break;
	}
	
	// Create Rounded Rect Path
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	if(radio) {
		
		[path appendBezierPathWithOvalInRect: innerRect];
	} else {
		
		[path appendBezierPathWithRoundedRect: innerRect xRadius: 2 yRadius: 2];
	}
	
	[NSGraphicsContext saveGraphicsState];
	//Draw Shadow
	[[themeManager dropShadow] set];
	[[themeManager darkStrokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	// Determine Fill Color and Alpha Values
	if([self isHighlighted]) {
		
		[[themeManager highlightGradient] drawInBezierPath: path angle: 90];
	} else {
		
		[[themeManager normalGradient] drawInBezierPath: path angle: 90];
	}
	
	// Outline the path
	[[themeManager strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	[path release];
	
	// Draw Glyphs for On/Off/Mixed States
	switch ([self state]) {
			
		case NSMixedState:
			
			path = [[NSBezierPath alloc] init];
			NSPoint pointsMixed[2];
			
			pointsMixed[0] = NSMakePoint(innerRect.origin.x + 3, innerRect.origin.y + (innerRect.size.height / 2));
			pointsMixed[1] = NSMakePoint(innerRect.origin.x + innerRect.size.width - 3, innerRect.origin.y + (innerRect.size.height /2));
			
			[path appendBezierPathWithPoints: pointsMixed count: 2];
			
			[[themeManager strokeColor] set];
			[path setLineWidth: 2.0];
			[path stroke];
			
			[path release];
			 
			break;
			
		case NSOnState:

			if(radio) {
				
				if([self controlSize] == NSRegularControlSize) {
					
					innerRect.origin.x += 4;
					innerRect.origin.y += 4;
					innerRect.size.width -= 8;
					innerRect.size.height -= 8;
				} else if([self controlSize] == NSSmallControlSize) {
					
					innerRect.origin.x += 3.5;
					innerRect.origin.y += 3.5;
					innerRect.size.width -= 7;
					innerRect.size.height -= 7;
				} else {
					
					innerRect.origin.x += 3;
					innerRect.origin.y += 3;
					innerRect.size.width -= 6;
					innerRect.size.height -= 6;
				}
				
				
				path = [[NSBezierPath alloc] init];
				[path appendBezierPathWithOvalInRect: innerRect];
				
				[[themeManager strokeColor] set];
				[path fill];
				
				[path release];
			} else {
				
				path = [[NSBezierPath alloc] init];
				NSPoint pointsOn[4];
				
				pointsOn[0] = NSMakePoint(innerRect.origin.x + 3, innerRect.origin.y + (innerRect.size.height /2) - 2);
				pointsOn[1] = NSMakePoint(innerRect.origin.x + (innerRect.size.width / 2), innerRect.origin.y + (innerRect.size.height / 2) + 2);
				pointsOn[2] = NSMakePoint(innerRect.origin.x + (innerRect.size.width / 2), innerRect.origin.y + (innerRect.size.height / 2) + 2);
				pointsOn[3] = NSMakePoint(innerRect.origin.x + innerRect.size.width - 1, innerRect.origin.y -2);
				
				[path appendBezierPathWithPoints: pointsOn count: 4];
				
				[[themeManager strokeColor] set];
				if([self controlSize] == NSMiniControlSize) {
					
					[path setLineWidth: 1.5];
				} else {
					
					[path setLineWidth: 2.0];
				}
				
				[path stroke];
				
				[path release];
			}
			
			break;
	}
	
	if([self imagePosition] != NSImageOnly) {
		[self drawTitle: [self attributedTitle] withFrame: textRect inView: [self controlView]];
	}
}

#pragma mark -
#pragma mark Helper Methods

-(void)setThemeManager:(BGThemeManager *)manager {
	
	themeManager = [manager retain];
}

-(void)dealloc {
	
	[themeManager release];
	[super dealloc];
}

#pragma mark -

@end
