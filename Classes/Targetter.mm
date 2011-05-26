//
//  Targetter.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Targetter.h"


@implementation Targetter

-(id) initWithSprite:(NSString *)spriteName inLayer:(CCLayer*)layer
{
    self = [super init];
    enabled = true;
    sprite = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
    sprite.opacity = 0;
    sprite.scale = 2;
    [layer addChild:sprite z:1];
    parent = layer;
    transitionDuration = 0.5;
    maxOpacity = 255;
    minOpacity = 50;
    maxScale = 3;
    minScale = 0.1;
    animateInterval = 1/30.0;
    opacityVelocity = maxOpacity / transitionDuration;
    opacityPulseVelocity = 800;
    opacityDirection = -1;
    scaleVelocity = (1-minScale) / transitionDuration;
    return self;
}

-(void) setPosition:(CGPoint)pos
{
    sprite.position = pos;
}

-(void) activate
{
    if(state == Targetter_Deactive)
    {
        state = Targetter_Activating;
        [[CCScheduler sharedScheduler] unscheduleSelector:@selector(animate:) forTarget:self];
        [[CCScheduler sharedScheduler] scheduleSelector:@selector(animate:) forTarget:self interval:animateInterval paused:false];
    }
}

-(void) deactivate
{
    if(state == Targetter_Active || state == Targetter_Activating)
    {
        [[CCScheduler sharedScheduler] unscheduleSelector:@selector(animate:) forTarget:self];
        state = Targetter_Deactive;
        sprite.opacity = maxOpacity;
        [[CCScheduler sharedScheduler] scheduleSelector:@selector(animate:) forTarget:self interval:animateInterval paused:false];
    }
}

-(void) step:(ccTime)dt
{
    
}

-(void) animate:(ccTime)dt
{
    if(!enabled)
        return;
    if(dt == 0)
        dt = animateInterval;
    if(state == Targetter_Activating)
    {
        newOpacity += dt * opacityVelocity; 
        sprite.opacity = MIN(newOpacity, maxOpacity);
        float newScale = sprite.scale - dt * scaleVelocity;
        sprite.scale = MAX(newScale, 1);
        if(sprite.opacity == maxOpacity && sprite.scale == 1)
        {
            //[[CCScheduler sharedScheduler] unscheduleSelector:@selector(animate:) forTarget:self];
            opacityDirection = -1;
            state = Targetter_Active;
        }
    }
    else if(state == Targetter_Active)
    {
        newOpacity += dt * opacityPulseVelocity * opacityDirection;
        if(newOpacity > maxOpacity)
        {
            opacityDirection = -1;
            newOpacity = maxOpacity;
        }
        else if(newOpacity < minOpacity)
        {
            opacityDirection = 1;
            newOpacity = minOpacity;
        }
        sprite.opacity = newOpacity;
    }
    else if(state == Targetter_Deactive)
    {
        newOpacity -= dt * opacityVelocity; 
        sprite.opacity = MAX(newOpacity, 0);
        float newScale = sprite.scale - dt * scaleVelocity;
        sprite.scale = MAX(newScale, minScale);
        if(sprite.opacity == 0 && sprite.scale == minScale)
        {
            [[CCScheduler sharedScheduler] unscheduleSelector:@selector(animate:) forTarget:self];
            
        }
    }
}

-(void) dealloc
{
    enabled = false;
    [[CCScheduler sharedScheduler] unscheduleSelector:@selector(animate:) forTarget:self];
    [sprite release];
    [super dealloc];
}
@end
