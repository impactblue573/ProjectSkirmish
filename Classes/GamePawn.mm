//
//  GamePawn.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GamePawn.h"
#import "GameController.h"
#import "GameScene.h"
#import "SoundManager.h"

@class GameScene;
@implementation GamePawn

@synthesize bodySprite,gunSprite,pawnType,startPosition,physicsBody,size,aimAngle,facing,isFiring,fireInterval,spriteName,team,offset,controller,health,physicsState,healthUpdated,walkDirection;


-(id) init
{
	//use default values for now
	if((self = [super init]))
	{
		startPosition = ccp(-1,-1);
		size = b2Vec2(64.0f,80.0f);
		offset = b2Vec2(4.0f,0.0f);
		jumpSpeed = 12.0;
		maxSpeed = 5.5;
		moveForceMag = 500.0;
		airMoveForceMag = 1000.0;
		jumpForceMag = 3200.0;
		gunAnchorPoint = ccp(0.2,0.5);
		gunOffset = CGPointMake(-10.0,-20.0);
		muzzleOffset = CGPointMake(60.0,0);
		tiltPosition = CGPointMake(-10.0,-20.0);
		fireForce = 3.0f;
		aimAngle = 0.0f;
		facing = 1;
		isFiring = NO;
		fireInterval = 0.4f;
		zeroAimInterval = 1.0f;
		moveForceInterval = 0.1;
		spriteName = @"LamboClassic";
		pawnType = @"LamboClassic";
		physicsState = Physics_Walking;
		pawnState = Pawn_Alive;
		health = 100;
		fireDamage = 10;
        powerups = [[NSMutableArray alloc] init];
        spriteVariation = 1;
        fireForceMod = 0.75f;
        fireIntervalMod = 1.5f;
        projectileParticleCount = 300;
        handicap = 1.0;
	}
	return self;
}

-(void) applyHandicap:(float)h{
    health /= handicap;
    fireDamage /= handicap;
    
    handicap = h;
    health *= handicap;
    fireDamage *= handicap;
}

-(void) setVariation:(int)variation
{
    if(variation >= 0)
        spriteVariation = variation;
}

-(id) initForController:(GameController*)ctrl
{
	//use default values for now
	self = [self init];
	controller = ctrl;
	return self;
}

-(float) getFireInterval
{
    return fireInterval * fireIntervalMod;
}

-(void) setProjectilePool:(ProjectilePool*)pool
{
	projectilePool = pool;
}
			
-(void) setPosition:(CGPoint)pos
{
	b2Vec2 newPos = b2Vec2(pos.x/PTM_RATIO,pos.y/PTM_RATIO);
	physicsBody->SetTransform(newPos,0);
}

-(b2Vec2) position
{
	b2Vec2 pos = physicsBody->GetPosition();
	pos.x *= PTM_RATIO;
	pos.y *= PTM_RATIO;
	return pos;
}

-(b2Vec2) velocity
{
	return physicsBody->GetLinearVelocity();
}

-(void) setVelocity:(b2Vec2) velocity
{
	physicsBody->SetLinearVelocity(velocity);
}

-(bool) walk:(b2Vec2) direction
{
	if(pawnState == Pawn_Alive && walkDirection != direction.x)
	{
		walkDirection = direction.x;
		return true;
	}
	return false;
}

-(bool) jump:(float)jumpPower
{
	//CCLOG(@"Apply force %f to mass %f",jumpForceMag,physicsBody->GetFixtureList()->GetDensity());
	if(physicsState == Physics_Walking && pawnState == Pawn_Alive)
	{
		physicsBody->ApplyForce(b2Vec2(0.0,jumpForceMag * jumpPower),physicsBody->GetPosition());
		physicsState = Physics_Jumping;
		//play sound effect
		//b2Vec2 vel = [self velocity];
		//[self setVelocity:b2Vec2(vel.x,0.1)];
		//b2Vec2 pos = [self position];
//		if([GameScene isInPlayerView:ccp(pos.x,pos.y)] || [controller isKindOfClass:[PlayerController class]])
//		{
//			//play jump
//		}
		return true;
	}
	return false;
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
		CGPoint launchPos = CGPointMake(tiltPos.x + facing * muzzleOffset.x * cos(angle),tiltPos.y + facing * muzzleOffset.x * sin(angle));
		[self spawnProjectile:angle atPosition:launchPos];

        [[SoundManager sharedManager] playSound:@"Gunfire.mp3" atPosition:ccp(bodyPos.x,bodyPos.y)];
		return true;
	}
	else {		
		return false;
	}

}

