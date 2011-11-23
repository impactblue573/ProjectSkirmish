//
//  GameKitHelper.h
//
//  Created by Steffen Itterheim on 05.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface GameKitHelper : NSObject
{
	bool isGameCenterAvailable;
	NSError* lastError;	
	GKSession* currentSession;
}

@property (nonatomic, readonly) bool isGameCenterAvailable;
@property (nonatomic, readonly) NSError* lastError;
@property(assign) NSMutableDictionary* categoryScores;


/** returns the singleton object, like this: [GameKitHelper sharedGameKitHelper] */
+(GameKitHelper*) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;
-(int64_t) getPlayerScoreForCategory:(NSString*)category;
-(void) getPlayerInfo:(NSArray*)players;

// Leaderboards
- (void) reloadHighScoresForCategory: (NSString*) category;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;

//p2p
-(void) hostServer:(NSString*)displayName delegate:(id<GKSessionDelegate>)del;
-(void) startClient:(NSString*)displayName delegate:(id<GKSessionDelegate>)del;
-(void) terminateSession;
-(void) sendDataToAllPeers:(NSData*)data withMode:(GKSendDataMode)mode;
-(void) sendData:(NSData*)data toPeer:(NSString*)peerID withMode:(GKSendDataMode)mode;
-(NSString*) getPeerID;
-(void) isAvailable:(bool)available;
-(void) clearDelegate;
@end
