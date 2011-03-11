//
//  NetworkController.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 5/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameController.h"
#import "NetworkPlayerInput.h"

@interface NetworkGameController : GameController {
	CGPoint syncPos;
	bool doSyncPos;
	float netMoveInterval;
	float timeSinceLastNetMove;
	float netJumpInterval;
	float timeSinceLastNetJump;
}

-(void) processNetworkInput:(NetworkPlayerInput*)input;
@end
