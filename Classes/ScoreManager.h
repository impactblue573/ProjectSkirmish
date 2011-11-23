//
//  ScoreManager.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScoreManager : NSObject {
@private
    NSMutableDictionary* infiltrationScores;
    NSMutableDictionary* resistanceScores;
    int64_t teamDeathmatchScore;
    uint totalKills;
    uint totalDeaths;
}

+(id) sharedScoreManager;
-(void) LoadScores;
-(void) SaveScores;
-(void) SetInfiltrationScore:(uint)score ForLevel:(uint)level InWorld:(NSString*)world;
-(NSMutableArray*) GetInfiltrationScores:(NSString*)world;
-(uint64_t) GetTotalInfiltrationScore;
-(uint64_t) GetTeamDeathmatchScore;
-(void) AddKills:(uint)kills;
-(void) AddDeaths:(uint)deaths;
-(void) AddTDMScore:(uint)score;
@end
