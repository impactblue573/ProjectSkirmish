//
//  GinjaNinja.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 8/03/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "GinjaNinjaPawn.h"
#import "SoundManager.h"

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
		gunOffset = CGPointMake(-10.0,-7.0);
		muzzleOffset = CGPointMake(40.0,0);
        muzzleOffsetSecondary = 18;
		tiltPosition = CGPointMake(0.0,0.0);
        projectileParticleCount = 150;
		fireForce = 2.5f;
		fireInterval = 0.25f;		
		fireDamage = 3.5;
		spriteName = @"GinjaNinja";
		pawnType = @"Ginja Ninja";
	}
	return self;
}

-(bool) fire:(CGPoint)target
{
	if(!isFiring && pawnState == Pawn_Alive)
	{
		CGPoint tiltPos = [self getWorldTiltPoint];
		b2Vec2 bodyPos = [self position];
		float fireFace = bodyPos.x < target.x ? 1:-1;	
		facing = fireFace;
		isFiring = YES;
		timeSinceAim = 0;
		float angle = atan( (target.y-tiltPos.y)/(target.x-tiltPos.x));
		angle = clampf(angle,CC_DEGREES_TO_RADIANS(-60),CC_DEGREES_TO_RADIANS(45));
		aimAngle = -1 * CC_RADIANS_TO_DEGREES(angle);
		
		//spawn projectile
		CGPoint launchPos1 = CGPointMake(tiltPos.x + facing * muzzleOffset.x * cos(angle),tiltPos.y + facing * muzzleOffset.x * sin(angle));;
		CGPoint launchPos2 = CGPointMake(tiltPos.x + facing * muzzleOffsetSecondary * cos(angle),tiltPos.y + facing * muzzleOffsetSecondary * sin(angle));;
		
        [self spawnProjectile:angle atPosition:launchPos1];
        [self spawnProjectile:angle atPosition:launchPos2];
		//Play Sound Effect
		[[SoundManager sharedManager] playSound:@"Gunfire.mp3" atPosition:ccp(bodyPos.x,bodyPos.y)];
        
		return true;
	}
	else {		
		return false;
	}
    
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
            spriteName = @"GinjaNinja";
            break;
        case 2:
            spriteName = @"GinjaNinjaAlternate";
            break;
    }
}

-(void) initializeWalkAnimation:(AnimationManager*)animationManager
{
	//Walk Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Walk-Default.png",@"Walk-Left-1.png",@"Walk-Left-2.png",@"Walk-Left-1.png",@"Walk-Default.png",@"Walk-Right-1.png",@"Walk-Right-2.png",@"Walk-Right-1.png",nil];
	[animationManager addAnimation:@"Walk" usingFrames:frameNames frameDelay:0.05 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",@"Jump-3.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Fall-1.png",@"Fall-2.png",@"Fall-3.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1 autoOffsetTo:bodySpriteDefaultSize];
}

@end
