//
//  PowerupManager.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupManager.h"


@implementation PowerupManager

-(id) initWithWorld:(GameWorld *)w
{
    self = [super init];
    powerups = [[NSMutableArray alloc] init];
    world = w;
    timeSinceLastStep = 0;
    stepInterval = 0.05;
    return self;
}

-(void) addPowerupFactory:(PowerupFactory *)powerup
{
    [powerup retain];
    [powerups addObject:powerup];
    [world spawnPowerup:powerup];
    //spawn
}

-(void) dealloc
{
    for(uint i = 0; i < [powerups count]; i++)
    {
        PowerupFactory* p = [powerups objectAtIndex:i];
        [p release];
    }
    [powerups removeAllObjects];
    [super dealloc];
}

-(void) processPowerups:(ccTime)dt
{
    timeSinceLastStep += dt;
    if(timeSinceLastStep > stepInterval)
    {        
        for(uint i = 0; i < [powerups count]; i++)
        {
            PowerupFactory* powerup = [powerups objectAtIndex:i];
            switch (powerup.state) {
                case Equiping:
                case Active:
                    [powerup step:timeSinceLastStep];
                    break;
                case Activating:
                    [world spawnPowerup:powerup];
                    powerup.state = Active;
                    break;
                case Deactivating:
                    [world removeChild:powerup.sprite cleanup:false];
                    [world destroyPhysicsBody:powerup.physicsBody];
                    powerup.state = Deactive;
                    break;
                case Deactive:
                    [powerup step:timeSinceLastStep];
                    break;            
            }
        }
        timeSinceLastStep = 0;
    }
}
@end
