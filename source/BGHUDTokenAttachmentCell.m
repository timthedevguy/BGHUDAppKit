//
//  BGHUDTokenAttachmentCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDTokenAttachmentCell.h"


@implementation BGHUDTokenAttachmentCell

- (id)tokenForegroundColor {

	if(![self isHighlighted]) {
		
		return [NSColor colorWithDeviceRed: .224 green: .224 blue: .224 alpha: 1.0];
	} else {
		
		return [NSColor colorWithDeviceRed: .324 green: .324 blue: .324 alpha: 1.0];
	}
}

- (id)tokenBackgroundColor {
	
	return [NSColor whiteColor];
}

- (void)drawWithFrame:(struct _NSRect)fp8 inView:(id)fp24 {
	
	if(![self isHighlighted]) {
		
		NSMutableAttributedString *newTitle = [[NSMutableAttributedString alloc] initWithAttributedString: [self attributedStringValue]];
		
		[newTitle beginEditing];
		[newTitle addAttribute: NSForegroundColorAttributeName
						 value: [self textColor]
						 range: NSMakeRange(0, [newTitle length])];
		[newTitle endEditing];
		
		[self setAttributedStringValue: newTitle];
	}
	
	[super drawWithFrame: fp8 inView: fp24];
}

@end
