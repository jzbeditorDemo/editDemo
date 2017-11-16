//
//  DTTextBlock.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 04.03.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTTextBlock.h"
#import "NSCoder+DTCompatibility.h"

@implementation DTTextBlock
{
	DTEdgeInsets _padding;
	DTColor *_backgroundColor;
    DTColor *_borderColor;
    DTEdgeInsets _borderEdge;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		_padding = [aDecoder decodeDTEdgeInsetsForKey:@"padding"];
		_backgroundColor = [aDecoder decodeObjectForKey:@"backgroundColor"];
        _borderColor = [aDecoder decodeObjectForKey:@"borderColor"];
        _borderEdge = [aDecoder decodeDTEdgeInsetsForKey:@"borderEdge"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeDTEdgeInsets:_padding forKey:@"padding"];
	[aCoder encodeObject:_backgroundColor forKey:@"backgroundColor"];
    [aCoder encodeDTEdgeInsets:_borderEdge forKey:@"borderEdge"];
    [aCoder encodeObject:_borderColor forKey:@"borderColor"];
}

- (NSUInteger)hash
{
	NSUInteger calcHash = 7;
	
	calcHash = calcHash*31 + [_backgroundColor hash];
	calcHash = calcHash*31 + (NSUInteger)_padding.left;
	calcHash = calcHash*31 + (NSUInteger)_padding.top;
	calcHash = calcHash*31 + (NSUInteger)_padding.right;
	calcHash = calcHash*31 + (NSUInteger)_padding.bottom;
    
    calcHash = calcHash*31 + [_borderColor hash];
    calcHash = calcHash*31 + (NSUInteger)_borderEdge.left;
    calcHash = calcHash*31 + (NSUInteger)_borderEdge.top;
    calcHash = calcHash*31 + (NSUInteger)_borderEdge.right;
    calcHash = calcHash*31 + (NSUInteger)_borderEdge.bottom;
	
	return calcHash;
}

- (BOOL)isEqual:(id)object
{
	if (!object)
	{
		return NO;
	}
	
	if (object == self)
	{
		return YES;
	}
	
	if (![object isKindOfClass:[DTTextBlock class]])
	{
		return NO;
	}
	
	DTTextBlock *other = object;
	
	if (_padding.left != other->_padding.left ||
		_padding.top != other->_padding.top ||
		_padding.right != other->_padding.right ||
		_padding.bottom != other->_padding.bottom)
	{
		return NO;
	}
	
	if (other->_backgroundColor == _backgroundColor)
	{
		return YES;
	}
    
    if (_borderEdge.left != other->_borderEdge.left ||
        _borderEdge.top != other->_borderEdge.top ||
        _borderEdge.right != other->_borderEdge.right ||
        _borderEdge.bottom != other->_borderEdge.bottom)
    {
        return NO;
    }
    
    if (other->_borderColor == _borderColor)
    {
        return YES;
    }
	
	return [other->_backgroundColor isEqual:_backgroundColor];
}

#pragma mark Properties

@synthesize padding = _padding;
@synthesize backgroundColor = _backgroundColor;
@synthesize borderEdge = _borderEdge;
@synthesize borderColor = _borderColor;

@end
