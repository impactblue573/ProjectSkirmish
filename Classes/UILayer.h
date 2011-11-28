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
#import "Timer.h"
#import "MessageBox.h"

@protocol UILayerProtocol

-(void) onQuitGame;
-(void) onNextLevel;
-(void) onRetry;
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
    CCMenuItemImage* nextMenuItem;
    CCMenuItemImage* retryMenuItem;
	CCMenu* pauseMenu;
	CCMenu* gameMenu;
    CCSprite* winImage;
    CCSprite* loseImage;
	CCLayerColor* gameMenuParent;
	Leaderboard* leaderboard;
    Healthbar* healthbar;
    Timer* timer;
    MessageBox* messageBox;
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
-(void) nextLevel;
-(void) retry;
-(void) showCompletitionScreen;
-(void) hideResume;
-(void) hidePauseMenuItem;
-(void) showRetry:(bool)show;
-(void) showNext:(bool)show;
-(void) showScores:(bool)show;
-(void) showTimer:(bool)show;
-(void) setTimer:(TimerTypes)type limit:(NSTimeInterval)limit;
-(void) updateTimer:(NSTimeInterval)dt;
-(void) showWin:(bool)won;
-(void) hideWin;
-(void) showMessageBox:(NSString*)text fontSize:(float)fontSize color:(ccColor3B)color;
-(void) hideMessageBox;

@property(assign) id<UILayerProtocol> delegate;
@end
