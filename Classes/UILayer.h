//
//  UILayer.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GLES-Render.h"
#import "SneakyJoystick.h"
#import "Leaderboard.h"
#import "Healthbar.h"

@protocol UILayerProtocol

-(void) onQuitGame;
-(NSMutableArray*) getLeaderboardEntries;

@end

@interface UILayer : CCLayer {
	CGSize screenSize;
	id<UILayerProtocol> delegate;
	CCLabelTTF* team1ScoreLabel;
	CCLabelTTF* team2ScoreLabel;
	CCLabelTTF* healthLabel;
	CCLabelTTF* ammoLabel;
	CCLabelTTF* pingLabel;
	CCLabelTTF* messageLabel;
	CCMenuItemImage* resumeMenuItem;
	CCMenu* pauseMenu;
	CCMenu* gameMenu;
	CCLayerColor* gameMenuParent;
	Leaderboard* leaderboard;
    Healthbar* healthbar;
	bool pauseMenuVisible;
}

-(void) updateTeam1Score:(int)t1Score team2Score:(int)t2Score;
-(void) updateHealth:(float)health;
-(void) updatePing:(float)ping;
-(void) clearMessage;
-(void) showMessage:(NSString*) message forInterval:(float)interval;
-(void) showMessage:(NSString*) message forInterval:(float)interval withColor:(ccColor3B)color;
-(void) showPauseMenu:(id)sender;
-(void) hidePauseMenu:(id)sender;
-(void) quitGame:(id)sender;
-(void) showCompletitionScreen;
-(void) hideResume;
-(void) hidePauseMenuItem;

@property(assign) id<UILayerProtocol> delegate;
@end
