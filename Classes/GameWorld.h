//
//  GameWorld.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "GameConfig.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "b2Fixture.h"
#import "GLES-Render.h"
#import "GamePawn.h"
#import "AnimationHelper.h"
#import "ProjectilePool.h"
#import "BattleInfo.h"
#import "ProjectileContactListener.h"
#import "OneSideContactFilter.h"
#import "PowerupManager.h"

@class PowerupFactory;
@class PowerupManager;

@interface GameWorld : CCLayer 
{
	CGSize worldSize;
	b2World* physicsWorld;	
	NSMutableArray* gamePawnList;	
	GLESDebugDraw *m_debugDraw;
	ProjectilePool* projectilePool;
	NSMutableArray* activeProjectiles;
	NSString* serverPeerID;
	TeamSpawnPoint teamASpawnPoint;
	TeamSpawnPoint teamBSpawnPoint;
    float minTimeStep;
    float currentTimeStep;
    PowerupManager* powerupManager;
}

-(id) initWorld:(NSString*)worldName;
-(b2Body*) addStaticBody:(CGPoint)pos ofSize:(b2Vec2)size withSprite:(CCSprite*)sprite usingFilter:(b2Filter)filter;
-(void) buildWorld:(NSString*)worldName;
-(void) updateWorld:(ccTime)dt;
-(void) updateProjectiles:(ccTime)dt;
-(void) spawnProjectile:(Projectile*)proj;
-(void) spawnGamePawn:(GamePawn*)pawn;
-(void) createPawnBody:(GamePawn*)pawn;
-(void) respawn:(GamePawn *)pawn;
-(BattleInfo*) getBattleInfo;
-(TeamSpawnPoint) getTeamASpawnPoint;
-(TeamSpawnPoint) getTeamBSpawnPoint;
-(void) destroyPhysicsBody:(b2Body*)body;
-(void) spawnPowerup:(PowerupFactory*)powerup;

@property CGSize worldSize;
@end
