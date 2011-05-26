//
//  Targetter.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum TargetterState
{
    Targetter_Deactive = 0,
    Targetter_Activating = 1,
    Targetter_Active = 2
} TargetterState;

@interface Targetter : CCNode {
    CCSprite* sprite;
    CCLayer* parent;
    TargetterState state;
    float opacityDirection;
    float opacityVelocity;
    float opacityPulseVelocity;
    float scaleVelocity;
    float transitionDuration;
    float maxOpacity;
    float minOpacity;
    float maxScale;
    float minScale;
    float animateInterval;
    float newOpacity;
    bool enabled;
}

-(id) initWithSprite:(NSString*)spriteName inLayer:(CCLayer*)layer;
-(void) setPosition:(CGPoint)pos;
-(void) activate;
-(void) deactivate;
-(void) animate:(ccTime)dt;
@end
