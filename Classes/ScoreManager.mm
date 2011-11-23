//
//  ScoreManager.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreManager.h"

static ScoreManager* sharedScoreManager;

@implementation ScoreManager

+(id) sharedScoreManager{
    if(sharedScoreManager == nil)
        sharedScoreManager = [[ScoreManager alloc] init];
    return sharedScoreManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        infiltrationScores = [[NSMutableDictionary alloc] init];
        resistanceScores = [[NSMutableDictionary alloc] init];
        // Initialization code here.
    }
    
    return self;
}

-(void) LoadScores{
//    NSDictionary* savedData = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Infiltration.plist",world]]];
    NSData* codedData = [[[NSData alloc] initWithContentsOfFile:@"UserData.plist"] autorelease];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    NSDictionary* userData = [unarchiver decodeObjectForKey:@"UserData"];  
    
    if([userData objectForKey:@"InfiltrationScores"] != nil)
    {
        if(infiltrationScores != nil)
            [infiltrationScores release];
        infiltrationScores = [[userData objectForKey:@"InfiltrationScores"] retain];
    }
    if([userData objectForKey:@"ResistanceScores"] != nil)
    {
        if(resistanceScores != nil)
            [resistanceScores release];
        resistanceScores = [[userData objectForKey:@"ResistanceScores"] retain];
    }
    teamDeathmatchScore = [[userData objectForKey:@"TeamDeathmatchScore"] longLongValue];
    totalKills = [[userData objectForKey:@"TotalKills"] intValue];
    totalDeaths = [[userData objectForKey:@"TotalDeaths"] intValue];
    [unarchiver release];
}

-(void) SaveScores{
    NSMutableDictionary* userData = [NSMutableDictionary dictionary];
    [userData setObject:infiltrationScores forKey:@"InfiltrationScores"];
    [userData setObject:resistanceScores forKey:@"ResistanceScores"];
    [userData setObject:[NSNumber numberWithLongLong:teamDeathmatchScore] forKey:@"TeamDeathmatchScore"];
    [userData setObject:[NSNumber numberWithInt:totalKills] forKey:@"TotalKills"];
    [userData setObject:[NSNumber numberWithInt:totalDeaths] forKey:@"TotalDeaths"];
    
    NSMutableData* codedData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:codedData];          
    [archiver encodeObject:userData forKey:@"UserData"];
    [archiver finishEncoding];
    [codedData writeToFile:@"UserData.plist" atomically:YES];
    [codedData release];
    [archiver release];
}

-(NSMutableArray*) GetInfiltrationScores:(NSString *)world{
    NSMutableArray* scores = [infiltrationScores objectForKey:world];
    if(scores != nil)
        return scores;
    return nil;
}

-(void) SetInfiltrationScore:(uint)score ForLevel:(uint)level InWorld:(NSString *)world{
    NSMutableArray* scores = [infiltrationScores objectForKey:world];
    if(scores == nil)
        scores = [NSMutableArray array];
    if([scores count] < level)
    {
        for(uint i = 1; i < level - [scores count]; i++)
        {
            [scores addObject:[NSNumber numberWithFloat:0]];
        }
        [scores addObject:[NSNumber numberWithFloat:score]];
    }
    else
    {
        uint oldScore = [[scores objectAtIndex:(level-1)] intValue];
        if(score > oldScore)
            [scores replaceObjectAtIndex:(level-1) withObject:[NSNumber numberWithFloat:score]];
        else
            return;
    }
    [infiltrationScores setObject:scores forKey:world];
    [self SaveScores];
}

-(uint64_t) GetTotalInfiltrationScore
{
    uint64_t total = 0;
    NSArray* worlds = [NSArray arrayWithObjects:@"Farm_World",@"CreepyWoods_World", nil];
    for(uint w = 0; w < [worlds count]; w++)
    {
        NSMutableArray* scores = [infiltrationScores objectForKey:[worlds objectAtIndex:w]];
        if(scores != nil)
        {
            for(uint i = 0; i < [scores count];i++)
                total += [[scores objectAtIndex:i] intValue];
        }
    }
    return total;
}

-(uint64_t) GetTeamDeathmatchScore {
    return teamDeathmatchScore;
}

-(void) AddKills:(uint)kills{
    totalKills += kills;
}

-(void) AddDeaths:(uint)deaths{
    totalDeaths += deaths;
}

-(void) AddTDMScore:(uint)score{
    teamDeathmatchScore += score;
}

- (void)dealloc
{
    [super dealloc];
    if(infiltrationScores != nil)
        [infiltrationScores release];
    if(resistanceScores != nil)
        [resistanceScores release];
}

@end
