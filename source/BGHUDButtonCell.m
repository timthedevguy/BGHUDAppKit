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
	}
	
	return self;
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	// Make sure our own height is right, and not using
	// a NSMatrix parents height.
	cellFrame.size.height = [self cellSize].height;
	
	/*NSBezierPath *path = [NSBezierPath bezierPathWithRect: cellFrame];
	[[NSColor redColor] set];
	[path stroke];*/
	
	// Adjust frame to account for drop shadow
	cellFrame.origin.x += 3;
	cellFrame.size.width -= 6;
	cellFrame.size.height -= 3;
	
	/*NSBezierPath *path1 = [NSBezierPath bezierPathWithRect: cellFrame];
	[[NSColor greenColor] set];
	[path1 stroke];*/
	
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
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView {
	
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
	
	[newTitle removeAttribute: NSShadowAttributeName range: NSMakeRange(0, [newTitle length])];
	[newTitle addAttribute: NSForegroundColorAttributeName value: [NSColor whiteColor] range: NSMakeRange(0, [newTitle length])];
	
	[newTitle endEditing];
	
	//[self setAttributedTitle: newTitle];
	
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
	
	return textRect;
}

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView {
	
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
		[image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: [self alphaValue]];
		
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
	
	[[self dropShadow] set];
	
	//Draw Dark Border
	[[NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: 0.5] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	//Restore Graphics State
	[NSGraphicsContext restoreGraphicsState];
	
	//Draw Background
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[self highlightGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[self normalGradient] drawInBezierPath: path angle: 90];
		}
	} else {
		
		[[self normalGradient] drawInBezierPath: path angle: 90];
	}
	
	//Draw Border
	[[self strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	path = nil;
	
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
	[[self dropShadow] set];
	[[self darkStrokeColor] set];
	[path stroke];
	
	[NSGraphicsContext restoreGraphicsState];
	
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[self highlightGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[self normalGradient] drawInBezierPath: path angle: 90];
		}
	} else {
		
		[[self normalGradient] drawInBezierPath: path angle: 90];
	}
	
	//Draw Border
	[[self strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	path = nil;
	
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
	
	[[self dropShadow] set];
	[[self darkStrokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	[NSGraphicsContext restoreGraphicsState];
	
	//Draw Background
	if(([self showsStateBy] == 12 && [self highlightsBy] == 14) ||
	   ([self showsStateBy] == 12 && [self highlightsBy] == 12)) {
		
		if([self state] == 1) {
			
			[[self highlightComplexGradient] drawInBezierPath: path angle: 90];
		} else {
			
			[[self normalComplexGradient] drawInBezierPath: path angle: 90];
		}
	} else {
		
		[[self normalComplexGradient] drawInBezierPath: path angle: 90];
	}
	
	//Draw Border
	[[self strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	path = nil;
	
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
			
			[[self solidHighlightColor] set];
			[path fill];
		} else {
			
			[[self solidNormalColor] set];
			[path fill];
		}
	} else {
		
		[[self solidNormalColor] set];
		[path fill];
	}
	
	path = nil;
	
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
	[[self dropShadow] set];
	[[self darkStrokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	// Determine Fill Color and Alpha Values
	if([self isHighlighted]) {
		
		[[self highlightGradient] drawInBezierPath: path angle: 90];
	} else {
		
		[[self normalGradient] drawInBezierPath: path angle: 90];
	}
	
	// Outline the path
	[[self strokeColor] set];
	[path setLineWidth: 1.0];
	[path stroke];
	
	// Draw Glyphs for On/Off/Mixed States
	switch ([self state]) {
			
		case NSMixedState:
			
			path = [[NSBezierPath alloc] init];
			NSPoint pointsMixed[2];
			
			pointsMixed[0] = NSMakePoint(innerRect.origin.x + 3, innerRect.origin.y + (innerRect.size.height / 2));
			pointsMixed[1] = NSMakePoint(innerRect.origin.x + innerRect.size.width - 3, innerRect.origin.y + (innerRect.size.height /2));
			
			[path appendBezierPathWithPoints: pointsMixed count: 2];
			
			[[self strokeColor] set];
			[path setLineWidth: 2.0];
			[path stroke];
			
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
				[[self strokeColor] set];
				[path fill];
			} else {
				
				path = [[NSBezierPath alloc] init];
				NSPoint pointsOn[4];
				
				pointsOn[0] = NSMakePoint(innerRect.origin.x + 3, innerRect.origin.y + (innerRect.size.height /2) - 2);
				pointsOn[1] = NSMakePoint(innerRect.origin.x + (innerRect.size.width / 2), innerRect.origin.y + (innerRect.size.height / 2) + 2);
				pointsOn[2] = NSMakePoint(innerRect.origin.x + (innerRect.size.width / 2), innerRect.origin.y + (innerRect.size.height / 2) + 2);
				pointsOn[3] = NSMakePoint(innerRect.origin.x + innerRect.size.width - 1, innerRect.origin.y -2);
				
				[path appendBezierPathWithPoints: pointsOn count: 4];
				
				[[self strokeColor] set];
				if([self controlSize] == NSMiniControlSize) {
					
					[path setLineWidth: 1.5];
				} else {
					
					[path setLineWidth: 2.0];
				}
				
				[path stroke];
			}
			
			break;
	}
	
	path = nil;
	
	if([self imagePosition] != NSImageOnly) {
		[self drawTitle: [self attributedTitle] withFrame: textRect inView: [self controlView]];
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

-(NSColor *)solidNormalColor {
	
	return [NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: [self alphaValue]];
}

-(NSColor *)solidHighlightColor {
	
	return [NSColor colorWithDeviceRed: 0.941 green: 0.941 blue: 0.941 alpha: [self alphaValue]];
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
