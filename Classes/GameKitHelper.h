//
//  GameKitHelper.h
//
//  Created by Steffen Itterheim on 05.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>

@protocol GameKitHelperProtocol

-(void) onLocalPlayerAuthenticationChanged;

-(void) onFriendListReceived:(NSArray*)friends;
-(void) onPlayerInfoReceived:(NSArray*)players;

-(void) onMatchFound:(GKMatch*)match;
-(void) onPlayersAddedToMatch:(bool)success;
-(void) onReceivedMatchmakingActivity:(NSInteger)activity;

-(void) onPlayerConnected:(NSString*)playerID;
-(void) onPlayerDisconnected:(NSString*)playerID;
-(void) onStartMatch;
-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID;

-(void) onMatchmakingViewDismissed;
-(void) onMatchmakingViewError;

@end


@interface GameKitHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKPeerPickerControllerDelegate>
{
	id<GameKitHelperProtocol> delegate;
	bool isGameCenterAvailable;
	NSError* lastError;
	
	NSMutableDictionary* achievements;
	NSMutableDictionary* cachedAchievements;
	
	GKMatch* currentMatch;
	GKSession* currentSession;
	bool matchStarted;
	bool peerServerMode;
}

@property (nonatomic, retain) id<GameKitHelperProtocol> delegate;
@property (nonatomic, readonly) bool isGameCenterAvailable;
@property (nonatomic, readonly) NSError* lastError;
@property (nonatomic, readonly) NSMutableDictionary* achievements;
@property (nonatomic, readonly) GKMatch* currentMatch;
@property (nonatomic, readonly) bool matchStarted;

/** returns the singleton object, like this: [GameKitHelper sharedGameKitHelper] */
+(GameKitHelper*) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;
-(void) getLocalPlayerFriends;
-(void) getPlayerInfo:(NSArray*)players;

// Matchmaking
-(void) disconnectCurrentMatch;
-(void) findMatchForRequest:(GKMatchRequest*)request;
-(void) addPlayersToMatch:(GKMatchRequest*)request;
-(void) cancelMatchmakingRequest;
-(void) queryMatchmakingActivity;

// Game Center Views
-(void) showMatchmakerWithInvite:(GKInvite*)invite;
-(void) showMatchmakerWithRequest:(GKMatchRequest*)request;

//p2p
-(void) hostServer:(NSString*)displayName delegate:(id<GKSessionDelegate>)del;
-(void) startClient:(NSString*)displayName delegate:(id<GKSessionDelegate>)del;
-(void) terminateSession;
-(void) sendDataToAllPeers:(NSData*)data withMode:(GKSendDataMode)mode;
-(void) sendData:(NSData*)data toPeer:(NSString*)peerID withMode:(GKSendDataMode)mode;
-(NSString*) getPeerID;
@end
