//
//  GinjaNinja.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 8/03/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "GinjaNinjaPawn.h"


@implementation GinjaNinjaPawn

-(id) init
{
	//use default values for now
	if((self = [super init]))
	{
		startPosition = ccp(40.0f,150.0f);
		size = b2Vec2(50.0f,90.0f);
		offset = b2Vec2(-10.0f,-3.0f);
		jumpSpeed = 13.0;		
		jumpForceMag = 7600.0;
		maxSpeed = 6.0;
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

-(void) initializeWalkAnimation:(AnimationManager*)animationManager
{
	//Walk Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Walk-Default.png",@"Walk-Left-1.png",@"Walk-Left-2.png",@"Walk-Left-1.png",@"Walk-Default.png",@"Walk-Right-1.png",@"Walk-Right-2.png",@"Walk-Right-1.png",nil];
	[animationManager addAnimation:@"Walk" usingFrames:frameNames frameDelay:0.035];
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",@"Jump-3.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Fall-1.png",@"Fall-2.png",@"Fall-3.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1];
}

@end
