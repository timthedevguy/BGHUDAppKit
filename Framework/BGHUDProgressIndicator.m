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

@interface BGHUDProgressIndicator()
NSTimer *spinningAnimationTimer;
int spinningAnimationIndex;
NSThread *spinningAnimationThread;
BOOL isAnimating;
@end

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
		
		CGFloat step = (frame.size.height / 4)*4;
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

#define NUM_FINS 12

- (void)drawSpinningStyleIndicator {
    // Determine size based on current bounds
    NSSize size = [self bounds].size;
    float theMaxSize = MIN(size.width,size.height);
	
	[NSGraphicsContext saveGraphicsState];
    CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
    // Move the CTM so 0,0 is at the center of our bounds
    CGContextTranslateCTM(currentContext,[self bounds].size.width/2,[self bounds].size.height/2);
	
	NSColor *foreColor = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor];
	float alpha = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] alphaValue];
	
    if ([self isIndeterminate]) {
        CGContextRotateCTM(currentContext, M_PI * 2.0f * spinningAnimationIndex / NUM_FINS);
		
        NSBezierPath *path = [[NSBezierPath alloc] init];
        float lineWidth = 0.0859375 * theMaxSize; // should be 2.75 for 32x32
        float lineStart = 0.234375 * theMaxSize; // should be 7.5 for 32x32
        float lineEnd = 0.421875 * theMaxSize;  // should be 13.5 for 32x32
        [path setLineWidth:lineWidth];
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path moveToPoint:NSMakePoint(0,lineStart)];
        [path lineToPoint:NSMakePoint(0,lineEnd)];

		int i;
        for (i = 0; i < NUM_FINS; i++) {
			[[foreColor colorWithAlphaComponent:alpha] set];
            [path stroke];
            CGContextRotateCTM(currentContext, -M_PI * 2.0f/NUM_FINS);
            alpha -= 1.0/NUM_FINS;
        }
        [path release];
    }
    else {
        float lineWidth = 1 + (0.01 * theMaxSize);
        float circleRadius = (theMaxSize - lineWidth) / 2.1;
        NSPoint circleCenter = NSMakePoint(0, 0);
        [[foreColor colorWithAlphaComponent:alpha] set];
        NSBezierPath *path = [[NSBezierPath alloc] init];
        [path setLineWidth:lineWidth];
        [path appendBezierPathWithOvalInRect:NSMakeRect(-circleRadius, -circleRadius, circleRadius*2, circleRadius*2)];
        [path stroke];
        [path release];
        path = [[NSBezierPath alloc] init];
        [path appendBezierPathWithArcWithCenter:circleCenter radius:circleRadius startAngle:90 endAngle:90-(360*([self doubleValue]/[self maxValue])) clockwise:YES];
        [path lineToPoint:circleCenter] ;
        [path fill];
        [path release];
    }
	
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawRect:(NSRect)dirtyRect {
	if ([self style] == NSProgressIndicatorBarStyle) {
		[self _drawThemeBackground];
		[self _drawThemeProgressArea:YES];
	}
	else if ([self style] == NSProgressIndicatorSpinningStyle) {
		[self drawSpinningStyleIndicator];
	}
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[progressPath release];
	[super dealloc];
}

#pragma mark -

- (void)updateFrame:(NSTimer *)timer;
{
    if(spinningAnimationIndex < NUM_FINS) {
        spinningAnimationIndex++;
    }
    else {
        spinningAnimationIndex = 0;
    }
    
    if ([self usesThreadedAnimation]) {
        // draw now instead of waiting for setNeedsDisplay (that's the whole reason
        // we're animating from background thread)
        [self setNeedsDisplay:YES];
		[self display];
    }
    else {
        [self setNeedsDisplay:YES];
    }
}

- (void)animateInBackgroundThread
{
	NSAutoreleasePool *animationPool = [[NSAutoreleasePool alloc] init];
	
	// Set up the animation speed to subtly change with size > 32.
	// int animationDelay = 38000 + (2000 * ([self bounds].size.height / 32));
    
    // Set the rev per minute here
    int omega = 100; // RPM
    int animationDelay = 60*1000000/omega/NUM_FINS;
	int poolFlushCounter = 0;
    
	do {
		[self updateFrame:nil];
		usleep(animationDelay);
		poolFlushCounter++;
		if (poolFlushCounter > 256) {
			[animationPool drain];
			animationPool = [[NSAutoreleasePool alloc] init];
			poolFlushCounter = 0;
		}
	} while (![[NSThread currentThread] isCancelled]); 
    
	[animationPool release];
}

- (void)actuallyStopAnimation
{
    if (spinningAnimationThread) {
        // we were using threaded animation
		[spinningAnimationThread cancel];
		if (![spinningAnimationThread isFinished]) {
			[[NSRunLoop currentRunLoop] runMode:NSModalPanelRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
		}
		[spinningAnimationThread release];
        spinningAnimationThread = nil;
	}
    else if (spinningAnimationTimer) {
        // we were using timer-based animation
        [spinningAnimationTimer invalidate];
        [spinningAnimationTimer release];
        spinningAnimationTimer = nil;
    }
    [self setNeedsDisplay:YES];
}

- (void)actuallyStartAnimation
{
    // Just to be safe kill any existing timer.
    [self actuallyStopAnimation];
	
    if ([self window]) {
        // Why animate if not visible?  viewDidMoveToWindow will re-call this method when needed.
        if ([self usesThreadedAnimation]) {
            spinningAnimationThread = [[NSThread alloc] initWithTarget:self selector:@selector(animateInBackgroundThread) object:nil];
            [spinningAnimationThread start];
        }
        else {
            spinningAnimationTimer = [[NSTimer timerWithTimeInterval:(NSTimeInterval)0.05
															  target:self
															selector:@selector(updateFrame:)
															userInfo:nil
															 repeats:YES] retain];
            
            [[NSRunLoop currentRunLoop] addTimer:spinningAnimationTimer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] addTimer:spinningAnimationTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] addTimer:spinningAnimationTimer forMode:NSEventTrackingRunLoopMode];
        }
    }
}

- (void)startAnimation:(id)sender
{
    if ([self style] == NSProgressIndicatorSpinningStyle) {
		if (![self isIndeterminate]) return;
		if (isAnimating) return;
		
		if (![self isDisplayedWhenStopped])
			[self setHidden:NO];
		
		[self actuallyStartAnimation];
		isAnimating = YES;
	}
	else {
		[super startAnimation:sender];
	}
}

- (void)stopAnimation:(id)sender
{
    if ([self style] == NSProgressIndicatorSpinningStyle) {
		[self actuallyStopAnimation];
		isAnimating = NO;
		
		if (![self isDisplayedWhenStopped])
			[self setHidden:YES];
	}
	else {
		[super startAnimation:sender];
	}
}

@end
