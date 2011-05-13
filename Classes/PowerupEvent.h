//
//  PowerupEvent.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 13/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PowerupEventType
{
    Equip = 0,
    Activate = 1
} PowerupEventType;

@interface PowerupEvent : NSObject<NSCoding> {
    PowerupEventType eventType;
    int powerupId;
    NSString* playerId;
}

@property(assign) PowerupEventType eventType;
@property(assign) int powerupId;
@property(assign) NSString* playerId;

@end
