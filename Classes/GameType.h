//
//  GameType.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 2/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameTeam.h"
#import "GameTypeBot.h"
#import "PlayerController.h"

typedef enum
{
    GameType_TeamDeathmatch,
    GameType_Infiltration,
    GameType_Resistance
} GameTypes;


@interface GameType : NSObject {
    NSString* world;
    uint level;
    NSMutableArray* bots;
    NSTimeInterval completionTime;
    NSTimeInterval targetTime;
}

-(GameTeam*) GetWinningTeam:(NSArray*)teams;
-(NSMutableArray*) GetBots;
-(void) GameStart;
-(void) GameEnd;
-(void) Tick:(NSTimeInterval)dt;
-(NSString*) GetScoreCategory;
-(void) LoadLevel;
-(uint) GetScoreForPlayer:(PlayerController*)player team:(GameTeam*)team1 enemyTeam:(GameTeam*)team2;
-(void) SetLevel:(uint)l ForWorld:(NSString*)w;
-(NSTimeInterval) getTargetTime;
-(GameTypes) getGameType;

@property(assign) uint NumBots;
@property(assign) bool Respawn;
@end
