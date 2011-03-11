//
//  PlayerInput.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "TapTarget.h"
#import "Input.h"

@interface PlayerInput : Input {
	SneakyJoystick* leftJoystick;
	SneakyJoystickSkinnedBase* leftJoystickUI;
	SneakyButton* jumpButton;
	TapTarget* tapTarget;
}

-(id) initWithJoystick:(SneakyJoystickSkinnedBase *)joystick withTapTarget:(TapTarget*)tTarget;

@end
