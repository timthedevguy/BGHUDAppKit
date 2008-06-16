//
//  BGGradientTheme.m
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

#import "BGGradientTheme.h"


@implementation BGGradientTheme

-(NSGradient *)normalGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324 green: 0.331 blue: 0.347 alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.245 green: 0.253 blue: 0.269 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.206 green: 0.214 blue: 0.233 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.139 green: 0.147 blue: 0.167 alpha: [self alphaValue]], (CGFloat)1.0, nil] autorelease];
}

-(NSGradient *)pushedGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524 green: 0.531 blue: 0.547 alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445 green: 0.453 blue: 0.469 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406 green: 0.414 blue: 0.433 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339 green: 0.347 blue: 0.367 alpha: [self alphaValue]], (CGFloat)1.0, nil] autorelease];
}

-(NSGradient *)highlightGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.524 green: 0.531 blue: 0.547 alpha: [self alphaValue]],
			 (CGFloat)0, [NSColor colorWithDeviceRed: 0.445 green: 0.453 blue: 0.469 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.406 green: 0.414 blue: 0.433 alpha: [self alphaValue]], (CGFloat).5,
			 [NSColor colorWithDeviceRed: 0.339 green: 0.347 blue: 0.367 alpha: [self alphaValue]], (CGFloat)1.0, nil] autorelease];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 0.7];
}

-(float)alphaValue {
	
	return 0.7;
}

@end