-(void) spawnProjectile:(float)angle atPosition:(CGPoint)pos
{
    //spawn projectile
    Projectile* projectile = [[[Projectile alloc] init] autorelease];
    [projectile setProjectileSprite:[CCSprite spriteWithSpriteFrameName:team.paintballSprite]];
    projectile.launchPosition = pos;
    projectile.launchForce = CGPointMake(facing * fireForce * fireForceMod * cos(angle), facing * fireForce * fireForceMod * sin(angle));
    projectile.mass = 0.1;
    projectile.controller = controller;
    projectile.deathEffect = [[[PaintballExplodeParticleSystem alloc] initVelocity:ccp([Helper normalize:projectile.launchForce.x],projectile.launchForce.y/fabsf(projectile.launchForce.x)) withColor:team.teamColor numParticles:projectileParticleCount] autorelease];		
    projectile.teamIndex = team.teamIndex;
    projectile.damage = fireDamage;
    //projectile.deathEffect = [[PaintballSplatParticleSystem alloc] initVelocity:ccp(facing,-0.5f)];
    [projectilePool queueProjectile:projectile];
}
-(void) endFire
{
	//CCLOG(@"End Fire");
	isFiring = NO;
	timeSinceFire = 0;
	
}

-(void) updateFire:(ccTime)dt
{
	if(isFiring)
	{
		timeSinceFire += dt;
		if(timeSinceFire > fireInterval * fireIntervalMod)
			[self endFire];
	}
	
	if(aimAngle != 0)
	{
		timeSinceAim += dt;
		if(timeSinceAim > zeroAimInterval)
			aimAngle = 0;
	}
}

-(CGPoint) getFirePoint
{
	b2Vec2 pos = [self position];
	return CGPointMake(pos.x + facing * (gunOffset.x + muzzleOffset.x),pos.y + gunOffset.y + muzzleOffset.y);
}

-(CGPoint) getWorldTiltPoint
{
	b2Vec2 pos = [self position];
	return CGPointMake(pos.x + facing * tiltPosition.x,pos.y + tiltPosition.y);
}

-(void) applyLimits
{
	b2Vec2 velocity = physicsBody->GetLinearVelocity();
	if(fabsf(velocity.x) > maxSpeed)
	{
		velocity.x = [Helper normalize:velocity.x] * maxSpeed;
	}
	
	if(velocity.y > jumpSpeed)
	{
		velocity.y = jumpSpeed;
	}
	physicsBody->SetLinearVelocity(velocity);
}

