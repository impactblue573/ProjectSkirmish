//
//  Resistance.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Resistance.h"
#import "ScoreManager.h"

@implementation Resistance

-(id) init{
    self = [super init];
    self.Respawn = true;
    return self;
}


-(void) LoadLevel{
    NSString* filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Resistance.plist",world]];
    NSDictionary* pListData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray* levels = [pListData objectForKey:@"Levels"];
    NSDictionary* levelDefinition = [levels objectAtIndex:(level-1)];
    targetTime = [[levelDefinition objectForKey:@"TargetTime"] doubleValue];
    botScore = [[levelDefinition objectForKey:@"BotScore"] intValue];
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
        
        bot.team = 2;
        [bots addObject:bot];
    }
}

-(GameTypes) getGameType{
    return GameType_Resistance;
}

-(GameTeam*) GetWinningTeam:(NSArray *)teams
{
	GameTeam* playerTeam = [teams objectAtIndex:0];
	GameTeam* enemyTeam = [teams objectAtIndex:1];
    
    if(enemyTeam.teamKills > 0)
        return enemyTeam;
    else {        
        if(completionTime >= targetTime)
            return playerTeam;
    }
    
	return nil;
}

-(NSString*) GetScoreCategory
{
    return @"PaintPawsResistance";
}

-(NSString*) getObjective{
    return [NSString stringWithFormat:@"Survive for %d seconds! Eliminate opponents for bonus points!",(uint)targetTime];
}

-(uint) GetScoreForPlayer:(PlayerController*)player team:(GameTeam*)team1 enemyTeam:(GameTeam*)team2
{
    if(player.deaths > 0)
        return 0;
    uint score = player.kills * botScore + targetTime;
    if([[ScoreManager sharedScoreManager] SetResistanceScore:score ForLevel:level InWorld:world])
    {
        [[ScoreManager sharedScoreManager] SaveScores];
    }
    
    return score;
}

-(void) dealloc
{
    [super dealloc];
}

@end
