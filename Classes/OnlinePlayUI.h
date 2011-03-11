//
//  OnlinePlayUI.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol OnlinePlayUIProtocol

-(void) hostGame;
-(void) joinGame;
-(void) quitGame;
-(void) cancelJoinGame;

@end

@interface OnlinePlayUI : CCLayer {
	id<OnlinePlayUIProtocol> delegate;
	CCLayer* mainMenu;
	CCLayer* joiningGameMenu;
}

-(void) showJoiningMenu;
-(void) showMainMenu;
@property (nonatomic, retain) id<OnlinePlayUIProtocol> delegate;
@end
