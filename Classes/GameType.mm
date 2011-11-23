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
    return nil;
}

-(void) GameStart{
    
}

-(void) GameEnd{
    
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
}
@end
