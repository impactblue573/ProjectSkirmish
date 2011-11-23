//
//  Resistance.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Resistance.h"


@implementation Resistance

-(id) init{
    self = [super init];
    self.Respawn = false;
    return self;
}

-(NSMutableArray*) GetBots
{
    NSMutableArray* botArray = [NSMutableArray array];
    for(uint i = 0; i < 3;i++)
    {
        GameTypeBot* bot = [[[GameTypeBot alloc] init] autorelease];
        bot.pawnType = @"Lambo";
        bot.team = 2;
        bot.handicap = 0.3;
        [botArray addObject:bot];
    }
    return botArray;
}

-(void) GameStart{
    startDate = [[NSDate date] retain];
}

-(void) GameEnd{
}

-(GameTeam*) GetWinningTeam:(NSArray *)teams
{
	GameTeam* playerTeam = [teams objectAtIndex:0];
	GameTeam* enemyTeam = [teams objectAtIndex:1];
    
    if(enemyTeam.teamKills > 0)
        return enemyTeam;
    else {        
        NSDate* endDate = [NSDate date];
        completionTime = [endDate timeIntervalSinceDate:startDate];
        if(completionTime >= 30)
            return playerTeam;
    }
    
	return nil;
}

-(NSString*) GetScoreCategory
{
    return @"PaintPawsResistance";
}

-(uint) GetScoreForPlayer:(PlayerController*)player team:(GameTeam*)team1 enemyTeam:(GameTeam*)team2
{
    return completionTime > 30 ? player.kills * 20 : player.kills * 5;
}

-(void) dealloc
{
    [super dealloc];
    if(startDate != nil)
        [startDate release];
}

@end
