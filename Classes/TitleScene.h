//
//  TitleScene.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
#import "CharacterPicker.h"

@interface TitleScene : CCLayer {
    CCMenu* titleMenu;
    CCMenu* gameTypeMenu;
}

+(id) scene;

-(void) singlePlayMenuTouched:(id) sender;
-(void) skirmishTouched:(id) sender;
-(void) infiltrationTouched:(id) sender;
-(void) resistanceTouched:(id) sender;
-(void) backTouched:(id)sender;
-(void) onlinePlayMenuTouched:(id) sender;
-(void) localPlayMenuTouched:(id) sender;
-(void) leaderboardsTouched:(id) sender;
@end
