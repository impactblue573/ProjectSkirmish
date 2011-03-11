//
//  Helper.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"


@implementation Helper

+(bool) point:(CGPoint)point isInRect:(CGRect) rect
{
	return	point.x >= rect.origin.x && 
			point.x <= rect.origin.x + rect.size.width &&
			point.y >= rect.origin.y &&
			point.y <= rect.origin.y + rect.size.height;
}

+(CGPoint) toCGPoint:(b2Vec2)vec
{
	return CGPointMake(vec.x,vec.y);
}

+(CGPoint) toCGPoint:(b2Vec2)vec multiply:(float)mult
{
	
	return CGPointMake(vec.x * mult,vec.y * mult);
}

+(CGPoint) CGPointMultiply:(CGPoint)pt multiply:(float)mult
{
	return CGPointMake(pt.x * mult,pt.y * mult);
}

+(b2Vec2) tob2Vec:(CGPoint)vec
{	
	return b2Vec2(vec.x,vec.y);
}

+(b2Vec2) tob2Vec:(CGPoint)vec multiply:(float)mult
{
	return b2Vec2(vec.x * mult,vec.y * mult);
}

+(b2Vec2) b2Vec2Multiply:(b2Vec2)vec multiply:(float)mult
{
	return b2Vec2(vec.x * mult,vec.y * mult);
}

+(float) normalize:(float)f
{
	return fabsf(f)/f;
}

@end
