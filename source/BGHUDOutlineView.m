//
//  BGHUDOutlineView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/20/08.
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

#import "BGHUDOutlineView.h"


@implementation BGHUDOutlineView

#pragma mark Drawing Functions

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		themeManager = [[BGGradientTheme alloc] init];
		[self setBackgroundColor: [themeManager tableBackgroundColor]];
		[self setFocusRingType: NSFocusRingTypeNone];
		
		//Setup Header Cells
		NSEnumerator*   aEnumerator;
		NSTableColumn*  aColumn;
		
		aEnumerator = [[self tableColumns] objectEnumerator];
		
		while (aColumn = [aEnumerator nextObject]) {
			
			//Create new cell and set it's props to that of old cell
			BGHUDTableViewHeaderCell *newHeader = [[BGHUDTableViewHeaderCell alloc] init];
			[newHeader setStringValue: [[aColumn headerCell] stringValue]];
			[newHeader setThemeManager: themeManager];
			[newHeader setFont: [[aColumn headerCell] font]];
			
			[aColumn setHeaderCell: newHeader];
			[newHeader release];
		}
		
		[aColumn release];
		[aEnumerator release];
	}
	
	return self;
}

- (id)_alternatingRowBackgroundColors {
	
	if(themeManager) {
		
		return [themeManager cellAlternatingRowColors];
	} else {
		
		return [super _alternatingRowBackgroundColors];
	}
}

- (id)_highlightColorForCell:(id)cell {
	
	if(themeManager) {
		
		return [themeManager cellHighlightColor];
	} else {
		
		return [super cellHighlightColor];
	}
}

- (void)_sendDelegateWillDisplayCell:(id)cell forColumn:(id)column row:(int)row {
    [super _sendDelegateWillDisplayCell:cell forColumn:column row:row];
    
	if(themeManager) {
		
		if([[self selectedRowIndexes] containsIndex: row]) {
			
			if([cell respondsToSelector: @selector(setTextColor:)]) {
				[cell setTextColor: [themeManager cellSelectedTextColor]];
			}
		} else {
			
			if ([cell respondsToSelector:@selector(setTextColor:)]) {
				[cell setTextColor: [themeManager textColor]];
			}
		}
	}
}

#pragma mark -
#pragma mark Helper Methods

-(void)setThemeManager:(BGThemeManager *)manager {
	
	[themeManager release];
	themeManager = [manager retain];
}

-(void)dealloc {
	
	[themeManager release];
	[super dealloc];
}

#pragma mark -

@end
