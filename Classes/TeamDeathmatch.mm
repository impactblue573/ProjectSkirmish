//
//  TeamDeathmatch.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 2/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "TeamDeathmatch.h"
#import "ScoreManager.h"

@implementation TeamDeathmatch

-(id) initWithWinScore:(NSInteger)score numBots:(uint)numBots
{
	self = [super init];
	winScore = score;
    self.NumBots = numBots;
    self.Respawn = true;
	return self;
}

-(GameTypes) getGameType{
    return GameType_TeamDeathmatch;
}

-(NSMutableArray*) GetBots
{
    NSMutableArray* botArray = [NSMutableArray array];
    for(uint i = 0; i < self.NumBots;i++)
    {
        GameTypeBot* bot = [[[GameTypeBot alloc] init] autorelease];
        [botArray addObject:bot];
    }
    return botArray;
}

-(GameTeam*) GetWinningTeam:(NSArray *)teams
{
	for(NSUInteger i = 0; i < [teams count]; i++)
	{
		GameTeam* gameTeam = (GameTeam*)[teams objectAtIndex:i];
		if(gameTeam.teamKills >= winScore)
		{
			return gameTeam;
		}
	}
	return nil;
}

-(NSString*) GetScoreCategory
{
    return @"PaintPawsTeamDeathmatch";
}

-(uint) GetScoreForPlayer:(PlayerController*)player team:(GameTeam*)team1 enemyTeam:(GameTeam*)team2{
    uint score = MAX(player.kills * 10 - player.deaths * 5,0) + MAX(team1.teamKills - team2.teamKills,0) * 10;
    [[ScoreManager sharedScoreManager] AddTDMScore:score];
    [[ScoreManager sharedScoreManager] AddKills:player.kills];
    [[ScoreManager sharedScoreManager] AddDeaths:player.deaths];
    [[ScoreManager sharedScoreManager] SaveScores];
    return score;
}

@end
