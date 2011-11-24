//
//  Infiltrate.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Infiltration.h"
#import "ScoreManager.h"

@implementation Infiltration

-(id) init{
    self = [super init];
    self.Respawn = false;
    return self;
}

-(void) GameStart{
    startDate = [[NSDate date] retain];
}

-(void) GameEnd{
    NSDate* endDate = [NSDate date];
    completionTime = [endDate timeIntervalSinceDate:startDate];
    [startDate release];
    startDate = nil;
}

-(GameTeam*) GetWinningTeam:(NSArray *)teams
{
	GameTeam* playerTeam = [teams objectAtIndex:0];
	GameTeam* enemyTeam = [teams objectAtIndex:1];
    
    if(enemyTeam.teamKills > 0)
        return enemyTeam;
    else if(playerTeam.teamKills == enemyTeam.teamCount)
        return playerTeam;
    
	return nil;
}

-(void) LoadLevel{
    NSDictionary* pListData = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Infiltration.plist",world]]];
    NSArray* levels = [pListData objectForKey:@"Levels"];
    NSDictionary* levelDefinition = [levels objectAtIndex:(level-1)];
    targetTime = [[levelDefinition objectForKey:@"TargetTime"] doubleValue];
    NSArray* botArray = [levelDefinition objectForKey:@"Bots"];
    
    if(bots != nil)
        [bots release];
    bots = [[NSMutableArray array] retain];
    for(uint i = 0; i < [botArray count];i++){
        NSDictionary* botDef = [botArray objectAtIndex:i];
        GameTypeBot* bot = [[[GameTypeBot alloc] init] autorelease];
        bot.x = [[botDef objectForKey:@"X"] floatValue];
        bot.y = [[botDef objectForKey:@"Y"] floatValue];
        bot.pawnType = [botDef objectForKey:@"PawnType"];
        bot.ai = [botDef objectForKey:@"AI"];
        bot.handicap = [[botDef objectForKey:@"Handicap"] floatValue];
        botScore += floor(bot.handicap * 50);
        bot.team = 2;
        [bots addObject:bot];
    }
}

-(GameTypes) getGameType{
    return GameType_Infiltration;
}

-(NSString*) GetScoreCategory
{
    return @"PaintPawsInfiltration";
}

-(uint) GetScoreForPlayer:(PlayerController*)player team:(GameTeam*)team1 enemyTeam:(GameTeam*)team2{
    if(player.deaths > 0)
    {
        return 0;
    }
    else
    {
        uint score = botScore + MAX(0, targetTime - completionTime) * 20;
        if([[ScoreManager sharedScoreManager] SetInfiltrationScore:score ForLevel:level InWorld:world])
        {
            [[ScoreManager sharedScoreManager] SaveScores];
        }
        return score;
    }
}

-(void) dealloc
{
    [super dealloc];
    if(startDate != nil)
        [startDate release];
}

@end
