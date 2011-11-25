//
//  GameType.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 2/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "GameType.h"


@implementation GameType

@synthesize  NumBots,Respawn;

-(GameTeam*) GetWinningTeam:(NSArray *)teams
{
	return nil;
}

-(NSMutableArray*) GetBots
{
    return bots;
}

-(void) GameStart{
    completionTime = 0;
}

-(void) GameEnd{
    
}

-(NSString*) getObjective{
    return @"Eliminate opponents!";
}

-(NSTimeInterval) getTargetTime{
    return targetTime;
}

-(void) Tick:(NSTimeInterval)dt{
    completionTime+=dt;
}

-(GameTypes) getGameType{
    return GameType_TeamDeathmatch;
}

-(void) SetLevel:(uint)l ForWorld:(NSString*)w{
    if(world != nil)
        [world release];
    world = [w retain];
    level = l;
    [self LoadLevel];
}

-(void) LoadLevel{
    
}

-(NSString*) GetScoreCategory
{
    return @"";
}

-(uint) GetScoreForPlayer:(PlayerController*)player team:(GameTeam*)team1 enemyTeam:(GameTeam*)team2{
    return 0;
}

-(void) dealloc{
    [super dealloc];
    if(world != nil)
        [world release];
    if(bots != nil)
        [bots release];
}
@end
