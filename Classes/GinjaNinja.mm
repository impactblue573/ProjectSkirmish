//
//  GinjaNinja.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 8/03/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "GinjaNinja.h"


@implementation GinjaNinja

-(id) init
{
	//use default values for now
	if((self = [super init]))
	{
		startPosition = ccp(40.0f,150.0f);
		size = b2Vec2(70.0f,80.0f);
		offset = b2Vec2(-1.0f,-8.0f);
		jumpSpeed = 13.0;
		maxSpeed = 7.0;
		jumpForceMag = 3600.0;
		gunAnchorPoint = ccp(0.2,0.5);
		gunOffset = CGPointMake(-5.0,-7.0);
		muzzleOffset = CGPointMake(60.0,0);
		tiltPosition = CGPointMake(-10.0,-10.0);
		fireForce = 2.5f;
		fireInterval = 0.25f;		
		fireDamage = 7;
		spriteName = @"GinjaNinja";
		pawnType = @"Ginja Ninja";
	}
	return self;
}

@end
