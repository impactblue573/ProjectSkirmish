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

@synthesize pawn,playerID,pawnType,deaths,kills,team,playerName,updated,respawn;

-(id) initInWorld:(GameWorld*)world usingPawn:(NSString*)pType asTeam:(GameTeam*)t withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName
{
    return [self initInWorld:world usingPawn:pType asTeam:t withPlayerID:pID withPlayerName:pName usingVariation:0];
}

-(id) initInWorld:(GameWorld*)world usingPawn:(NSString*)pType asTeam:(GameTeam*)t withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName usingVariation:(int)variation
{
	if(pID != nil)
		self.playerID = [NSString stringWithString:pID];
	if(pName != nil)		
		self.playerName = [NSString stringWithString:pName];
	gameWorld = world;
	team = t;
    spriteVariation = variation;
	if(pType != nil)
		self.pawnType = [NSString stringWithString:pType];
	self = [self init];
	[animationManager addToLayer:world];
    targetter = [[Targetter alloc] initWithSprite:(team.teamIndex == 2 ? @"RedCrosshair2.png" : @"BlueCrosshair2.png") inLayer:gameWorld];
    targetted = false;
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

-(void) setTargetted:(bool)t
{
    targetted = t;
    if(targetted)
    {
        [targetter activate];
    }
    else
    {
        [targetter deactivate];
    }
}

-(void) initializeGamePawn
{
	pawn = pawnType == nil ? [[PawnFactory initializePawn] retain] : [[PawnFactory initializePawnType:pawnType] retain];
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
    NSArray* speedList = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:100],nil];
    NSArray* mappingList = [NSArray arrayWithObjects:@"Idle",@"Walk",nil];
    NSArray* gunMappingList = [NSArray arrayWithObjects:@"GunIdle",@"GunSwing",nil];
	//Init Body Animation Tree
	bodyAnimationTree = [[AnimationTreeManager alloc] init];	
	[bodyAnimationTree appendNode:[[[BlendByStateAnimationNode alloc] initWithDeathAnimation:@"Death"] autorelease]];
	[bodyAnimationTree appendNode:[[[BlendByFallAnimationNode alloc] initWithRiseAnimation:@"Jump" fallAnim:@"Fall"] autorelease]];
	[bodyAnimationTree appendNode:[[[BlendBySpeedAnimationNode alloc] initWithSpeedList:speedList animationMapping:mappingList] autorelease]];
	//Init Gun Animation Tree
	gunAnimationTree = [[AnimationTreeManager alloc] init];
	[gunAnimationTree appendNode:[[[BlendByStateAnimationNode alloc] initWithDeathAnimation:@"GunDefault"] autorelease]];
	[gunAnimationTree appendNode:[[[BlendByFiringAnimationNode alloc] initWithFireAnimation:@"GunShoot"] autorelease]];
	[gunAnimationTree appendNode:[[[BlendByFallAnimationNode alloc] initWithRiseAnimation:@"GunDefault" fallAnim:@"GunDefault"] autorelease]];
	[gunAnimationTree appendNode:[[[BlendBySpeedAnimationNode alloc] initWithSpeedList:speedList animationMapping:gunMappingList] autorelease]];
	
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
    
    if(targetted)
    {
        if([pawn isDead])
        {
            [targetter deactivate];
        }
        else if(![pawn isDead])
        {
            [targetter activate];
        }
        b2Vec2 pawnPos = [pawn position];
        [targetter setPosition:ccp(pawnPos.x,pawnPos.y)];
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
	
    if(respawn)
    {
        timeSinceDeath = 0;
        respawnCountBegun = true;
    }
    
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

-(void) dealloc
{
    [playerID release];
    [playerName release];
    [pawnType release];
    [animationManager release];
    [bodyAnimationTree release];
    [gunAnimationTree release];
    [targetter release];
    [super dealloc];
}

@end
