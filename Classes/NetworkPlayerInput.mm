//
//  NetworkPlayerInput.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "NetworkPlayerInput.h"


@implementation NetworkPlayerInput
//@synthesize hasMove,hasShoot,hasJump,moveVector,shootPoint,position,velocity,playerID,hasSyncPosition,health;
@synthesize hasJump,moveVector,shootPointX,shootPointY,positionX,positionY,velocityX,velocityY,health,playerID;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:hasJump];
	[aCoder encodeObject:moveVector];
	[aCoder encodeObject:positionX];
	[aCoder encodeObject:positionY];
	[aCoder encodeObject:velocityX];
	[aCoder encodeObject:velocityY];
	[aCoder encodeObject:shootPointX];
	[aCoder encodeObject:shootPointY];
	[aCoder encodeObject:health];
	[aCoder encodeObject:playerID];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    doRelease = true;
	hasJump = [[aDecoder decodeObject] retain];
	moveVector = [[aDecoder decodeObject] retain];
	positionX = [[aDecoder decodeObject] retain];
	positionY = [[aDecoder decodeObject] retain];
	velocityX = [[aDecoder decodeObject] retain];
	velocityY = [[aDecoder decodeObject] retain];
	shootPointX = [[aDecoder decodeObject] retain];
	shootPointY = [[aDecoder decodeObject] retain];
	health = [[aDecoder decodeObject] retain];
	playerID = [[aDecoder decodeObject] retain];
	return self;
}

-(void) dealloc
{
    if(doRelease)
    {
        [hasJump release];
        [moveVector release];
        [positionX release];
        [positionY release];
        [velocityX release];
        [velocityY release];
        [shootPointX release];
        [shootPointY release];
        [health release];
        [playerID release];
    }
    [super dealloc];
}

@end
