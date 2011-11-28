//
//  GameKitHelper.m
//
//  Created by Steffen Itterheim on 05.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "GameKitHelper.h"

@implementation GameKitHelper

static GameKitHelper *instanceOfGameKitHelper;

#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfGameKitHelper == nil, @"Attempted to allocate a second instance of the singleton: GameKitHelper");
		instanceOfGameKitHelper = [[super alloc] retain];
		return instanceOfGameKitHelper;
	}
	
	// to avoid compiler warning
	return nil;
}

+(GameKitHelper*) sharedGameKitHelper
{
	@synchronized(self)
	{
		if (instanceOfGameKitHelper == nil)
		{
			[[GameKitHelper alloc] init];
		}
		
		return instanceOfGameKitHelper;
	}
	
	// to avoid compiler warning
	return nil;
}

#pragma mark Init & Dealloc

@synthesize isGameCenterAvailable, lastError, categoryScores;

-(id) init
{
	if ((self = [super init]))
	{
		// Test for Game Center availability
		Class gameKitLocalPlayerClass = NSClassFromString(@"GKLocalPlayer");
		bool isLocalPlayerAvailable = (gameKitLocalPlayerClass != nil);
		
		// Test if device is running iOS 4.1 or higher
		NSString* reqSysVer = @"4.1";
		NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
		bool isOSVer41 = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
		
		isGameCenterAvailable = (isLocalPlayerAvailable && isOSVer41);
		NSLog(@"GameCenter available = %@", isGameCenterAvailable ? @"YES" : @"NO");
        categoryScores = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);	
	[instanceOfGameKitHelper release];
	instanceOfGameKitHelper = nil;	
    [categoryScores release];
	[lastError release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}

#pragma mark setLastError

-(void) setLastError:(NSError*)error
{
	[lastError release];
	lastError = [error copy];
	
	if (lastError)
	{
		NSLog(@"GameKitHelper ERROR: %@", [[lastError userInfo] description]);
	}
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer
{
	if (isGameCenterAvailable == NO)
		return;

	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	if (localPlayer.authenticated == NO)
	{
		// Authenticate player, using a block object. See Apple's Block Programming guide for more info about Block Objects:
		// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Blocks/Articles/00_Introduction.html
		[localPlayer authenticateWithCompletionHandler:^(NSError* error)
		{
			[self setLastError:error];
			
			if (error == nil)
			{
                [self reloadHighScores];
			}
		}];
	}
    else
    {
        [self reloadHighScores];
    }
}

#pragma mark Scores and Leaderboard

-(void) reloadHighScores{
    [self reloadHighScoresForCategory:@"PaintPawsTeamDeathmatch"];
    [self reloadHighScoresForCategory:@"PaintPawsInfiltration"];
    [self reloadHighScoresForCategory:@"PaintPawsResistance"];
    [self reloadHighScoresForCategory:@"PaintPawsKills"];	
    [self reloadHighScoresForCategory:@"PaintPawsProwess"];
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
//	GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] initWithPlayerIDs:[NSArray arrayWithObjects:[GKLocalPlayer localPlayer].playerID,nil]] autorelease];
    GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
    leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
    {
        if(error != nil)
        {
            NSLog(@"Error Loading Scores: %@", error.localizedDescription);
        }
        else if(scores != nil)
        {
            NSLog(@"%@ Score Received: %lld", category,leaderBoard.localPlayerScore.value);

            [categoryScores setObject:leaderBoard.localPlayerScore forKey:category];            
        }
    }];
}

-(int64_t) getPlayerScoreForCategory:(NSString*)category{
    GKScore* score = [categoryScores objectForKey:category];
    if(score != nil)
    {
        return score.value;
    }
    return 0;
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category 
{
    NSLog(@"Reporting %lld score for %@",score,category);
    //update local
    GKScore* currentScore = [categoryScores objectForKey:category];
    if(currentScore != nil)
    {        
        if(score > currentScore.value)
        {
            currentScore.value = score;
        }
        else
        {
            NSLog(@"Leaderboard score higher than local score...dont report");
            return;
        }
    }
    

	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
	 {         
         if(error != nil)
         {
             NSLog(@"Error Loading Scores: %@", error.localizedDescription);
         }
         else
         {
             NSLog(@"%@ Score Reported", category);
         }
	 }];
}

#pragma mark Friends & Player Info

-(void) getLocalPlayerFriends
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	if (localPlayer.authenticated)
	{
		// First, get the list of friends (player IDs)
		[localPlayer loadFriendsWithCompletionHandler:^(NSArray* friends, NSError* error)
		{
			[self setLastError:error];
		}];
	}
}

-(void) getPlayerInfo:(NSArray*)playerList
{
	if (isGameCenterAvailable == NO)
		return;

	// Get detailed information about a list of players
	if ([playerList count] > 0)
	{
		[GKPlayer loadPlayersForIdentifiers:playerList withCompletionHandler:^(NSArray* players, NSError* error)
		{
			[self setLastError:error];
		}];
	}
}

#pragma mark Views (Leaderboard, Achievements)

// Helper methods

-(UIViewController*) getRootViewController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void) presentViewController:(UIViewController*)vc
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentModalViewController:vc animated:YES];
}

-(void) dismissModalViewController
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC dismissModalViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [self dismissModalViewController];
}

- (void) showLeaderboard
{
    UIViewController* rootVC = [self getRootViewController];
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [rootVC presentModalViewController: leaderboardController animated: YES];
    }
}

//p2p
-(void) hostServer:(NSString *)displayName delegate:(id<GKSessionDelegate>)del
{
	[self terminateSession];
	currentSession = [[GKSession alloc] initWithSessionID:@"BT" displayName:displayName sessionMode:GKSessionModeServer];
	currentSession.delegate = del;
	currentSession.available = YES;
	[currentSession setDataReceiveHandler:del withContext:nil];
}

-(void) startClient:(NSString*)displayName delegate:(id<GKSessionDelegate>)del
{	
	[self terminateSession];
	currentSession = [[GKSession alloc] initWithSessionID:@"BT" displayName:displayName sessionMode:GKSessionModeClient];
	currentSession.delegate = del;
	currentSession.available = YES;
	[currentSession setDataReceiveHandler:del withContext:nil];
}

-(void) isAvailable:(bool)available
{
    if(currentSession)
    {
        currentSession.available = available;
    }
}

-(void) clearDelegate
{
    if(currentSession)
    {
        currentSession.delegate = nil;
        currentSession.available = false;
        [currentSession setDelegate:nil];
    }
}

-(void) terminateSession
{
	if(currentSession != nil)
	{
		currentSession.available = NO;
		[currentSession disconnectFromAllPeers];
		[currentSession release];
        currentSession = nil;
	}
}

-(void) sendDataToAllPeers:(NSData*)data withMode:(GKSendDataMode)mode
{		
	NSError* error = nil;
	[currentSession sendDataToAllPeers:data withDataMode:mode error:&error];
	[self setLastError:error];
}

-(void) sendData:(NSData*)data toPeer:(NSString*)peerID withMode:(GKSendDataMode)mode
{		
	NSError* error = nil;
	[currentSession sendData:data toPeers:[NSArray arrayWithObject:peerID] withDataMode:mode error:&error];
	[self setLastError:error];
}

-(NSString*) getPeerID
{
	return [currentSession peerID];
}

@end
