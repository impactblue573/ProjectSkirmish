//
//  LocalPlayUI.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "cocos2d.h"
#import "DialList.h"

@protocol LocalPlayUIProtocol

-(void) hostGame;
-(void) joinGame;
-(void) quitGame;
-(void) cancelGame;
-(void) startGame;

@end

@interface LocalPlayUI : CCLayer <UITextFieldDelegate> {
	id<LocalPlayUIProtocol> delegate;
	CCLayer* mainMenuLayer;
	CCLayer* pendingGameMenuLayer;
	CCLabelTTF* pendingGameLabel;
	CCLabelTTF* playersJoinedLabel;
	CCMenu* pendingGameMenu;
	CCMenuItem* cancelMenuItem;
	CCMenuItem* startMenuItem;
	CCMenuItemFont* teamAButton;
	CCMenuItemFont* teamBButton;
	UITextField* playerTextField;
	DialList* characterDial;
	DialList* botDial;
	CCLabelTTF* botLabel;
	NSString* selectedCharacter;
	float selectedTeam;
}

-(void) showPendingMenu:(NSString*)text;
-(void) setPendingText:(NSString*)text;
-(void) showMainMenu;
-(void) setPlayersJoinedVisible:(bool)vis;
-(void) setStartMenuVisible:(bool)isVisible;
-(void) setPlayersJoined:(int)num;
-(int) getSelectedTeam;
-(NSString*) getPlayerName;
-(NSString*) getSelectedCharacter;
-(int) getNumBots;
-(void) showBots:(bool)show;
-(void) clearTextFields;
@property (nonatomic, retain) id<LocalPlayUIProtocol> delegate;
@end