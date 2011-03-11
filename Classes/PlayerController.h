//
//  PlayerController.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkGameController.h"
#import "PlayerInput.h"
#import "GameCamera.h"
#import "NetworkPlayerInput.h"

@interface PlayerController : NetworkGameController {
	PlayerInput* playerInput;
	GameCamera* camera;
	bool jumpReleased;
}

//-(id) initWithPlayerInput:(PlayerInput*)playerinput usingCamera:(GameCamera*) cam;
-(NetworkPlayerInput*) processInput:(ccTime)dt;
-(void) processCamera:(ccTime)dt;
-(void) setCamera:(GameCamera*)camera;
-(void) setPlayerInput:(PlayerInput*)input;

@property(readonly) GameCamera* camera;
@end
