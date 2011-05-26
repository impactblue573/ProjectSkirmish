//
//  MainLayer.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "UILayer.h"
#import "GameWorld.h"
#import "PlayerController.h"
#import "BotController.h"
#import "PlayerInput.h"
#import "GameController.h"
#import "NetworkGameController.h"
#import "TapTarget.h"
#import "GameKitHelper.h"
#import "OnlinePlayUI.h"
#import "LocalPlayUI.h"
#import "TitleScene.h"
#import <GameKit/GameKit.h>
#import "TeamDeathmatch.h"
#import "Leaderboard.h"
#import "CharacterPicker.h"
#import "WorldPicker.h"

typedef enum
{
	Game_Single,
	Game_Local,
	Game_Online
} GameMode;

@interface GameScene : CCLayer <GameKitHelperProtocol,GKSessionDelegate, OnlinePlayUIProtocol,LocalPlayUIProtocol,UILayerProtocol> {
	GameWorld* gameWorld;
	UILayer* uiLayer;
    ProjectSkirmishAppDelegate* appDelegate;
	PlayerController* playerController;
	NSMutableArray* botControllers;
	NSMutableDictionary* networkPlayerControllers;
	CGSize screenSize;
	GameTeam* team1;
	GameTeam* team2;
	NSMutableArray* playerList;
	OnlinePlayUI* onlinePlayUI;
	LocalPlayUI* localPlayUI;
	NSString* serverPeerID;
	NSString* worldName;
	uint clientInitCount;
	uint clientSyncCount;
	float lastBroadcast;
	float broadcastInterval;
	float pingInterval;
	float timeSinceLastPing;
	NSTimeInterval latestPing;
	float latestPingID;
	NSDate* pingSentTime;
	int hostNumBots;
	NSDate* sendPacketTime;
	bool gameActive;
	GameType* gameType;
	CharacterPicker* singlePlayCharacterPicker;
	WorldPicker* singlePlayWorldPicker;
    TapTarget* tapTarget;
    SneakyJoystickSkinnedBase* joystickBase;
}


+(id) sceneWithGameMode:(GameMode)mode;
+(GameScene*) current;
+(GameMode) CurrentGameMode;
+(bool) isServer;
+(bool) isInPlayerView:(CGPoint)pawnPos;
+(ViewPort) getViewPort;
+(float) getDifficultyFactor;
+(void) ReturnToTitle;
-(GameTeam*) getPlayerTeam;
-(id) initWithGameMode:(GameMode)mode;
-(NSString*) getPlayerId;
-(void) initializeUI;
-(void) initializePlayer:(NSString*)pType;
-(void) initializePlayerWithPawnType:(NSString*)pType onTeam:(GameTeam*)team withName:(NSString*)name;
-(void) initializePlayerWithPawnType:(NSString*)pType onTeam:(GameTeam*)team withName:(NSString*)name usingVariation:(int)variation;
-(void) initializeBots:(int)numBots;
-(void) updateViewport;
-(void) loadSprites;
-(NSMutableArray*) generateTeamLeaderboard;
-(void) initializeTeams;
-(void) startSinglePlay:(NSString*)pType;
-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context;
-(void) startGameScheduler;
-(void) dispatchNetworkPlayerInput:(NetworkPlayerInput*)netInput;// packetID:(int)packetID;
//-(void) dispatchNetworkPlayerInputs:(NSMutableArray*)netInputs;
-(void) processNetworkPlayerInput:(NetworkPlayerInput*)netInput packetID:(int)packetID;
-(void) processPowerupEvent:(PowerupEvent*)powerupEvent;

-(void) playBackgroundMusic;
-(void) stopBackgroundMusic;
-(void) onQuitGame;

-(void) onCharacterSelect:(SlideListItem)item;
-(void) onWorldSelect:(SlideListItem)item;

@property(readonly) UILayer* uiLayer;

@end
