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
		size = b2Vec2(74.0f,84.0f);
		offset = b2Vec2(0.0f,-8.0f);
		jumpSpeed = 12.0;
		maxSpeed = 4.5;
		jumpForceMag = 4000.0;
		gunAnchorPoint = ccp(0.2,0.5);
		gunOffset = CGPointMake(-25.0,-16.0);
		muzzleOffset = CGPointMake(74.0,0);
        projectileParticleCount = 600;
		tiltPosition = CGPointMake(-10.0,-16.0);
		fireForce = 5.0f;
		fireInterval = 0.6f;		
		fireDamage = 18;
		spriteName = @"Bullseye";
		pawnType = @"Bullseye";
	}
	return self;
}

-(void) setVariation:(int)variation
{
    if(variation == 0)
    {
        int rand = arc4random()%100;
        if(rand > 50)
        {
            variation = 1; 
        }
        else
        {
            variation = 2; 
        }
    }
    [super setVariation:variation];
    switch(spriteVariation)
    {
        case 1:
            spriteName = @"Bullseye";
            break;
        case 2:
            spriteName = @"BullseyeAlternate";
            break;
    }
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Fall-1.png",@"Fall-2.png",@"Fall-3.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1 autoOffsetTo:bodySpriteDefaultSize];
}

@end
