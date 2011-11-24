//
//  PowerupManager.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupManager.h"
#import "GameScene.h"
#import "PowerupEvent.h"
#import "DataPacket.h"
#import "DataHelper.h"
#import "GameKitHelper.h"

@implementation PowerupManager

static PowerupManager* currentPowerupManager;

+(PowerupManager*) current
{
    return currentPowerupManager;
}

-(id) initWithWorld:(GameWorld *)w
{
    self = [super init];
    powerups = [[NSMutableArray alloc] init];
    world = w;
    timeSinceLastStep = 0;
    stepInterval = 0.05;
    currentPowerupManager = self;
    return self;
}

-(void) addPowerupFactory:(PowerupFactory *)powerup
{
//    [powerup retain];
    [powerups addObject:powerup];
    [powerup retain];
    [world spawnPowerup:powerup];
    [powerup release];
    //spawn
}

-(void) dealloc
{
//    for(uint i = 0; i < [powerups count]; i++)
//    {
//        PowerupFactory* p = [powerups objectAtIndex:i];
//        [p release];
//    }
    [powerups release];    
    [super dealloc];
}

-(Powerup*) equipPowerup:(PowerupFactory*)powerup toPawn:(GamePawn*)pawn
{
    Powerup* p = [powerup getPowerup];
    [p retain];
    [pawn equipPowerup:p];
    if([pawn.controller.playerID isEqualToString:[[GameScene current] getPlayerId]])
    {
        [[GameScene current].uiLayer showMessage:[p getEquipMessage] forInterval:2];
    }
    [p release];
    return p;
}

-(void) powerupContact:(PowerupFactory*)powerup withPawn:(GamePawn*)pawn
{
    if(([GameScene CurrentGameMode] == Game_Single || [GameScene isServer]) && powerup.state == Active && ![pawn isDead])
    {
        [self equipPowerup:powerup toPawn:pawn];
        //Notify Powerup Equip
        if([GameScene CurrentGameMode] != Game_Single && [GameScene isServer])
        {
            PowerupEvent* event = [[PowerupEvent alloc] init];
            event.eventType = Equip;
            event.powerupId = powerup.powerupId;
            event.playerId = pawn.controller.playerID;
            DataPacket* data = [[DataPacket alloc] init];
            data.dataType = Data_PowerupEvent;
            data.powerupEvent = event;
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPeers:[DataHelper serializeDataPacket:data] withMode:GKSendDataReliable];
            [event release];
            [data release];
        }
    }

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
                    if([GameScene CurrentGameMode] != Game_Single && [GameScene isServer])
                    {
                        PowerupEvent* event = [[PowerupEvent alloc] init];
                        event.eventType = Activate;
                        event.powerupId = powerup.powerupId;
                        DataPacket* data = [[DataPacket alloc] init];
                        data.dataType = Data_PowerupEvent;
                        data.powerupEvent = event;
                        [[GameKitHelper sharedGameKitHelper] sendDataToAllPeers:[DataHelper serializeDataPacket:data] withMode:GKSendDataReliable];
                        [event release];
                        [data release];
                    }
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

-(PowerupFactory*) getPowerupById:(int)powerupId
{
    for(uint i = 0; i < [powerups count]; i++)
    {
        PowerupFactory* powerup = [powerups objectAtIndex:i];
        if(powerup.powerupId == powerupId)
            return powerup;
    }
    return nil;
}
@end
