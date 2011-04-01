//
//  BotController.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "BotController.h"
#import "GameScene.h"

@implementation BotController

@synthesize aiType;

-(id) init
{
	mishotFactor = 250;
	netMoveInterval = 0.1f;
	netJumpInterval = 0.2f;
	int ai = arc4random()%3;
	if(ai == 0)
		aiType = AI_Commando;
	else if(ai == 1)
		aiType = AI_Sniper;
	else if(ai == 2)
		aiType = AI_Ninja;
	shootInterval = pawn.fireInterval;
	return [super init];
}

-(NSString*) getAIAsString
{
	if(aiType == AI_Commando)
		return @"Com";
	else if(aiType == AI_Sniper)
		return @"Sni";
	else
		return @"Nin";
}

-(id) initInWorld:(GameWorld*)world usingPawn:(NSString*)pType asTeam:(GameTeam*)t withPlayerID:(NSString*)pID withPlayerName:(NSString*)pName;
{
	self = [super initInWorld:world usingPawn:pType asTeam:t withPlayerID:pID withPlayerName:nil];
	playerName = [[NSString stringWithFormat:@"%@ %@ %@",pawn.pawnType,[self getAIAsString],pName] retain];
	return self;
}

-(NetworkPlayerInput*) processBattleInfo:(BattleInfo*)battleInfo delta:(float)dt
{
	float difficulty = [GameScene getDifficultyFactor];
	NetworkPlayerInput* netInput = [[NetworkPlayerInput alloc] init];
	netInput.playerID = playerID;
	
	if(![pawn isDead])
	{
		timeSinceLastShot += dt;
		timeSinceLastNetJump += dt;
		timeSinceLastNetMove += dt;
		
		if(timeSinceLastNetMove > netMoveInterval)
		{
			timeSinceLastNetMove = 0;
			
			b2Vec2 pos = [pawn position];
			b2Vec2 vel = [pawn velocity];
			//Do position synch
			if(lastNetworkSync > networkSyncInterval)
			{
				lastNetworkSync = 0;
				netInput.positionX = [NSNumber numberWithFloat:pos.x];
				netInput.positionY = [NSNumber numberWithFloat:pos.y];
				netInput.velocityX = [NSNumber numberWithFloat:vel.x];
				netInput.velocityY = [NSNumber numberWithFloat:vel.y];
			}
			else
				lastNetworkSync += dt;
			
			NSArray* enemyPos = [battleInfo getEnemyLocations:pawn];
			
			if([enemyPos count] > 0)
			{		
				b2Vec2 moveVec;
				
				//first check if they're in home area
				if([Helper point:ccp(pos.x, pos.y) isInRect:team.spawnPoint.homeArea])
				{
					if(team.teamIndex == 2)
						moveVec = b2Vec2(1,0);
					else
						moveVec = b2Vec2(-1,0);
					if([pawn walk:moveVec])					
						netInput.moveVector = [NSNumber numberWithFloat:moveVec.x];
				}
				else 
				{
					CGPoint pos;	
					NSValue* val = [enemyPos objectAtIndex:0];
					[val getValue:&pos];		
					float distance = pos.x - [pawn position].x;
					//Loop through sorted list to find closest
					for(NSUInteger i = 1; i < [enemyPos count]; i++)
					{
						NSValue* val = [enemyPos objectAtIndex:i];
						CGPoint tempPos;
						[val getValue:&tempPos];
						float tempDist = tempPos.x - [pawn position].x;
						if(fabsf(tempDist) < fabsf(distance))
						{
							pos = tempPos;
							distance = tempDist;
						}
						//Once the distance is greater than the previous...we're done as it'll only increase
						//else
						//	break;
					}			
					
					float shootDistance = 240;
					float maintainDistance = 0;
					if(aiType == AI_Sniper)
					{
						shootDistance = 480;
						maintainDistance = 240;
					}
					else if(aiType == AI_Ninja)
					{
						maintainDistance = 120;
					}
					
					if(fabsf(distance) > shootDistance)
					{
						moveVec = b2Vec2([Helper normalize:distance],0);
						//jump and move towards them
						if([pawn walk:moveVec])					
							netInput.moveVector = [NSNumber numberWithFloat:moveVec.x];
						if([pawn jump])
							netInput.hasJump = [NSNumber numberWithBool:true];
					}
					else
					{			
						if(fabsf(distance) < maintainDistance)
						{
							//jump and move away from them
							moveVec = b2Vec2(-1 * [Helper normalize:distance],0);
							if([pawn walk:moveVec])
								netInput.moveVector = [NSNumber numberWithFloat:moveVec.x];
							if([pawn jump])
								netInput.hasJump = [NSNumber numberWithBool:true];
						}		
						else {
							if([pawn walk:b2Vec2(0,0)])
								netInput.moveVector = [NSNumber numberWithFloat:0];
						}

						
						if(timeSinceLastShot >= pawn.fireInterval / difficulty)
						{
							float arc4 = arc4random() % 100;
							float random = (arc4 - 50) / 100.0f;
							float absMod = random * mishotFactor * (1.0f-difficulty);
							pos = ccp(pos.x, pos.y + absMod);
							[pawn fire:pos];
							timeSinceLastShot = 0;
							netInput.shootPointX = [NSNumber numberWithFloat:pos.x];
							netInput.shootPointY = [NSNumber numberWithFloat:pos.y];
						}
						
					}

					
					if(aiType == AI_Ninja)
					{
						if([pawn jump])
							netInput.hasJump = [NSNumber numberWithBool:true];
					}
				}
			}
		}
	}
	return netInput;
}
@end