-(void) synchronizePawnPhysics:(ccTime)dt
{
	if(lastMoveForce < moveForceInterval*2)
		lastMoveForce += dt;
	b2Vec2 velocity = [self velocity];	
	//Auto move
	if(lastMoveForce > moveForceInterval)
	{		
		b2Vec2 moveForce = b2Vec2(walkDirection * (velocity.y > 0 ? airMoveForceMag : moveForceMag),0);
		physicsBody->ApplyForce(moveForce,physicsBody->GetPosition());
		
		if(walkDirection > 0.1)
			facing = 1;
		else if(walkDirection < -0.1) 
			facing = -1;
		lastMoveForce = 0;
	}
	
	if(velocity.y > 0.05)
		physicsState = Physics_Jumping;
	else if(velocity.y < -0.05)
		physicsState = Physics_Falling;
	else if(velocity.y == 0 && (physicsState == Physics_Falling))
		physicsState = Physics_Walking;
	
	//synchronize position with physics body	
	b2Vec2 bodyPos = physicsBody->GetPosition();
	CGPoint bodyPoint = CGPointMake( bodyPos.x * PTM_RATIO, bodyPos.y * PTM_RATIO);
	bodySprite.position = ccp(bodyPoint.x + facing * offset.x,bodyPoint.y);
	bodySprite.rotation = -1 * CC_RADIANS_TO_DEGREES(physicsBody->GetAngle());
	if(facing == 1)
		gunSprite.anchorPoint = gunAnchorPoint;
	else 
		gunSprite.anchorPoint = ccp(1-gunAnchorPoint.x,gunAnchorPoint.y);

	//Set flip
	if(facing == 1)
	{
		bodySprite.flipX = NO;
		gunSprite.flipX = NO;
	}
	else 
	{
		bodySprite.flipX = YES;
		gunSprite.flipX = YES;
	}

	gunSprite.position = CGPointMake(bodyPoint.x + gunOffset.x * facing, bodyPoint.y + gunOffset.y);
	
	if(pawnState == Pawn_Alive)
		gunSprite.rotation = aimAngle;
	else 
		gunSprite.rotation = bodySprite.rotation;

	//apply physics limitations
	[self applyLimits];
}

-(void) setGameController:(GameController*)ctrl
{
	controller = ctrl;
}

-(void) killPawn
{
	if(pawnState == Pawn_Alive)
	{
		pawnState = Pawn_Dead;
		physicsBody->SetFixedRotation(false);
		physicsBody->SetAngularVelocity(facing * (physicsState == Physics_Walking ? 30 : 10));
		b2Vec2 pos = [self position];
		[[SoundManager sharedManager] playSound:@"TakeHit.aif" atPosition:ccp(pos.x,pos.y)];
		walkDirection = 0;
		//[controller alertDeath];
	}
}

-(void) takeDamage:(float)damage
{
	health -= damage;
	if(health < 0) health = 0;
	healthUpdated = true;
//	b2Vec2 pos = [self position];
	//[[SoundManager sharedManager] playSound:@"TakeHit.aif" atPosition:ccp(pos.x,pos.y)];
}

-(void) processPowerups:(ccTime)dt
{
    for(uint i = 0; i < [powerups count]; i++)
    {
        Powerup* powerup = [powerups objectAtIndex:i];
        [powerup step:dt];
        if(powerup.expired)
        {
            [self unequipPowerup:powerup];
            [powerups removeObjectAtIndex:i];
            i--;
        }
    }
}

-(void) equipPowerup:(Powerup *)powerup
{
    if(powerup != nil)
    {
        [powerup retain];
        fireDamage *= powerup.damageFactor;
        //moveForceMag *= powerup.moveFactor;
        maxSpeed *= powerup.moveFactor;
        jumpForceMag *= powerup.jumpFactor;
        jumpSpeed *= powerup.jumpFactor;        
        [powerups addObject:powerup];
    }
}

-(void) unequipPowerup:(Powerup*)powerup
{
    if(powerup != nil)
    {
        fireDamage /= powerup.damageFactor;
        //moveForceMag /= powerup.moveFactor;
        maxSpeed /= powerup.moveFactor;
        jumpForceMag /= powerup.jumpFactor;
        jumpSpeed /= powerup.jumpFactor; 
        [powerup release];
    }
}

-(void) clearPowerups
{
    for(uint i = 0; i < [powerups count]; i++)
    {
        Powerup* powerup = [powerups objectAtIndex:i];
        [self unequipPowerup:powerup];
    }
    [powerups removeAllObjects];
}

-(void) reset
{
	aimAngle = 0.0f;
	facing = 1;
	isFiring = NO;
	physicsState = Physics_Walking;
	pawnState = Pawn_Alive;
	health = 100 * handicap;
    [self clearPowerups];
}

-(bool) isDead
{
	return pawnState == Pawn_Dead;
}

