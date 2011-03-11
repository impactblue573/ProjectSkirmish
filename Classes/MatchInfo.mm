//
//  MatchInfo.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "MatchInfo.h"


@implementation MatchInfo

@synthesize team1Score,team2Score,playerKills,playerDeaths,playerIDs,pawnHealths;

-(id) init
{
	self = [super init];
	pawnHealths = [[NSMutableArray alloc] init];
	playerKills = [[NSMutableArray alloc] init];
	playerDeaths = [[NSMutableArray alloc] init];
	playerIDs = [[NSMutableArray alloc] init];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:team1Score];
	[aCoder encodeObject:team2Score];
	[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:pawnHealths]];	
	[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:playerKills]];	
	[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:playerDeaths]];	
	[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:playerIDs]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	team1Score = [[aDecoder decodeObject] retain];
	team2Score = [[aDecoder decodeObject] retain];
	pawnHealths = [[NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObject]] retain];
	playerKills = [[NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObject]] retain];
	playerDeaths = [[NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObject]] retain];
	playerIDs = [[NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObject]] retain];
	return self;
}

-(void) addPawnHealth:(int)health withKills:(int)kills withDeaths:(int)deaths withPlayerID:(NSString*)playerID ;
{
	[pawnHealths addObject:[NSNumber numberWithInt:health]];
	[playerKills addObject:[NSNumber numberWithInt:kills]];
	[playerDeaths addObject:[NSNumber numberWithInt:deaths]];
	[playerIDs addObject:playerID];
}

-(void) dealloc
{
	[team1Score release];
	[team2Score release];
	[pawnHealths release];
	[playerIDs release];
	[super dealloc];
}
@end
