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

@synthesize bodySprite,gunSprite,pawnType,startPosition,physicsBody,size,aimAngle,facing,isFiring,fireInterval,spriteName,team,offset,controller,health,physicsState,healthUpdated;


-(id) init
{
	//use default values for now
	if((self = [super init]))
	{
		startPosition = ccp(40.0f,150.0f);
		size = b2Vec2(64.0f,80.0f);
		offset = b2Vec2(4.0f,0.0f);
		jumpSpeed = 12.0;
		maxSpeed = 6.0;
		moveForceMag = 500.0;
		airMoveForceMag = 1000.0;
		jumpForceMag = 3200.0;
		gunAnchorPoint = ccp(0.2,0.5);
		gunOffset = CGPointMake(-10.0,-20.0);
		muzzleOffset = CGPointMake(60.0,0);
		tiltPosition = CGPointMake(-10.0,-20.0);
		fireForce = 4.0f;
		aimAngle = 0.0f;
		facing = 1;
		isFiring = NO;
		fireInterval = 0.4f;
		zeroAimInterval = 1.0f;
		moveForceInterval = 0.1;
		spriteName = @"Lambo";
		pawnType = @"Lambo";
		physicsState = Physics_Walking;
		pawnState = Pawn_Alive;
		health = 100;
		fireDamage = 10;
	}
	return self;
}

-(id) initForController:(GameController*)ctrl
{
	//use default values for now
	[self init];
	controller = ctrl;
	return self;
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
	if(pawnState == Pawn_Alive)
	{
		if(lastMoveForce > moveForceInterval)
		{
			b2Vec2 velocity = [self velocity];	
			b2Vec2 moveForce = b2Vec2(direction.x * (velocity.y > 0 ? airMoveForceMag : moveForceMag),0);
			physicsBody->ApplyForce(moveForce,physicsBody->GetPosition());
			
			if(direction.x > 0.1)
				facing = 1;
			else if(direction.x < -0.1) 
				facing = -1;
			lastMoveForce = 0;
			return true;
		}
	}
	return false;
}

-(bool) jump
{
	//CCLOG(@"Apply force %f to mass %f",jumpForceMag,physicsBody->GetFixtureList()->GetDensity());
	if(physicsState == Physics_Walking && pawnState == Pawn_Alive)
	{
		physicsBody->ApplyForce(b2Vec2(0.0,jumpForceMag),physicsBody->GetPosition());
		physicsState = Physics_Jumping;
		//play sound effect
		b2Vec2 pos = [self position];
		if([GameScene isInPlayerView:ccp(pos.x,pos.y)] || [controller isKindOfClass:[PlayerController class]])
		{
			//play jump
		}
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
		angle = clampf(angle,-1.2,1.2);
		aimAngle = -1 * CC_RADIANS_TO_DEGREES(angle);
		
		//spawn projectile
		Projectile* projectile = [[Projectile alloc] init];
		projectile.sprite = [[CCSprite spriteWithFile:team.paintballSprite] retain];
		projectile.launchPosition = CGPointMake(tiltPos.x + facing * muzzleOffset.x * cos(angle),tiltPos.y + facing * muzzleOffset.x * sin(angle));;
		projectile.launchForce = CGPointMake(facing * fireForce * cos(angle), facing * fireForce * sin(angle));
		projectile.mass = 0.1;
		projectile.controller = controller;
		projectile.deathEffect = [[[PaintballExplodeParticleSystem alloc] initVelocity:ccp([Helper normalize:projectile.launchForce.x],projectile.launchForce.y/fabsf(projectile.launchForce.x)) withColor:team.teamColor] autorelease];		
		projectile.teamIndex = team.teamIndex;
		projectile.damage = fireDamage;
		//projectile.deathEffect = [[PaintballSplatParticleSystem alloc] initVelocity:ccp(facing,-0.5f)];
		[projectilePool queueProjectile:projectile];
		//Play Sound Effect
		[[SoundManager sharedManager] playSound:@"Paintball-Shot.aif" atPosition:ccp(bodyPos.x,bodyPos.y)];
		//if([GameScene isInPlayerView:ccp(bodyPos.x,bodyPos.y)] || [controller isKindOfClass:[PlayerController class]])
//		{
//			[[SimpleAudioEngine sharedEngine] playEffect:@"Paintball-Shot.aif"];
//		}
//		else 
//		{
//			[[SimpleAudioEngine sharedEngine] playEffect:@"Paintball-Shot-Distant.aif"];
//		}

		return true;
	}
	else {		
		return false;
	}

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
		if(timeSinceFire > fireInterval)
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
	if(velocity.y > 0.1)
		physicsState = Physics_Jumping;
	else if(velocity.y < -0.1)
		physicsState = Physics_Falling;
	else if(velocity.y == 0 && (physicsState == Physics_Falling || physicsState == Physics_Jumping))
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

-(void) reset
{
	aimAngle = 0.0f;
	facing = 1;
	isFiring = NO;
	physicsState = Physics_Walking;
	pawnState = Pawn_Alive;
	health = 100;
}

-(bool) isDead
{
	return pawnState == Pawn_Dead;
}

-(PawnInfo*) getPawnInfo
{
	PawnInfo* info = [[[PawnInfo alloc] init] retain];
	info.pawnType = pawnType;
	info.teamID = [NSNumber numberWithInt:team.teamIndex];
	info.playerID = controller.playerID;
	info.playerName = controller.playerName;
	return info;
}

-(void) initializeAnimations:(AnimationManager*)animationManager
{
	[animationManager initSpriteSheet:spriteName];
	[self initializeWalkAnimation:animationManager];
	[self initializeStandAnimation:animationManager];
	[self initializeJumpAnimation:animationManager];
	[self initializeFallAnimation:animationManager];
	[self initializeDeathAnimation:animationManager];
	[self initializeGunIdleAnimation:animationManager];
	[self initializeGunWalkAnimation:animationManager];
	[self initializeGunShootAnimation:animationManager];
	[self initializeGunDefaultAnimation:animationManager];
	bodySprite = [animationManager addSprite:@"Body" defaultFrame:@"Default.png"];	
	gunSprite = [animationManager addSprite:@"Gun" defaultFrame:@"Gun.png"];
}

-(void) initializeWalkAnimation:(AnimationManager*)animationManager
{
	//Walk Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Walk-Left-1.png",@"Walk-Left-2.png",@"Walk-Left-1.png",@"Default.png",@"Walk-Right-1.png",@"Walk-Right-2.png",@"Walk-Right-1.png",nil];
	[animationManager addAnimation:@"Walk" usingFrames:frameNames frameDelay:0.05];
}

-(void) initializeStandAnimation:(AnimationManager*)animationManager
{
	//Stand Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Stand-1.png",@"Stand-2.png",@"Stand-3.png",@"Stand-2.png",@"Stand-1.png",nil];
	[animationManager addAnimation:@"Idle" usingFrames:frameNames frameDelay:0.15];
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",@"Jump-3.png",@"Jump-4.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Jump-3.png",@"Jump-2.png",@"Jump-1.png",@"Default.png",@"Fall-1.png",@"Fall-2.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1];
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
