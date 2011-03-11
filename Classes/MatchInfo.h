//
//  MatchInfo.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchInfo : NSObject <NSCoding> {
	NSNumber* team1Score;
	NSNumber* team2Score;
	NSMutableArray* playerIDs;
	NSMutableArray* playerKills;
	NSMutableArray* playerDeaths;
	NSMutableArray* pawnHealths;
}

-(void) addPawnHealth:(int)health withKills:(int)kills withDeaths:(int)deaths withPlayerID:(NSString*)playerID ;
@property(assign) NSNumber* team1Score;
@property(assign) NSNumber* team2Score;
@property(assign) NSMutableArray* pawnHealths;
@property(assign) NSMutableArray* playerKills;
@property(assign) NSMutableArray* playerDeaths;
@property(assign) NSMutableArray* playerIDs;
@end
