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
		size = b2Vec2(74.0f,84.0f);
		offset = b2Vec2(0.0f,-8.0f);
		jumpSpeed = 11.0;
		maxSpeed = 5.0;
		jumpForceMag = 3200.0;
		gunAnchorPoint = ccp(0.2,0.5);
		gunOffset = CGPointMake(-10.0,-20.0);
		muzzleOffset = CGPointMake(60.0,0);
		tiltPosition = CGPointMake(-10.0,-20.0);
		fireForce = 6.0f;
		fireInterval = 0.6f;		
		fireDamage = 15;
		spriteName = @"Bullseye";
		pawnType = @"Bullseye";
	}
	return self;
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Fall-1.png",@"Fall-2.png",@"Fall-3.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1];
}

@end
