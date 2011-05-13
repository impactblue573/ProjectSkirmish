//
//  GameController.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "GameWorld.h"
#import "GameScene.h"

@implementation GameController

@synthesize pawn,playerID,pawnType,deaths,kills,team,playerName,updated;

-(id) initInWorld:(GameWorld*)world usingPawn:(NSString*)pType asTeam:(GameTeam*)t withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName
{
    return [self initInWorld:world usingPawn:pType asTeam:t withPlayerID:pID withPlayerName:pName usingVariation:1];
}

-(id) initInWorld:(GameWorld*)world usingPawn:(NSString*)pType asTeam:(GameTeam*)t withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName usingVariation:(int)variation
{
	if(pID != nil)
		self.playerID = [[NSMutableString alloc ] initWithString:pID];
	if(pName != nil)		
		self.playerName = [[NSMutableString alloc ] initWithString:pName];
	gameWorld = world;
	team = t;
    spriteVariation = variation;
	if(pType != nil)
		self.pawnType = [[NSMutableString alloc ] initWithString:pType];
	self = [self init];
	[animationManager addToLayer:world];
	return self;
}

-(id) init
{	
	respawnTime = 5.0;
	deaths = 0;
	kills = 0;
	[self initializeGamePawn];
	[self initializeAnimations];
	return self;
}

-(void) initializeGamePawn
{
	pawn = pawnType == nil ? [PawnFactory initializePawn] : [PawnFactory initializePawnType:pawnType];
	[pawn setGameController:self];
	pawn.team = team;
    [pawn setVariation:spriteVariation];
	team.teamCount++;
	//[animationManager playLoopAnimation:@"Idle" forSprite:@"Body"];
}

-(void) initializeAnimations
{
	animationManager = [[AnimationManager alloc] init];
	[pawn initializeAnimations:animationManager];
	//Init Body Animation Tree
	bodyAnimationTree = [[AnimationTreeManager alloc] init];	
	[bodyAnimationTree appendNode:[[BlendByStateAnimationNode alloc] initWithDeathAnimation:@"Death"]];
	[bodyAnimationTree appendNode:[[BlendByFallAnimationNode alloc] initWithRiseAnimation:@"Jump" fallAnim:@"Fall"]];
	[bodyAnimationTree appendNode:[[BlendBySpeedAnimationNode alloc] initWithSpeedList:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:100],nil] animationMapping:[NSArray arrayWithObjects:@"Idle",@"Walk",nil]]];
	//Init Gun Animation Tree
	gunAnimationTree = [[AnimationTreeManager alloc] init];
	[gunAnimationTree appendNode:[[BlendByStateAnimationNode alloc] initWithDeathAnimation:@"GunDefault"]];
	[gunAnimationTree appendNode:[[BlendByFiringAnimationNode alloc] initWithFireAnimation:@"GunShoot"]];
	[gunAnimationTree appendNode:[[BlendByFallAnimationNode alloc] initWithRiseAnimation:@"GunDefault" fallAnim:@"GunDefault"]];
	[gunAnimationTree appendNode:[[BlendBySpeedAnimationNode alloc] initWithSpeedList:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:100],nil] animationMapping:[NSArray arrayWithObjects:@"GunIdle",@"GunSwing",nil]]];
	
}
	 
-(void) updatePawn:(ccTime)dt
{
	
	[pawn applyLimits];
	//Run Body Animation Trees
	AnimationSequence bAnim = [bodyAnimationTree Eval:pawn];
	if(bAnim.animationName != nil)
	{
		if(bAnim.loopAnimation)
			[animationManager playLoopAnimation:bAnim.animationName forSprite:@"Body"];
		else
			[animationManager playAnimation:bAnim.animationName forSprite:@"Body" ignoreDuplicate:bAnim.ignoreDuplicate];
	}
	//Run Gun Animation Tree
	AnimationSequence gAnim = [gunAnimationTree Eval:pawn];
	if(gAnim.animationName != nil)
	{
		if(gAnim.loopAnimation)
			[animationManager playLoopAnimation:gAnim.animationName forSprite:@"Gun"];
		else
			[animationManager playAnimation:gAnim.animationName forSprite:@"Gun" ignoreDuplicate:gAnim.ignoreDuplicate];
	}
	
	[pawn synchronizePawnPhysics:dt];
    [pawn processPowerups:dt];
	
	if(![pawn isDead])
	{
		[pawn updateFire:dt];
		if(pawn.health <=0)
			[self killPawn];
	}
	else if(respawnCountBegun) 
	{
		timeSinceDeath += dt;
		if(timeSinceDeath > respawnTime)
		{
			[gameWorld respawn:pawn];
			respawnCountBegun = false;
		}
	}
}

/*Returns true if the hit killed the pawn*/
-(bool) pawnHit:(float)damage
{
	if(![pawn isDead] && pawn.health > 0)
	{
		[pawn takeDamage:damage];
		if(pawn.health <= 0)
		{
			[self killPawn];
			return true;
		}
	}
	return false;
}

-(void) killPawn
{
	[pawn killPawn];
	timeSinceDeath = 0;
	respawnCountBegun = true;
	if([GameScene isServer] || [GameScene CurrentGameMode] == Game_Single)
	{
		deaths++;
		team.teamDeaths++;
		updated = true;
	}
}

-(void) registerKill
{
	kills++;
	team.teamKills++;
	team.updated = true;
	updated = true;
}

-(LeaderboardEntry) getLeaderboardEntry
{
	LeaderboardEntry entry;
	entry.playerID = playerName;
	entry.kills = kills;
	entry.deaths = deaths;
	entry.teamColor = team.teamColor;
	return entry;
}

@end
