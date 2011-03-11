//
//  TeamDeathmatch.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 2/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "TeamDeathmatch.h"


@implementation TeamDeathmatch

-(id) initWithWinScore:(NSInteger) score
{
	self = [super init];
	winScore = score;
	return self;
}

-(GameTeam*) GetWinningTeam:(NSArray *)teams
{
	for(NSUInteger i = 0; i < [teams count]; i++)
	{
		GameTeam* gameTeam = (GameTeam*)[teams objectAtIndex:i];
		if(gameTeam.teamKills >= winScore)
			return gameTeam;
	}
	return nil;
}
@end
