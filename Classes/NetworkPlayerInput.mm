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
//	[aCoder encodeBool:hasMove forKey:@"hasMove"];
//	[aCoder encodeBool:hasShoot forKey:@"hasShoot"];
//	[aCoder encodeBool:hasJump forKey:@"hasJump"];
//	[aCoder encodeBool:hasSyncPosition forKey:@"hasSyncPosition"];
//	[aCoder encodeCGPoint:moveVector forKey:@"moveVector"];
//	[aCoder encodeCGPoint:shootPoint forKey:@"shootPoint"];
//	[aCoder encodeCGPoint:position forKey:@"position"];
//	[aCoder encodeCGPoint:velocity forKey:@"velocity"];
//	[aCoder encodeFloat:health forKey:@"health"];
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
	//hasMove = [aDecoder decodeBoolForKey:@"hasMove"];
//	hasShoot = [aDecoder decodeBoolForKey:@"hasShoot"];
//	hasJump = [aDecoder decodeBoolForKey:@"hasJump"];
//	hasSyncPosition = [aDecoder decodeBoolForKey:@"hasSyncPosition"];
//	moveVector = [aDecoder decodeCGPointForKey:@"moveVector"];
//	shootPoint = [aDecoder decodeCGPointForKey:@"shootPoint"];
//	position = [aDecoder decodeCGPointForKey:@"position"];
//	velocity = [aDecoder decodeCGPointForKey:@"velocity"];	
//	health = [aDecoder decodeFloatForKey:@"health"];
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

@end
