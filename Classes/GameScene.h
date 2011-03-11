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

typedef enum
{
	Game_Single,
	Game_Local,
	Game_Online
} GameMode;

@interface GameScene : CCLayer <GameKitHelperProtocol,GKSessionDelegate, OnlinePlayUIProtocol,LocalPlayUIProtocol,UILayerProtocol> {
	GameWorld* gameWorld;
	UILayer* uiLayer;
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
	uint clientInitCount;
	uint clientSyncCount;
	float lastBroadcast;
	float broadcastInterval;
	int hostNumBots;
	NSDate* sendPacketTime;
	bool gameActive;
	GameType* gameType;
}

+(id) sceneWithGameMode:(GameMode)mode;
+(GameMode) CurrentGameMode;
+(bool) isServer;
+(bool) isInPlayerView:(CGPoint)pawnPos;
+(ViewPort) getViewPort;
-(id) initWithGameMode:(GameMode)mode;
-(void) initializeUI;
-(void) initializePlayer;
-(void) initializePlayerWithPawnType:(NSString*)pType onTeam:(GameTeam*)team withName:(NSString*)name;
-(void) initializeBots:(int)numBots;
-(void) updateViewport;
-(void) loadSprites;
-(NSMutableArray*) generateTeamLeaderboard;
-(void) initializeTeams;
-(void) startSinglePlay;
-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context;
-(void) startGameScheduler;
-(void) dispatchNetworkPlayerInput:(NetworkPlayerInput*)netInput;
//-(void) dispatchNetworkPlayerInputs:(NSMutableArray*)netInputs;
-(void) processNetworkPlayerInput:(NetworkPlayerInput*)netInput;
-(void) playBackgroundMusic;
-(void) stopBackgroundMusic;
-(void) onQuitGame;


@end