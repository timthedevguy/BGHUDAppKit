//
//  BGHUDGradientPopUpButtonCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDGradientPopUpButtonCell.h"


@implementation BGHUDGradientPopUpButtonCell

-(NSGradient *)normalGradient {
	
	return [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceRed: 0.324 green: 0.331 blue: 0.347 alpha: [self alphaValue]],
			(CGFloat)0, [NSColor colorWithDeviceRed: 0.245 green: 0.253 blue: 0.269 alpha: [self alphaValue]], (CGFloat).5,
			[NSColor colorWithDeviceRed: 0.206 green: 0.214 blue: 0.233 alpha: [self alphaValue]], (CGFloat).5,
			[NSColor colorWithDeviceRed: 0.139 green: 0.147 blue: 0.167 alpha: [self alphaValue]], (CGFloat)1.0, nil];
}

-(NSColor *)strokeColor {
	
	return [NSColor colorWithDeviceRed: 0.749 green: 0.761 blue: 0.788 alpha: 0.7];
}

-(float)alphaValue {
	
	if([self isHighlighted]) {
		
		return 1.0;
	} else {
		
		return 0.7;
	}
}


@end
