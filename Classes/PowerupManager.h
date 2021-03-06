//
//  PowerupManager.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameWorld.h"
#import "PowerupFactory.h"


@interface PowerupManager : NSObject {
    GameWorld* world;
    NSMutableArray* powerups;
    float timeSinceLastStep;
    float stepInterval;
}
+(PowerupManager*) current;
-(id) initWithWorld:(GameWorld*)w;
-(void) addPowerupFactory:(PowerupFactory*)powerup;
-(void) processPowerups:(ccTime)dt;
-(PowerupFactory*) getPowerupById:(int)powerupId;
-(Powerup*) equipPowerup:(PowerupFactory*)powerup toPawn:(GamePawn*)pawn;
-(void) powerupContact:(PowerupFactory*)powerup withPawn:(GamePawn*)pawn;
@end
