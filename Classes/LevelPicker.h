//
//  LevelPicker.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface LevelPicker : CCLayer{
    uint levels;
    NSInvocation* invocation;
    CCMenu* menu;
    CCSprite* background;
}

-(id) initWithLevels:(uint)numLevels target:(id)target selector:(SEL)selector;
-(void) SetLevelScores:(NSMutableArray*)scores;
-(void) levelClick:(id)item;
-(void) SetBackgroundImage:(NSString*)name;

@end
