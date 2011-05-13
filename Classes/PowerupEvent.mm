//
//  PowerupEvent.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 13/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupEvent.h"


@implementation PowerupEvent

@synthesize eventType, playerId, powerupId;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:(int)eventType]];
    [aCoder encodeObject:[NSNumber numberWithInt:powerupId]];

    if(eventType == Equip)
    {
        [aCoder encodeObject:playerId];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	eventType = (PowerupEventType)[[aDecoder decodeObject] intValue];
    powerupId = [[aDecoder decodeObject] intValue];
    if(eventType == Equip)
        playerId = [[aDecoder decodeObject] retain];
    
	return self;
}
@end
