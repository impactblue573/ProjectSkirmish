//
//  Timer.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Timer.h"

@implementation Timer

-(id) initWithMode:(TimerTypes)type limit:(NSTimeInterval)limit{
    self = [super init];
    timerType = type;
    timeLimit = limit;
    timeLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(100,30) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:28];
    timeLabel.anchorPoint = ccp(0.5,0.5);
    timeLabel.position = ccp(0,-17);
    
    CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"TimerBackground.png"];
    background.anchorPoint = ccp(0.5,1);
    background.position = ccp(0,0);
    [self addChild:timeLabel z:1];
    [self addChild:background z:0];
    return self;
}

-(void) tick:(NSTimeInterval)dt{
    if(started){
        if(timerType == TimerType_Countdown)
        {
            currentTime =  MAX(0,currentTime - dt);
//            [timeLabel setColor: ccc3(2 * timeLimit * clampf((timeLimit - currentTime)/(timeLimit/2),0,1), 4 * timeLimit * fmin(timeLimit/2,currentTime) / timeLimit, 0)];
        }
        else
        {
            currentTime += dt;
        }
        GLbyte red = 255 * MIN(2 * currentTime,timeLimit)/timeLimit;
        GLbyte green = 255 * clampf((timeLimit - currentTime)/(timeLimit/2),0,1);
        [timeLabel setColor: ccc3(red,green,0)];
        [timeLabel setString:[NSString stringWithFormat:@"%d",(uint)currentTime]];
    }
}

-(void) start{
    currentTime = timerType == TimerType_Countdown ? timeLimit : 0;
    [timeLabel setString:[NSString stringWithFormat:@"%d",currentTime]];
    [timeLabel setColor:ccc3(0,255,0)];
    started = true;
}

-(void) stop{
    started = false;
}

-(void) setLimit:(NSTimeInterval)limit{
    timeLimit = limit;
}

-(void) setTimerType:(TimerTypes)type{
    timerType = type;
}
@end
