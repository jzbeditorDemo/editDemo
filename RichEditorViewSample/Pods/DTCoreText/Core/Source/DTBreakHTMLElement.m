//
//  DTHTMLElementBR.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 26.12.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTBreakHTMLElement.h"

@implementation DTBreakHTMLElement

- (NSAttributedString *)attributedString
{
	@synchronized(self)
	{
//        NSDictionary *attributes = [self attributesForAttributedStringRepresentation];
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.paragraphSpacingBefore = -5;
        [attributes setObject:style forKey:NSParagraphStyleAttributeName];
		return [[NSAttributedString alloc] initWithString:UNICODE_LINE_FEED attributes:attributes];
	}
}

@end
