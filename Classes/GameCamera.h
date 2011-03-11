//
//  GameCamera.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GamePawn.h"

@interface GameCamera : NSObject {
	GamePawn* target;
	CGSize viewportSize;
	CGSize worldSize;
	CGPoint position;
}

-(id) initToViewportSize:(CGSize)vpSize WorldSize:(CGSize)wSize Position:(CGPoint)pos;
-(void) updatePosition;
-(CGPoint) position;

@property(assign) CGPoint position;
@property(assign) GamePawn* target;
@end
