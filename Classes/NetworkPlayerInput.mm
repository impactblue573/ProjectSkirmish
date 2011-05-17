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
    doRelease = true;
	self.hasJump = [[aDecoder decodeObject] retain];
	self.moveVector = [[aDecoder decodeObject] retain];
	self.positionX = [[aDecoder decodeObject] retain];
	self.positionY = [[aDecoder decodeObject] retain];
	self.velocityX = [[aDecoder decodeObject] retain];
	self.velocityY = [[aDecoder decodeObject] retain];
	self.shootPointX = [[aDecoder decodeObject] retain];
	self.shootPointY = [[aDecoder decodeObject] retain];
	self.health = [[aDecoder decodeObject] retain];
	self.playerID = [[aDecoder decodeObject] retain];
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
