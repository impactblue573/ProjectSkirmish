//
//  Leadboard.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 10/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "Leaderboard.h"


@implementation Leaderboard
@synthesize width,height;

-(id) initWithLeaderboardEntries:(NSArray*)entries
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	self.width = screenSize.width-80;
	self.height = screenSize.height-80;
	self = [super initWithColor:(ccColor4B){255,255,255,200} width:self.width height:self.height];
	[self processEntries:entries];
	return self;
}

-(void) processEntries:(NSArray*)entries
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	leaderboardEntries = entries;
	int playerColumnWidth = width/2 - 30;
	int topOffset = height - 20;
	
	CCLabelTTF* playerLabel = [CCLabelTTF labelWithString:@"Player" dimensions:CGSizeMake(playerColumnWidth,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:18];
	[playerLabel setColor:(ccColor3B){50,50,50}];
	playerLabel.position = ccp(playerColumnWidth/2,topOffset);
	
	CCLabelTTF* killLabel = [CCLabelTTF  labelWithString:@"Kills" dimensions:CGSizeMake(playerColumnWidth/2,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:18];
	[killLabel setColor:(ccColor3B){50,50,50}];
	killLabel.position = ccp(width/2 + 20,topOffset);
	
	CCLabelTTF* deathLabel = [CCLabelTTF  labelWithString:@"Deaths" dimensions:CGSizeMake(playerColumnWidth/2,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:18];
	[deathLabel setColor:(ccColor3B){50,50,50}];
	deathLabel.position = ccp(width/2 + 80,topOffset);
	
	[self addChild:playerLabel];
	[self addChild:killLabel];
	[self addChild:deathLabel];

	topOffset -= 20;
	
	NSArray* sortedEntries = [leaderboardEntries sortedArrayUsingFunction:entrySort context:NULL];
	for(uint i = 0; i < [sortedEntries count]; i++)
	{
		LeaderboardEntry entry;
		[[sortedEntries objectAtIndex:i] getValue:&entry];
		playerLabel = [CCLabelTTF labelWithString:entry.playerID dimensions:CGSizeMake(playerColumnWidth,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:18];
		[playerLabel setColor:entry.teamColor];
		playerLabel.position = ccp(playerColumnWidth/2,topOffset);
		
		NSString* deathFormat = entry.deaths ? @"-%d" : @"%d";
		NSString* killFormat = entry.kills ? @"+%d" : @"%d";

		killLabel = [CCLabelTTF  labelWithString:[NSString stringWithFormat:killFormat,entry.kills] dimensions:CGSizeMake(playerColumnWidth/2,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:18];
		[killLabel setColor:(ccColor3B){50,255,50}];
		killLabel.position = ccp(width/2 + 20,topOffset);
		
		deathLabel = [CCLabelTTF  labelWithString:[NSString stringWithFormat:deathFormat,entry.deaths] dimensions:CGSizeMake(playerColumnWidth/2,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:18];
		[deathLabel setColor:(ccColor3B){255,50,50}];
		deathLabel.position = ccp(width/2 + 80,topOffset);
		
		[self addChild:playerLabel];
		[self addChild:killLabel];
		[self addChild:deathLabel];
		topOffset -= 20;
	}
}

NSInteger entrySort(id v1, id v2, void *context)
{
    LeaderboardEntry entry1,entry2;
	[v1 getValue:&entry1];
	[v2 getValue:&entry2];

    if (entry1.kills < entry2.kills)
        return NSOrderedDescending;
    else if (entry1.kills > entry2.kills)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}


@end
