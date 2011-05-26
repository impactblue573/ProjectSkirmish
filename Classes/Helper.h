//
//  Helper.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Helper : NSObject {

}

struct BodyBounds
{
    float top;
    float right;
    float bottom;
    float left;
};

typedef BodyBounds BodyBounds;


struct ViewPort
{
	CGPoint position;//bottom left
	CGSize dimensions;
};

typedef ViewPort ViewPort;

+(bool) point:(CGPoint)point isInRect:(CGRect) rect;

+(CGPoint) toCGPoint:(b2Vec2)vec;	

+(CGPoint) toCGPoint:(b2Vec2)vec multiply:(float)mult;

+(CGPoint) CGPointMultiply:(CGPoint)pt multiply:(float)mult;

+(b2Vec2) tob2Vec:(CGPoint)vec;

+(b2Vec2) tob2Vec:(CGPoint)vec multiply:(float)mult;

+(b2Vec2) b2Vec2Multiply:(b2Vec2)vec multiply:(float)mult;

+(float) normalize:(float)f;

+(BodyBounds) GetBounds:(b2Fixture*) fixture;
@end
