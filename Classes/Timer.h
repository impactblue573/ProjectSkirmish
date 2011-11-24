//
//  Timer.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
    TimerType_StopWatch,
    TimerType_Countdown
} TimerTypes;

@interface Timer : CCLayer
{
    TimerTypes timerType;
    NSTimeInterval timeLimit;
    CCLabelTTF* timeLabel;
    NSTimeInterval currentTime;
    bool started;
}

-(id)initWithMode:(TimerTypes)type limit:(NSTimeInterval)limit;
-(void) start;
-(void) stop;
-(void) tick:(NSTimeInterval)dt;
-(void) setTimerType:(TimerTypes)type;
-(void) setLimit:(NSTimeInterval)limit;
@end
