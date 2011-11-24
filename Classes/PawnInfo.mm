//
//  PawnInfo.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "PawnInfo.h"


@implementation PawnInfo

@synthesize playerID, pawnType, teamID, playerName, spriteVariation;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.playerID];
	[aCoder encodeObject:self.pawnType];
    [aCoder encodeObject:self.spriteVariation];
	[aCoder encodeObject:self.teamID];
	[aCoder encodeObject:self.playerName];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    releaseProperties = true;
	self.playerID = [aDecoder decodeObject];
	self.pawnType = [aDecoder decodeObject];
    self.spriteVariation = [aDecoder decodeObject];
	self.teamID = [aDecoder decodeObject];
	self.playerName = [aDecoder decodeObject];
	return self;
}

-(void) dealloc
{
//    if(releaseProperties)
//    {
//        [playerID release];
//        [pawnType release];
//        [spriteVariation release];
//        [teamID release];
//        [playerName release];
//    }
    [super dealloc];
}
@end
