//
//  PawnInfo.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "PawnInfo.h"


@implementation PawnInfo

@synthesize playerID, pawnType, teamID, playerName;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.playerID];
	[aCoder encodeObject:self.pawnType];
	[aCoder encodeObject:self.teamID];
	[aCoder encodeObject:self.playerName];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.playerID = [[aDecoder decodeObject] retain];
	self.pawnType = [[aDecoder decodeObject] retain];
	self.teamID = [[aDecoder decodeObject] retain];
	self.playerName = [[aDecoder decodeObject] retain];
	return self;
}
@end
