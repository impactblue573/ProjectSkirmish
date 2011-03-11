//
//  PlayerInput.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerInput.h"

@implementation PlayerInput

-(id) initWithJoystick:(SneakyJoystickSkinnedBase*)joystick withTapTarget:(TapTarget*)tTarget
{
	//[[[self alloc] init] autorelease];
	leftJoystickUI = joystick;
	leftJoystick = [leftJoystickUI.joystick retain];	
	tapTarget = tTarget;
	return self;
}

-(CGPoint) moveVector
{
	return leftJoystick.velocity;
}

-(bool) targetTapped
{
	return [tapTarget isActive];
}

-(CGPoint) tapPosition
{
	return [tapTarget tapPosition];
}
@end
