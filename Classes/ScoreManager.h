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
    NSString* filepath;
}

+(id) sharedScoreManager;
-(void) LoadScores;
-(void) SaveScores;
-(bool) SetInfiltrationScore:(uint)score ForLevel:(uint)level InWorld:(NSString*)world;
-(NSMutableArray*) GetInfiltrationScores:(NSString*)world;
-(uint64_t) GetTotalInfiltrationScore;
-(bool) SetResistanceScore:(uint)score ForLevel:(uint)level InWorld:(NSString*)world;
-(NSMutableArray*) GetResistanceScores:(NSString*)world;
-(uint64_t) GetTotalResistanceScore;
-(uint64_t) GetTeamDeathmatchScore;
-(void) AddKills:(uint)kills;
-(void) AddDeaths:(uint)deaths;
-(void) AddTDMScore:(uint)score;
-(float) GetKDR;
-(uint) GetKills;
@end