-(PawnInfo*) getPawnInfo
{
	PawnInfo* info = [[[PawnInfo alloc] init] autorelease];
	info.pawnType = pawnType;
    info.spriteVariation = [NSNumber numberWithInt:spriteVariation];
	info.teamID = [NSNumber numberWithInt:team.teamIndex];
	info.playerID = controller.playerID;
	info.playerName = controller.playerName;
	return info;
}

-(void) initializeAnimations:(AnimationManager*)animationManager
{
	[animationManager initSpriteSheet:spriteName];
    SpritePackage bodyPackage = [animationManager addSprite:@"Body" defaultFrame:@"Default.png"];	
    bodySpriteDefaultSize = bodyPackage.size;
    bodySprite = bodyPackage.sprite;
	gunSprite = [animationManager addSprite:@"Gun" defaultFrame:@"Gun.png"].sprite;
	[self initializeWalkAnimation:animationManager];
	[self initializeStandAnimation:animationManager];
	[self initializeJumpAnimation:animationManager];
	[self initializeFallAnimation:animationManager];
	[self initializeDeathAnimation:animationManager];
	[self initializeGunIdleAnimation:animationManager];
	[self initializeGunWalkAnimation:animationManager];
	[self initializeGunShootAnimation:animationManager];
	[self initializeGunDefaultAnimation:animationManager];
}

-(void) initializeWalkAnimation:(AnimationManager*)animationManager
{
	//Walk Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Walk-Left-1.png",@"Walk-Left-2.png",@"Walk-Left-1.png",@"Default.png",@"Walk-Right-1.png",@"Walk-Right-2.png",@"Walk-Right-1.png",nil];
	[animationManager addAnimation:@"Walk" usingFrames:frameNames frameDelay:0.05 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeStandAnimation:(AnimationManager*)animationManager
{
	//Stand Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Stand-1.png",@"Stand-2.png",@"Stand-3.png",@"Stand-2.png",@"Stand-1.png",nil];
	[animationManager addAnimation:@"Idle" usingFrames:frameNames frameDelay:0.15 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",@"Jump-3.png",@"Jump-4.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Jump-3.png",@"Jump-2.png",@"Jump-1.png",@"Default.png",@"Fall-1.png",@"Fall-2.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1 autoOffsetTo:bodySpriteDefaultSize];
}

-(void) initializeDeathAnimation:(AnimationManager*)animationManager
{
	//Death Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Death.png",nil];
	[animationManager addAnimation:@"Death" usingFrames:frameNames frameDelay:1.0];
}

-(void) initializeGunWalkAnimation:(AnimationManager*)animationManager
{
	//Gun Walk Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Gun.png",@"Gun-Swing-Left-1.png",@"Gun-Swing-Left-2.png",@"Gun-Swing-Left-1.png",@"Gun.png",@"Gun-Swing-Right-1.png",@"Gun-Swing-Right-2.png",@"Gun-Swing-Right-1.png",nil];
	[animationManager addAnimation:@"GunSwing" usingFrames:frameNames frameDelay:0.1];
}

-(void) initializeGunIdleAnimation:(AnimationManager*)animationManager
{
	//Gun Idle Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Gun.png",@"Gun-Idle-1.png",@"Gun-Idle-2.png",@"Gun-Idle-3.png",@"Gun-Idle-2.png",@"Gun-Idle-1.png",nil];
	[animationManager addAnimation:@"GunIdle" usingFrames:frameNames frameDelay:0.15];	
}

-(void) initializeGunShootAnimation:(AnimationManager*)animationManager
{
	//Gun Shoot Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Gun.png",@"Gun-Shoot-3.png",@"Gun-Shoot-2.png",@"Gun-Shoot-1.png",nil];
	[animationManager addAnimation:@"GunShoot" usingFrames:frameNames frameDelay:0.03];	
}

-(void) initializeGunDefaultAnimation:(AnimationManager*)animationManager
{
	//Gun Default Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Gun.png",nil];
	[animationManager addAnimation:@"GunDefault" usingFrames:frameNames frameDelay:1];
}
@end
