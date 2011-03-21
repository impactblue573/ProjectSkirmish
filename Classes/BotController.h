//
//  BotController.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkGameController.h"
#import "BattleInfo.h"
#import "NetworkPlayerInput.h"

typedef enum
{
	AI_Commando,
	AI_Sniper,
	AI_Ninja
} AIType;

@interface BotController : NetworkGameController {
	AIType aiType;
	float timeSinceLastShot;
	float shootInterval;
	int mishotFactor;
}

@property(assign) AIType aiType;
-(NetworkPlayerInput*) processBattleInfo:(BattleInfo*)battleInfo delta:(float)dt;
@end