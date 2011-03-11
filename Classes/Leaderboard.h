//
//  Leadboard.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 10/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

struct LeaderboardEntry
{
	NSString* playerID;
	ccColor3B teamColor;
	int kills;
	int deaths;
	int height;
	int width;
	int topOffset;
};

typedef struct LeaderboardEntry LeaderboardEntry;

@interface Leaderboard : CCLayerColor {

	NSArray* leaderboardEntries;
}

-(id) initWithLeaderboardEntries:(NSArray*)entries;
-(void) processEntries:(NSArray*)entries;
NSInteger entrySort(id v1, id v2, void *context);


@property(assign) int width;
@property(assign) int height;
@end
