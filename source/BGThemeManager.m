//
//  BGThemeManager.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/15/08.
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

#import "BGThemeManager.h"


@implementation BGThemeManager

#pragma mark Scroller Theme

-(NSColor *)scrollerStroke {

	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 1.0];
}

-(NSGradient *)scrollerKnobGradient {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.631 green: 0.639 blue: 0.655 alpha: 1.0]
										  endingColor: [NSColor colorWithDeviceRed: 0.439 green: 0.447 blue: 0.471 alpha: 1.0]] autorelease];
}

-(NSGradient *)scrollerTrackGradient {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.137 green: 0.137 blue: 0.137 alpha: .75]
										  endingColor: [NSColor colorWithDeviceRed: 0.278 green: 0.278 blue: 0.278 alpha: .75]] autorelease];
}

-(NSGradient *)scrollerArrowNormalGradient {

	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251 green: 0.251 blue: 0.255 alpha: [self scrollerAlphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.118 green: 0.118 blue: 0.118 alpha: [self scrollerAlphaValue]]] autorelease];
}

-(NSGradient *)scrollerArrowPushedGradient {

	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451 green: 0.451 blue: 0.455 alpha: [self scrollerAlphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.318 green: 0.318 blue: 0.318 alpha: [self scrollerAlphaValue]]] autorelease];
}

-(float)scrollerAlphaValue {

	return 0.5;
}

#pragma mark -
#pragma mark Slider Theme

-(NSColor *)sliderTrackColor {
	
	return [NSColor colorWithDeviceRed: 0.318 green: 0.318 blue: 0.318 alpha: .6];
}

#pragma mark -
#pragma mark Text Based Theme

-(NSColor *)textFillColor {
	
	return [NSColor colorWithDeviceRed: .224 green: .224 blue: .224 alpha: .95];
}

#pragma mark -
#pragma mark Progress Theme

-(NSGradient *)progressTrackGradient {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedRed: 0.125 green: 0.125 blue: 0.125 alpha: 1.0]
										  endingColor: [NSColor colorWithCalibratedRed: 0.208 green: 0.208 blue: 0.208 alpha: 1.0]] autorelease];
}

#pragma mark -
#pragma mark Token Theme

-(NSColor *)tokenFillNormal {
	
	return [NSColor colorWithDeviceRed: 0.249 green: 0.261 blue: 0.288 alpha: 1.0];
}

-(NSColor *)tokenFillHighlight {
	
	return [NSColor colorWithDeviceRed: 0.449 green: 0.461 blue: 0.488 alpha: 1.0];
}

-(NSColor *)tokenBorder {
	
	return [NSColor whiteColor];
}

-(NSColor *)tokenTextColor {
	
	return [NSColor whiteColor];
}

#pragma mark -
#pragma mark Table Theme

-(NSColor *)cellHighlightColor {
	
	return [NSColor colorWithDeviceRed: 0.549 green: 0.561 blue: 0.588 alpha: 1];
}

-(NSArray *)cellAlternatingRowColors {
	
	return [NSArray arrayWithObjects:
			[NSColor colorWithCalibratedWhite: 0.16 alpha: 0.86], 
			[NSColor colorWithCalibratedWhite: 0.15 alpha: 0.8], 
			nil];
}

-(NSColor *)cellSelectedTextColor {
	
	return [NSColor blackColor];
}

-(NSColor *)tableBackgroundColor {
	
	return [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: .00];
}

-(NSColor *)tableHeaderCellBorderColor {

	return [NSColor colorWithDeviceRed: 0.349 green: 0.361 blue: 0.388 alpha: 1.0];
}

-(NSGradient *)tableHeaderCellNormalFill {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251 green: 0.251 blue: 0.255 alpha: 1.0]
										  endingColor: [NSColor colorWithDeviceRed: 0.118 green: 0.118 blue: 0.118 alpha: 1.0]] autorelease];
}

-(NSGradient *)tableHeaderCellPushedFill {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451 green: 0.451 blue: 0.455 alpha: 1.0]
										  endingColor: [NSColor colorWithDeviceRed: 0.318 green: 0.318 blue: 0.318 alpha: 1.0]] autorelease];
}

#pragma mark -
#pragma mark General Theme

-(NSGradient *)normalGradient {

	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.251 green: 0.251 blue: 0.255 alpha: [self alphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.118 green: 0.118 blue: 0.118 alpha: [self alphaValue]]] autorelease];
}

-(NSGradient *)pushedGradient {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451 green: 0.451 blue: 0.455 alpha: [self alphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.318 green: 0.318 blue: 0.318 alpha: [self alphaValue]]] autorelease];
}

-(NSGradient *)highlightGradient {
	
	return [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithDeviceRed: 0.451 green: 0.451 blue: 0.455 alpha: [self alphaValue]]
										  endingColor: [NSColor colorWithDeviceRed: 0.318 green: 0.318 blue: 0.318 alpha: [self alphaValue]]] autorelease];
}

-(NSGradient *)normalComplexGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324 green: 0.331 blue: 0.347 alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245 green: 0.253 blue: 0.269 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206 green: 0.214 blue: 0.233 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139 green: 0.147 blue: 0.167 alpha: [self alphaValue]], (CGFloat)1.0, nil] autorelease];
}

-(NSGradient *)pushedComplexGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524 green: 0.531 blue: 0.547 alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445 green: 0.453 blue: 0.469 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406 green: 0.414 blue: 0.433 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339 green: 0.347 blue: 0.367 alpha: [self alphaValue]], (CGFloat)1.0, nil] autorelease];
}

-(NSGradient *)highlightComplexGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524 green: 0.531 blue: 0.547 alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445 green: 0.453 blue: 0.469 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406 green: 0.414 blue: 0.433 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339 green: 0.347 blue: 0.367 alpha: [self alphaValue]], (CGFloat)1.0, nil] autorelease];
}

-(NSColor *)normalSolidFill {

	return [NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: [self alphaValue]];
}

-(NSColor *)pushedSolidFill {
	
	return [NSColor colorWithDeviceRed: 0.941 green: 0.941 blue: 0.941 alpha: [self alphaValue]];
}

-(NSColor *)highlightSolidFill {

	return [NSColor colorWithDeviceRed: 0.941 green: 0.941 blue: 0.941 alpha: [self alphaValue]];
}

-(NSColor *)strokeColor {

	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 1.0];
}

-(NSColor *)darkStrokeColor {

	return [NSColor colorWithDeviceRed: 0.141 green: 0.141 blue: 0.141 alpha: 0.5];
}

-(NSColor *)textColor {

	return [NSColor whiteColor];
}

-(NSShadow *)dropShadow {

	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [NSColor blackColor]];
	[shadow setShadowBlurRadius: 2];
	[shadow setShadowOffset: NSMakeSize( 0, -1)];
	
	return [shadow autorelease];
}

-(float)alphaValue {

	return 0.6;
}

#pragma mark -

-(void)dealloc {
	
	[super dealloc];
}

@end
