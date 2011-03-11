//
//  GameController.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GamePawn.h"
#import "AnimationManager.h"
#import "AnimationTreeManager.h"
#import "BlendByFallAnimationNode.h"
#import "BlendBySpeedAnimationNode.h"
#import "BlendByFiringAnimationNode.h"
#import "BlendByStateAnimationNode.h"
#import "PawnFactory.h"
#import "Leaderboard.h"

@class GameWorld;

@interface GameController : NSObject {
	GameWorld* gameWorld;
	GamePawn* pawn;
	AnimationManager* animationManager;
	AnimationTreeManager* bodyAnimationTree;
	AnimationTreeManager* gunAnimationTree;
	GameTeam* team;
	NSString* pawnType;
	float respawnTime;
	float timeSinceDeath;
	bool respawnCountBegun;
	NSString* playerID;
	NSString* playerName;
	float lastNetworkSync;
	float networkSyncInterval;
	int deaths;
	int kills;
}

-(id) initInWorld:(GameWorld *)world usingPawn:(NSString*)pType asTeam:(GameTeam*)team withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName;
-(void) initializeGamePawn;
-(void) updatePawn:(ccTime)dt;
-(void) initializeAnimations;
-(void) pawnHit:(float)damage;
-(void) killPawn;
-(void) registerKill;
-(LeaderboardEntry) getLeaderboardEntry;

@property(assign) GamePawn* pawn;
@property(assign) NSString* playerID;
@property(assign) NSString* pawnType;
@property(assign) int deaths;
@property(assign) int kills;
@property(assign) GameTeam* team;
@property(assign) NSString* playerName;

@end