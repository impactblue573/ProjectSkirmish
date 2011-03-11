//
//  GameTeam.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

struct TeamSpawnPoint
{
	CGPoint spawnPoint;
	CGRect homeArea;
};

typedef struct TeamSpawnPoint TeamSpawnPoint;

@interface GameTeam : NSObject {
	int teamIndex;
	int teamKills;
	int teamDeaths;
	int teamCount;
	NSString* paintballSprite;
	ccColor3B teamColor;
	TeamSpawnPoint spawnPoint;
	bool updated;
}

@property int teamIndex;
@property int teamKills;
@property int teamDeaths;
@property int teamCount;
@property TeamSpawnPoint spawnPoint;
@property bool updated;
@property(assign) NSString* paintballSprite;
@property(assign) ccColor3B teamColor;

@end
