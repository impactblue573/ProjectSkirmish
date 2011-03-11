//
//  GameController.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "GameWorld.h"

@implementation GameController

@synthesize pawn,playerID,pawnType,deaths,kills,team,playerName;

-(id) initInWorld:(GameWorld*)world usingPawn:(NSString*)pType asTeam:(GameTeam*)t withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName;
{
	if(pID != nil)
		self.playerID = [[NSMutableString alloc ] initWithString:pID];
	if(pName != nil)		
		self.playerName = [[NSMutableString alloc ] initWithString:pName];
	gameWorld = world;
	team = t;
	if(pType != nil)
		self.pawnType = [[NSMutableString alloc ] initWithString:pType];
	self = [self init];
	[animationManager addToLayer:world];
	return self;
}

-(id) init
{	
	networkSyncInterval = 0.3;
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
	team.teamCount++;
	//[animationManager playLoopAnimation:@"Idle" forSprite:@"Body"];
}

-(void) initializeAnimations
{
	animationManager = [[AnimationManager alloc] init];
	[animationManager initSpriteSheet:pawn.spriteName];
	//Walk Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Walk-Left-1.png",@"Walk-Left-2.png",@"Walk-Left-1.png",@"Default.png",@"Walk-Right-1.png",@"Walk-Right-2.png",@"Walk-Right-1.png",nil];
	[animationManager addAnimation:@"Walk" usingFrames:frameNames frameDelay:0.05];
	//Stand Animation
	frameNames = [NSArray arrayWithObjects:@"Default.png",@"Stand-1.png",@"Stand-2.png",@"Stand-3.png",@"Stand-2.png",@"Stand-1.png",nil];
	[animationManager addAnimation:@"Idle" usingFrames:frameNames frameDelay:0.15];
	//Jump Animation
	frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",@"Jump-3.png",@"Jump-4.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05];
	//Fall Animation
	frameNames = [NSArray arrayWithObjects:@"Jump-3.png",@"Jump-2.png",@"Jump-1.png",@"Default.png",@"Fall-1.png",@"Fall-2.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1];
	//Death Animation
	frameNames = [NSArray arrayWithObjects:@"Death.png",nil];
	[animationManager addAnimation:@"Death" usingFrames:frameNames frameDelay:1.0];
	//Init Body Animation Tree
	bodyAnimationTree = [[AnimationTreeManager alloc] init];	
	[bodyAnimationTree appendNode:[[BlendByStateAnimationNode alloc] initWithDeathAnimation:@"Death"]];
	[bodyAnimationTree appendNode:[[BlendByFallAnimationNode alloc] initWithRiseAnimation:@"Jump" fallAnim:@"Fall"]];
	[bodyAnimationTree appendNode:[[BlendBySpeedAnimationNode alloc] initWithSpeedList:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:100],nil] animationMapping:[NSArray arrayWithObjects:@"Idle",@"Walk",nil]]];

	//Gun Walk Animation
	frameNames = [NSArray arrayWithObjects:@"Gun.png",@"Gun-Swing-Left-1.png",@"Gun-Swing-Left-2.png",@"Gun-Swing-Left-1.png",@"Gun.png",@"Gun-Swing-Right-1.png",@"Gun-Swing-Right-2.png",@"Gun-Swing-Right-1.png",nil];
	[animationManager addAnimation:@"GunSwing" usingFrames:frameNames frameDelay:0.1];
	//Gun Idle Animation
	frameNames = [NSArray arrayWithObjects:@"Gun.png",@"Gun-Idle-1.png",@"Gun-Idle-2.png",@"Gun-Idle-3.png",@"Gun-Idle-2.png",@"Gun-Idle-1.png",nil];
	[animationManager addAnimation:@"GunIdle" usingFrames:frameNames frameDelay:0.15];	
	//Gun Shoot Animation
	frameNames = [NSArray arrayWithObjects:@"Gun.png",@"Gun-Shoot-3.png",@"Gun-Shoot-2.png",@"Gun-Shoot-1.png",nil];
	[animationManager addAnimation:@"GunShoot" usingFrames:frameNames frameDelay:0.03];	
	//Gun Default Animation
	frameNames = [NSArray arrayWithObjects:@"Gun.png",nil];
	[animationManager addAnimation:@"GunDefault" usingFrames:frameNames frameDelay:1];
	//Init Gun Animation Tree
	gunAnimationTree = [[AnimationTreeManager alloc] init];
	[gunAnimationTree appendNode:[[BlendByStateAnimationNode alloc] initWithDeathAnimation:@"GunDefault"]];
	[gunAnimationTree appendNode:[[BlendByFiringAnimationNode alloc] initWithFireAnimation:@"GunShoot"]];
	[gunAnimationTree appendNode:[[BlendByFallAnimationNode alloc] initWithRiseAnimation:@"GunDefault" fallAnim:@"GunDefault"]];
	[gunAnimationTree appendNode:[[BlendBySpeedAnimationNode alloc] initWithSpeedList:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:100],nil] animationMapping:[NSArray arrayWithObjects:@"GunIdle",@"GunSwing",nil]]];
		
	pawn.bodySprite = [animationManager addSprite:@"Body" defaultFrame:@"Default.png"];	
	pawn.gunSprite = [animationManager addSprite:@"Gun" defaultFrame:@"Gun.png"];
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

-(void) pawnHit:(float)damage
{
	if(![pawn isDead])
	{
		[pawn takeDamage:damage];
		if(pawn.health <= 0)
		{
			[self killPawn];
		}
	}
}

-(void) killPawn
{
	[pawn killPawn];
	timeSinceDeath = 0;
	respawnCountBegun = true;
	deaths++;
	team.teamDeaths++;
}

-(void) registerKill
{
	kills++;
	team.teamKills++;
	team.updated = true;
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
