//
//  GamePawn.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "Helper.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ProjectilePool.h"
#import "PaintballExplodeParticleSystem.h"
#import "PaintballSplatParticleSystem.h"
#import "GameTeam.h"
#import "PawnInfo.h"
#import "SimpleAudioEngine.h"
#import "AnimationManager.h"
#import "Powerup.h"

@class GameController;

typedef enum
{
	Physics_Jumping,
	Physics_Falling,
	Physics_Walking
} PhysicsState;


typedef enum
{
	Pawn_Alive,
	Pawn_Dead
} PawnState;

@interface GamePawn : NSObject {
	//b2Vec2 position;
	//b2Vec2 velocity;
	CGPoint startPosition;
	CCSprite* bodySprite;
	CCSprite* gunSprite;
	b2Body* physicsBody;
	b2Vec2 size;
	b2Vec2 offset;
	CGPoint gunOffset;
	CGPoint gunAnchorPoint;
	CGPoint muzzleOffset;
	CGPoint tiltPosition;
	float jumpSpeed;
	float maxSpeed;
	float moveForceMag;
	float airMoveForceMag;
	float jumpForceMag;
	float aimAngle;
	float facing;
	float fireForce;
	bool isFiring;
	float timeSinceFire;
	float timeSinceAim;
	float fireInterval;
	float zeroAimInterval;
	float health;
	float fireDamage;
	float lastMoveForce;
	float moveForceInterval;
	float walkDirection;
    int spriteVariation;
	GameTeam* team;
	GameController* controller;
	ProjectilePool* projectilePool;
	NSString* spriteName;
	PhysicsState physicsState;
	PawnState pawnState;
	NSString* pawnType;
	bool healthUpdated;
    NSMutableArray* powerups;
    //Mods
    float fireForceMod;
    float fireIntervalMod;
    CGSize bodySpriteDefaultSize;
}

-(id) initForController:(GameController*)ctrl;
-(b2Vec2) position;
-(b2Vec2) velocity;
-(void) setPosition:(CGPoint)pos;
-(void) setVelocity:(b2Vec2) velocity;
-(bool) walk:(b2Vec2) direction;
-(bool) jump:(float)jumpPower;
-(void) applyLimits;
-(void) synchronizePawnPhysics:(ccTime)dt;
-(void) updateFire:(ccTime)dt;
-(bool) fire:(CGPoint)target;
-(void) endFire;
-(CGPoint) getFirePoint;
-(CGPoint) getWorldTiltPoint;
-(void) setProjectilePool:(ProjectilePool*)pool;
-(void) setGameController:(GameController*)ctrl;
-(void) killPawn;
-(void) reset;
-(bool) isDead;
-(void) takeDamage:(float)damage;
-(PawnInfo*) getPawnInfo;
-(void) initializeAnimations:(AnimationManager*)animationManager;
-(void) initializeWalkAnimation:(AnimationManager*)animationManager;
-(void) initializeStandAnimation:(AnimationManager*)animationManager;
-(void) initializeJumpAnimation:(AnimationManager*)animationManager;
-(void) initializeFallAnimation:(AnimationManager*)animationManager;
-(void) initializeDeathAnimation:(AnimationManager*)animationManager;
-(void) initializeGunWalkAnimation:(AnimationManager*)animationManager;
-(void) initializeGunIdleAnimation:(AnimationManager*)animationManager;
-(void) initializeGunShootAnimation:(AnimationManager*)animationManager;
-(void) initializeGunDefaultAnimation:(AnimationManager*)animationManager;
-(void) processPowerups:(ccTime)dt;
-(void) equipPowerup:(Powerup*)powerup;
-(void) unequipPowerup:(Powerup*)powerup;
-(void) clearPowerups;
-(void) setVariation:(int)variation;
-(float) getFireInterval;


@property(readonly) GameController* controller;
@property(assign) CCSprite* bodySprite;
@property(assign) CCSprite* gunSprite;
@property(assign) CGPoint startPosition;
@property(assign) b2Body* physicsBody;
@property(assign) b2Vec2 size;
@property(assign) b2Vec2 offset;
@property(assign) float facing;
@property(assign) float aimAngle;
@property(assign) bool isFiring;
@property(readonly) float fireInterval;
@property(assign) NSString* spriteName;
@property(assign) GameTeam* team;
@property(assign) float health;
@property(readonly) PhysicsState physicsState;
@property(assign) bool healthUpdated;
@property(assign) NSString* pawnType;
@property(readonly) float walkDirection;
@end
