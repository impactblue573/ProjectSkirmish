//
//  BullseyePawn.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "BullseyePawn.h"


@implementation BullseyePawn

-(id) init
{
	//use default values for now
	if((self = [super init]))
	{
		startPosition = ccp(40.0f,150.0f);
		size = b2Vec2(64.0f,80.0f);
		offset = b2Vec2(-1.0f,-8.0f);
		jumpSpeed = 11.0;
		maxSpeed = 5.0;
		jumpForceMag = 2800.0;
		gunAnchorPoint = ccp(0.2,0.5);
		gunOffset = CGPointMake(-10.0,-20.0);
		muzzleOffset = CGPointMake(60.0,0);
		tiltPosition = CGPointMake(-10.0,-20.0);
		fireForce = 6.0f;
		fireInterval = 0.6f;		
		fireDamage = 17;
		spriteName = @"Bullseye";
		pawnType = @"Bullseye";
	}
	return self;
}

@end
