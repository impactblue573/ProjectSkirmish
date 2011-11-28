//
//  MainLayer.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "DataHelper.h"
#import "PowerupFactory.h"
#import "SoundManager.h"
#import "ScoreManager.h"

static GameScene* currentGameScene = nil;
static GameMode gameMode;
static bool isServer;
static bool doPing = false;
static float difficultyFactor;
static GameWorld* CurrentGameWorld;

@implementation GameScene
@synthesize  uiLayer;

+(id) sceneWithGameMode:(GameMode)gameMode gameType:(GameTypes)type
{
	//srandom([[NSDate date] timeIntervalSince1970]);
	// 'scene' is an autorelease object.
	CCScene* scene = [CCScene node];

	currentGameScene = [[GameScene alloc] initWithGameMode:gameMode gameType:type];
	[scene addChild:currentGameScene];
	// return the scene
	return scene;
}

+(GameScene*) current
{
    return currentGameScene;
}

-(GameTeam*) getPlayerTeam
{
    if(playerController != nil)
    {
        return playerController.team;
    }
    return nil;
}

-(NSString*) getPlayerId
{
    if(playerController != nil)
    {
        return playerController.playerID;
    }
    return nil;
}

+(float) getDifficultyFactor
{
	return difficultyFactor;
}

+(GameMode) CurrentGameMode
{
	return gameMode;
}

+(bool) isInPlayerView:(CGPoint)pawnPos
{
	CGSize s = [CCDirector sharedDirector].winSize;
	CGPoint p = ccp(-CurrentGameWorld.position.x,-CurrentGameWorld.position.y);
	return pawnPos.x >= p.x && pawnPos.x <= (p.x + s.width) && pawnPos.y >= p.y && pawnPos.y <= (p.y + s.height);
}

+(ViewPort) getViewPort
{
	ViewPort vp;
	vp.dimensions = [CCDirector sharedDirector].winSize;
	vp.position = ccp(-CurrentGameWorld.position.x,-CurrentGameWorld.position.y);
	return vp;
}

+(bool) isServer
{
	return isServer;
}

-(id) initWithGameMode:(GameMode)gMode gameType:(GameTypes)type
{
	if((self = ([super init])))
	{		
        appDelegate = [UIApplication sharedApplication].delegate;
		difficultyFactor = 0.6f;
		gameMode = gMode;
		broadcastInterval = 0;
		pingInterval = 5;
		screenSize = [CCDirector sharedDirector].winSize;
		playerList = [[NSMutableArray alloc] init];
        currentGameType = type;
        if(type == GameType_TeamDeathmatch)
            gameType = [[TeamDeathmatch alloc] initWithWinScore:30 numBots:7];
        else if(type == GameType_Infiltration)
            gameType = [[Infiltration alloc] init];
        else if (type == GameType_Resistance)
            gameType = [[Resistance alloc] init];
        
        CCMenuItemImage* quitMenuItem = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"QuitSmall.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"QuitSmallActive.png"] target:self selector:@selector(ReturnToTitle)];
        quitMenuItem.anchorPoint = ccp(1,0);
        quitMenuItem.selectedImage.position = ccp(-6,-2);
        quitMenu = [CCMenu menuWithItems:quitMenuItem, nil];
        quitMenu.anchorPoint = ccp(1,0);
        quitMenu.position = ccp(screenSize.width-4,4);
        [self addChild:quitMenu z:10];
        [quitMenu setVisible:false];
        
        //No longer supported
		if(gameMode == Game_Online)
		{
//			onlinePlayUI = [OnlinePlayUI node];
//			onlinePlayUI.delegate = self;
//			GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
//			gkHelper.delegate = self; 
//			[gkHelper authenticateLocalPlayer];
		}
		else if(gameMode == Game_Local)
		{
			localPlayUI = [LocalPlayUI node];
			[localPlayUI showMainMenu];
			localPlayUI.delegate = self; 
			[self addChild:localPlayUI];
		}
		else
		{
			singlePlayWorldPicker = [[WorldPicker alloc] init];
			[singlePlayWorldPicker setTarget:self selector:@selector(onWorldSelect:)];
			[self addChild:singlePlayWorldPicker z:5];
            [quitMenu setVisible:true];
		}
	}
	return self;
}

-(void) loadSprites
{
	//[AnimationHelper cacheSpriteSheet:@"Lambo-Sprite"];
}

-(void) initializeTeams
{
	team1 = [[GameTeam alloc] init];
	team1.teamIndex = 2;
	team1.paintballSprite = @"Paintball_Red.png";
	team1.spawnPoint = [gameWorld getTeamASpawnPoint];
	team1.teamColor = (ccColor3B){255,0,0};
	
	team2 = [[GameTeam alloc] init];
	team2.teamIndex = 4;
	team2.paintballSprite = @"Paintball_Blue.png";
	team2.spawnPoint = [gameWorld getTeamBSpawnPoint];
	team2.teamColor = (ccColor3B){0,0,255};
}

-(void) initializePlayer:(NSString*)pType
{
	[self initializePlayerWithPawnType:pType onTeam:team1 withName:appDelegate.playerName];
}

-(void) initializePlayerWithPawnType:(NSString*)pType onTeam:(GameTeam*)team withName:(NSString*)name
{
	NSString* playerID = @"LocalPlayer";
	if(gameMode == Game_Online)
	{
		GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
		
		if(localPlayer.authenticated)
			playerID = localPlayer.playerID;
	}
	else if(gameMode == Game_Local)
	{
		playerID = [[GameKitHelper sharedGameKitHelper] getPeerID];
	}
	//initialize controls
	tapTarget = [[TapTarget alloc] initWithMinTouchDuration:0.02f];
	
	joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
	SneakyJoystick* joystick = [[[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,80,80)] autorelease];
    joystickBase.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(50,50,50,128) radius:60];
    joystickBase.position = ccp(team == team1 ? 80 : screenSize.width-80,36);
	joystickBase.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(team == team1 ? 180:0, 0, team == team1 ? 0:180, 64) radius:40];
	joystickBase.joystick = joystick;
	
	//add controls to UI
	[uiLayer addChild:tapTarget];
	[uiLayer addChild:joystickBase];
	
	//initialize player input
	PlayerInput* playerInput = [[[PlayerInput alloc] initWithJoystick:joystickBase withTapTarget:tapTarget] autorelease];
	
	//initialize camera
	GameCamera* camera = [[[GameCamera alloc] initToViewportSize:screenSize WorldSize:gameWorld.worldSize Position:CGPointMake(0.0f,0.0f)] autorelease];
	
	//initialize player controller
	playerController = [[PlayerController alloc] initInWorld:gameWorld usingPawn:pType asTeam:team withPlayerID:playerID withPlayerName:name usingVariation:-1];
	playerController.respawn = gameType.Respawn;
    [playerController setCamera:camera];
	[playerController setPlayerInput:playerInput];
	[gameWorld spawnGamePawn:playerController.pawn];
}

-(void) initializeNetworkPlayers:(NSMutableArray*)pawnInfo 
{
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	NSString* peerID = [gkHelper getPeerID];
	if(networkPlayerControllers == nil)
		networkPlayerControllers = [[NSMutableDictionary dictionary] retain];
	for(NSUInteger i = 0; i < [pawnInfo count];i++)
	{
		PawnInfo* info = [pawnInfo objectAtIndex:i];
		if(![info.playerID isEqualToString:peerID])
		{
			NetworkGameController* controller = [[[NetworkGameController alloc] initInWorld:gameWorld usingPawn:info.pawnType asTeam:([info.teamID intValue] == 2 ? team1:team2) withPlayerID:info.playerID withPlayerName:info.playerName usingVariation:[info.spriteVariation intValue]] autorelease];
			controller.respawn = gameType.Respawn;
            [networkPlayerControllers setObject:controller forKey:info.playerID];
            if(controller.team != playerController.team)
            {
                [controller setTargetted:true];
            }
			[gameWorld spawnGamePawn:controller.pawn];
		}
	}
}

-(void) showLeaderboard:(ccTime)delta
{
	[self unschedule:@selector(showLeaderboard:)];
    [uiLayer showMessageBox:[NSString stringWithFormat:@"Score: %d",score] fontSize:40 color:ccc3(255, 50, 50)];
	[uiLayer showMessage:@"" forInterval:0];
	NSArray* array = [[self generateTeamLeaderboard] retain];
	Leaderboard* leaderboard = [[[Leaderboard alloc] initWithLeaderboardEntries:array] autorelease];
	leaderboard.position = ccp(40,40);
	[uiLayer showCompletitionScreen];
    [array release];
}

-(NSMutableArray*) generateTeamLeaderboard
{
	NSMutableArray* list = [NSMutableArray array];
	LeaderboardEntry entry = [playerController getLeaderboardEntry];
	NSValue* value = [NSValue valueWithBytes:&entry objCType:@encode(struct LeaderboardEntry)];
	[list addObject:value];
	if(networkPlayerControllers != nil)
	{
		NSArray* keys = [networkPlayerControllers allKeys];
		for(uint i = 0; i < [keys count]; i++)
		{
			GameController* controller = (GameController*)[networkPlayerControllers objectForKey:[keys objectAtIndex:i]];
			//if(controller.team == playerController.team)
			//{
				entry = [controller getLeaderboardEntry];
				value = [NSValue valueWithBytes:&entry objCType:@encode(struct LeaderboardEntry)];
				[list addObject:value];
			//}
		}
	}
	
	if(botControllers != nil)
	{
		for(uint i = 0; i < [botControllers count]; i++)
		{
			GameController* controller = (GameController*)[botControllers objectAtIndex:i];
			//if(controller.team == playerController.team)
			//{
				entry = [controller getLeaderboardEntry];
				value = [NSValue valueWithBytes:&entry objCType:@encode(struct LeaderboardEntry)];
				[list addObject:value];
			//}
		}
	}
	return list;
}

-(NSMutableArray*) getPawnInfos
{
	NSMutableArray* pawnInfos = [NSMutableArray array];
	PawnInfo* info = [playerController.pawn getPawnInfo];
	[pawnInfos addObject:info];
	NSArray* keys = [networkPlayerControllers allKeys];
	for(NSUInteger i = 0; i < [keys count]; i++)
	{
		GameController* ctrl = [networkPlayerControllers objectForKey:[keys objectAtIndex:i]];
		PawnInfo* pInfo = [ctrl.pawn getPawnInfo];
		[pawnInfos addObject:pInfo];
	}
	for(NSUInteger i = 0; i < [botControllers count]; i++)
	{
		GameController* ctrl = [botControllers objectAtIndex:i];
		PawnInfo* pInfo = [ctrl.pawn getPawnInfo];
		[pawnInfos addObject:pInfo];
	}
	return pawnInfos;
}

-(void) initializeBots
{
	botControllers = [[NSMutableArray array] retain];
    NSMutableArray* gameBots = [gameType GetBots];
	for(uint i = 0; i < [gameBots count]; i++)
	{
        GameTypeBot* botDef = [gameBots objectAtIndex:i];
        [botDef retain];
		NSString* botName = [NSString stringWithFormat:@"%d",i];
		GameTeam* team;
        if(botDef.team == 0)
            team = team1.teamCount > team2.teamCount ? team2 : team1;
        else if(botDef.team == 1)
            team = team1;
        else
            team = team2;
		BotController* botController1 = [[[BotController alloc] initInWorld:gameWorld usingPawn:botDef.pawnType asTeam:team withPlayerID:botName withPlayerName:botName] autorelease];
        botController1.respawn = gameType.Respawn;
        botController1.pawn.startPosition = ccp(botDef.x,botDef.y);
        if(botDef.ai)
        {
            [botController1 setAiTypeWithString:botDef.ai];
            [botController1 updateBotName];
        }
        [gameWorld spawnGamePawn:botController1.pawn];
        [botController1.pawn applyHandicap:botDef.handicap];
		[botControllers addObject:botController1];
        if(botController1.team != playerController.team)
        {
            [botController1 setTargetted:true];
        }
        [botDef release];

	}
}

-(void) tick: (ccTime) dt
{
	if(!gameActive)
		return;
	bool sendMatchInfo = false;
    MatchInfo* matchInfo = [[MatchInfo alloc] init];
	DataPacket* matchDataPacket = [[DataPacket alloc] init];
	matchDataPacket.dataType = Data_MatchUpdate;
	matchDataPacket.matchInfo = matchInfo;
	
	NSMutableArray* playerInputs = [[NSMutableArray	alloc] init];
	
	NetworkPlayerInput* netInput;
	[gameWorld updateWorld:dt];
	netInput = [[playerController processInput:dt] retain];
	//if(gameMode != Game_Single && netInput.hasJump || netInput.hasMove || netInput.hasShoot || netInput.hasSyncPosition)
	//	[playerInputs addObject:netInput];
	[playerController processCamera:dt];
	[playerController updatePawn:dt];
	//if(lastBroadcast > broadcastInterval)
	[self dispatchNetworkPlayerInput:netInput];
	[netInput release];
	if((playerController.pawn.healthUpdated || playerController.updated) && isServer)
	{
		sendMatchInfo = true;
		[matchDataPacket.matchInfo addPawnHealth:playerController.pawn.health withKills:playerController.kills withDeaths:playerController.deaths withPlayerID:playerController.playerID];
		playerController.pawn.healthUpdated = false;
		playerController.updated = false;
	}
	
	NSArray* keys = [networkPlayerControllers allKeys];
	for(NSUInteger i = 0; i < [keys count]; i++)
	{
		NetworkGameController* netController = [networkPlayerControllers objectForKey:[keys objectAtIndex:i]];
		[netController updatePawn:dt];
		if((netController.pawn.healthUpdated || netController.updated) && isServer)
		{
			sendMatchInfo = true;
			[matchDataPacket.matchInfo addPawnHealth:netController.pawn.health withKills:netController.kills withDeaths:netController.deaths withPlayerID:netController.playerID];
			netController.pawn.healthUpdated = false;
			netController.updated = false;
		}
	}
	
	BattleInfo* battleInfo = [[gameWorld getBattleInfo] retain];
	for(NSUInteger i = 0; i < [botControllers count]; i++)
	{
		BotController* botController = [botControllers objectAtIndex:i];
		netInput = [botController processBattleInfo:battleInfo delta:dt];
        [netInput retain];
        [botController updatePawn:dt];
		//if(isServer && lastBroadcast > broadcastInterval && netInput.hasJump || netInput.hasMove || netInput.hasShoot || netInput.hasSyncPosition)
		//	[playerInputs addObject:netInput];
		//if(lastBroadcast > broadcastInterval)
		[self dispatchNetworkPlayerInput:netInput];
		[netInput release];
		if((botController.pawn.healthUpdated || botController.updated) && isServer)
		{
			sendMatchInfo = true;
			[matchDataPacket.matchInfo addPawnHealth:botController.pawn.health withKills:botController.kills withDeaths:botController.deaths withPlayerID:botController.playerID];
			botController.pawn.healthUpdated = false;
			botController.updated = false;
		}
	}	
	[battleInfo release];
	
	//Update UI
	[uiLayer updateTeam1Score:team1.teamKills team2Score:team2.teamKills];
	[uiLayer updateHealth:playerController.pawn.health];	
	matchDataPacket.matchInfo.team1Score = [NSNumber numberWithInt:team1.teamKills];
	matchDataPacket.matchInfo.team2Score = [NSNumber numberWithInt:team2.teamKills];
	if(isServer && (team1.updated || team2.updated))
	{
		sendMatchInfo = true;
		team1.updated = false;
		team2.updated = false;
	}
	
	//Dispatch Match Info if Necessary
	if(isServer && sendMatchInfo)
	{
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPeers:[DataHelper serializeDataPacket:matchDataPacket] withMode:GKSendDataUnreliable];
	}
    
	//Dispatch PLayer Info if necessary
	//if([playerInputs count] > 0)
	//	[self dispatchNetworkPlayerInputs:playerInputs];
	[matchDataPacket release];
	[playerInputs release];
    [matchInfo release];
	
	//Update Camera
	[self updateViewport];
	
	//Reset broadcast interval
//	if(lastBroadcast > broadcastInterval)
//		lastBroadcast = 0;
//	else
//		lastBroadcast += dt;
	
	//Ping if necessary
	if(doPing && !isServer && gameMode != Game_Single && timeSinceLastPing > pingInterval)
	{
		timeSinceLastPing = 0;
		DataPacket* pingPacket = [[DataPacket alloc] init];
		pingPacket.dataType = Data_Ping;
		pingPacket.pingID = random() % 1000;
		latestPingID = pingPacket.pingID;
		[[GameKitHelper sharedGameKitHelper] sendData:[DataHelper serializeDataPacket:pingPacket] toPeer:serverPeerID withMode:GKSendDataUnreliable];
		[pingSentTime release];
        pingSentTime = [[NSDate date] retain];
        [pingPacket release];
	}
	else 
	{
		timeSinceLastPing += dt;
	}

	
	//Check Game Completion
	GameTeam* winningTeam = [gameType GetWinningTeam:[NSArray arrayWithObjects:team1,team2,nil]];
    [gameType Tick:dt];
    [uiLayer updateTimer:dt];
	if(winningTeam != nil)
	{
        gameActive =	false;
        [gameType GameEnd];
        score = [gameType GetScoreForPlayer:playerController team:playerController.team enemyTeam:(playerController.team == team1 ? team2: team1)];
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        
        if(gkHelper.isGameCenterAvailable)
        {
            if(currentGameType == GameType_Infiltration)
            {
                uint64_t infScore = [[ScoreManager sharedScoreManager] GetTotalInfiltrationScore];
                [gkHelper reportScore:infScore forCategory:[gameType GetScoreCategory]];
                if(level < 10)
                    [uiLayer showNext:true];
            }
            else if(currentGameType == GameType_Resistance)
            {
                uint64_t infScore = [[ScoreManager sharedScoreManager] GetTotalResistanceScore];
                [gkHelper reportScore:infScore forCategory:[gameType GetScoreCategory]];
                if(level < 10)
                    [uiLayer showNext:true];
            }
            else if(currentGameType == GameType_TeamDeathmatch)
            {
                [gkHelper reportScore:[[ScoreManager sharedScoreManager] GetTeamDeathmatchScore] forCategory:[gameType GetScoreCategory]];
                [gkHelper reportScore:[[ScoreManager sharedScoreManager] GetKills] forCategory:@"PaintPawsKills"];
                [gkHelper reportScore:[[ScoreManager sharedScoreManager] GetKDR] forCategory:@"PaintPawsProwess"];
            }
        }
        
        [uiLayer showWin:playerController.team == winningTeam];
		[self schedule:@selector(showLeaderboard:) interval:3];
		return;
	}	
}

//-(void) dispatchNetworkPlayerInputs:(NSMutableArray*)netInputs;
//{
//	DataPacket* packet = [[DataPacket alloc] init];
//	packet.dataType = Data_PawnUpdate;
//	packet.playerInputs = netInputs;
//	if(gameMode == Game_Local)
//	{
//		if(isServer)
//			[[GameKitHelper sharedGameKitHelper] sendDataToAllPeers:[DataHelper serializeDataPacket:packet]];
//		else
//			[[GameKitHelper sharedGameKitHelper] sendData:[DataHelper serializeDataPacket:packet] toPeer:serverPeerID];
//	}
//	[packet release];
//}

-(void) dispatchNetworkPlayerInput:(NetworkPlayerInput*)netInput// packetID:(int)packetID;
{
	if(netInput.hasJump || netInput.moveVector || netInput.shootPointX || netInput.positionX)
	{
		DataPacket* packet = [[DataPacket alloc] init];
		packet.dataType = Data_PawnUpdate;
		packet.playerInput = netInput;
		//packet.packetID = packetID;
		if(gameMode == Game_Local)
		{
			if(isServer)
				[[GameKitHelper sharedGameKitHelper] sendDataToAllPeers:[DataHelper serializeDataPacket:packet] withMode:GKSendDataUnreliable];
			else
				[[GameKitHelper sharedGameKitHelper] sendData:[DataHelper serializeDataPacket:packet] toPeer:serverPeerID withMode:GKSendDataUnreliable];
		}
		[packet release];
		//if(!isServer)
//		{
//			//if(sendPacketTime == nil)
//			//	[sendPacketTime	 release];
//			sendPacketTime = [[NSDate date] retain];
//		}
	}
}

-(void) processPowerupEvent:(PowerupEvent *)powerupEvent
{
    PowerupFactory* powerup = [gameWorld.powerupManager getPowerupById:powerupEvent.powerupId];
    if(powerupEvent.eventType == Equip)
    {
        GameController* player = nil;
        if([playerController.playerID isEqualToString:powerupEvent.playerId])
            player = playerController;
        else
            player = [networkPlayerControllers objectForKey:powerupEvent.playerId];
        if(player != nil)
        {
            [[PowerupManager current] equipPowerup:powerup toPawn:player.pawn];
            //[player.pawn equipPowerup:[powerup getPowerup]];
        }
    }
    else if(powerupEvent.eventType == Activate)
    {
        [powerup reset];
    }
}

-(void) processNetworkPlayerInput:(NetworkPlayerInput *)netInput packetID:(int)packetID
{
//    NSDate* start = [NSDate date];
	NSString* peerID = [[GameKitHelper sharedGameKitHelper] getPeerID];
	if([netInput.playerID isEqualToString:peerID])
	{
		/*if(sendPacketTime != nil)
		{
			float ping = 1000 * [[NSDate date] timeIntervalSinceDate:sendPacketTime];
			[uiLayer updatePing:ping];
			[sendPacketTime release];
			sendPacketTime = nil;
		}*/
		[playerController processNetworkInput:netInput packetID:packetID];
	}
	else
	{
		NetworkGameController* controller = [networkPlayerControllers objectForKey:netInput.playerID];
		if(controller != nil)
		{
			//if server duplicate the health on the server then dispatch it back to all of the clients
			if(isServer)
			{
				[self dispatchNetworkPlayerInput:netInput];
			}
			[controller processNetworkInput:netInput packetID:packetID];				
		}
	}	
    
//    NSLog(@"Network Input Process time: %.2fms", [start timeIntervalSinceNow] * -1000);
}

-(void) updateViewport
{
	gameWorld.position = playerController.camera.position;
}

//initialize game
-(void) initializeGame
{
    gameStarted = true;
    [[GameKitHelper sharedGameKitHelper] isAvailable:false];
    loadingScreen = [[[LoadingScreen alloc] init] autorelease];
    [loadingScreen setProgress:0];
    [self addChild:loadingScreen z:10];
	[self initializeUI];
	[self initializeTeams];
	[self initializePlayerWithPawnType:[localPlayUI getSelectedCharacter] onTeam:([localPlayUI getSelectedTeam] == 1 ? team1 : team2) withName:[localPlayUI getPlayerName]];
	[self removeChild:localPlayUI cleanup:true];
}

-(void) endGame:(ccTime)delta
{
	[self unschedule:@selector(endGame:)];
//	[self stopBackgroundMusic];
    if([gameType getGameType] == GameType_TeamDeathmatch)
    {
        [[GameKitHelper sharedGameKitHelper] clearDelegate];
        [GameScene ReturnToTitle];
    }
    else
    {
        [self terminateGame];
        SlideListItem item;
        item.key = worldName;
        item.image = worldImage;
        [self onWorldSelect:item];
    }
}

+(void) ReturnToTitle
{
    [currentGameScene release];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]];
}

-(void) ReturnToTitle
{
    [GameScene ReturnToTitle];
}

-(void) delayedStart
{
    [loadingScreen setProgress:75];
    [self schedule:@selector(preloadSounds) interval:1];
}

-(void) delayedStartDone
{
    [self unschedule:@selector(delayedStartDone)];
    [self removeChild:loadingScreen cleanup:true];
    [self startGameScheduler];
}

-(void) startGameScheduler
{
    [gameType GameStart];
	[self schedule: @selector(tick:)];
}

-(void) initializeUI
{
	gameActive = true;
	gameWorld = [[[GameWorld alloc] initWorld:worldName] autorelease];	
	CurrentGameWorld = gameWorld;
	[self addChild: gameWorld];
	uiLayer = [UILayer node];
	[self addChild:uiLayer];
	uiLayer.delegate = self;
    
    [uiLayer showRetry:false];
    [uiLayer showNext:false];
    
    //setup gametype ui
    if([gameType getGameType] == GameType_Infiltration){
        [uiLayer showScores:false];
        [uiLayer showTimer:true];
        [uiLayer setTimer:TimerType_StopWatch limit:[gameType getTargetTime]];
        [uiLayer showMessageBox:[gameType getObjective] fontSize:20 color:ccc3(0, 0, 0)];
        [uiLayer showRetry:true];

    }
    else if([gameType getGameType] == GameType_Resistance){
        [uiLayer showScores:false];
        [uiLayer showTimer:true];
        [uiLayer setTimer:TimerType_Countdown limit:[gameType getTargetTime]];
        [uiLayer showMessageBox:[gameType getObjective] fontSize:20 color:ccc3(0, 0, 0)];
        [uiLayer showRetry:true];

    }
    else if([gameType getGameType] == GameType_TeamDeathmatch){        
        [uiLayer showScores:true];
        [uiLayer showTimer:false];
    }
}

//Single Player
-(void) startSinglePlay
{
    [self unschedule:@selector(startSinglePlay)];
	[self initializeUI];
	[self initializeTeams];
	[self initializePlayer:singlePlayPawnType];
	[self initializeBots];
    [self delayedStart];
    
}

-(void) preloadSounds
{
    [self unschedule:@selector(preloadSounds)];
//    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Its Over Now.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"TakeHit.aif"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Splat.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Fire.mp3"];
    [self playBackgroundMusic];
    [self schedule:@selector(preloadSoundsDone) interval:1];
}

-(void) preloadSoundsDone{
    [self unschedule:@selector(preloadSoundsDone)];
    [loadingScreen setProgress:100];
    [self schedule:@selector(delayedStartDone) interval:1];
}

-(void) playBackgroundMusic
{
    [self unschedule:@selector(playBackgroundMusic)];
    [[SoundManager sharedManager] playBackgroundMusic:@"Its Over Now.mp3"];
}

-(void) stopBackgroundMusic
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

#pragma mark UILayer Delegate methods
-(void) onQuitGame
{
	[self endGame:0];
}

-(void) onRetry
{
    [self terminateGame];
	[self onLevelSelect:level];
}

-(void) onNextLevel
{
    [self terminateGame];
    [self onLevelSelect:level+1];

}

-(NSMutableArray*) getLeaderboardEntries
{
	return [self generateTeamLeaderboard];
}

//GameKit stuff

#pragma mark Online Play & Local Play UI Protocol
-(void) hostGame
{	
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	
//	if(gameMode == Game_Online)
//	{
//		GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
//		request.minPlayers = 2; 
//		request.maxPlayers = 4;		 
//		[gkHelper showMatchmakerWithRequest:request];
//	}
//	else 
    if(gameMode == Game_Local)
	{
		isServer = true;
		[gkHelper hostServer:appDelegate.playerName delegate:self];
		[localPlayUI showPendingMenu:@"Waiting for players to join..."];
		[localPlayUI setPlayersJoined:0];
		[localPlayUI setStartMenuVisible:false];
		[localPlayUI showBots:true];
		[localPlayUI showWorld:true];
        [localPlayUI showBackground:1];

	}
}

-(void) joinGame
{
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
//	if(gameMode == Game_Online)
//	{
//		GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
//		request.minPlayers = 2; 
//		request.maxPlayers = 4;
//		
//		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
//		[gkHelper findMatchForRequest:request];
//		[onlinePlayUI showJoiningMenu];
//	}
//	else 
    if(gameMode == Game_Local)
	{
		isServer = false;
		[gkHelper startClient:appDelegate.playerName delegate:self];
		[localPlayUI showPendingMenu:@"Searching for servers..."];
		[localPlayUI setPlayersJoinedVisible:false];
		[localPlayUI setStartMenuVisible:false];
		[localPlayUI showBots:false];
		[localPlayUI showWorld:false];
        [localPlayUI showBackground:1];
	}
}

-(void) quitGame
{
    gameStarted = false;
	[[CCDirector sharedDirector] replaceScene:[TitleScene scene]];
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper terminateSession];
}

//-(void) cancelJoinGame
//{		
//	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
//	[gkHelper cancelMatchmakingRequest];
//	[onlinePlayUI showMainMenu];
//}

-(void) cancelGame
{
	[playerList removeAllObjects];
	[localPlayUI showMainMenu];
}

-(void) startGame
{	
	hostNumBots = [localPlayUI getNumBots];
    gameType.NumBots = hostNumBots;
	worldName = [NSString stringWithString:[localPlayUI getSelectedWorld]];
	[self initializeGame];
    [loadingScreen setProgress:25];
	DataPacket* packet = [[DataPacket alloc] init];
	packet.dataType = Data_InitPawnRequest;
	packet.playerInput = [[NetworkPlayerInput alloc] init];
	packet.worldName = worldName;
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper sendDataToAllPeers:[DataHelper serializeDataPacket:packet] withMode:GKSendDataReliable];
    [packet.playerInput release];
    [packet release];
} 

/* Session Protocol */
/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if(!gameStarted)
    {
        if(isServer)
        {
            if(state == GKPeerStateConnected)
            {
                [playerList addObject:peerID];			
                [localPlayUI setPendingText:@"Waiting for players to join..."];
                [localPlayUI setPlayersJoined:[playerList count]];
                [localPlayUI setStartMenuVisible:true];
            }
            if(state == GKPeerStateDisconnected)
            {
                [playerList removeObject:peerID];
                [localPlayUI setPlayersJoined:[playerList count]];
                if([playerList count] == 0)
                    [localPlayUI setStartMenuVisible:false];
            }
        }
        else 
        {
            if(state == GKPeerStateAvailable)
            {
                [session connectToPeer:peerID withTimeout:10];			
                [localPlayUI setPendingText:[NSString stringWithFormat:@"Connecting to %@",[session displayNameForPeer:peerID]]];
            }
            else if(state == GKPeerStateConnected)
            {
                [localPlayUI setPendingText:@"Connected...ready to start."];
            }
        }
    }
}

/* Indicates a connection request was received from another peer. 
 
 Accept by calling -acceptConnectionFromPeer:
 Deny by calling -denyConnectionFromPeer:
 */
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
    if(!gameStarted)
    {
        [session acceptConnectionFromPeer:peerID error:nil];        
        [localPlayUI setPendingText:[NSString stringWithFormat:@"Connecting %@",[session displayNameForPeer:peerID]]];
    }
}

/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    if(!gameStarted)
        [localPlayUI setPendingText:@"Connection failed!"];
}

/* Indicates an error occurred with the session such as failing to make available.
 */
- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	DataPacket* packet = [[DataHelper deserializeDataPacket:data] retain];
	DataPacket* response = [[[DataPacket alloc] init] autorelease];
	//request from server for the client to initialize
	if(packet.dataType == Data_InitPawnRequest)
	{
		[localPlayUI clearTextFields];
		worldName = [NSString stringWithString:packet.worldName];
		[self initializeGame];	
        [loadingScreen setProgress:30];
		serverPeerID = peer;
		response.dataType = Data_InitPawnResponse;
		PawnInfo* pawnInfo = [[playerController.pawn getPawnInfo] retain];
		response.pawnInitData = [NSMutableArray arrayWithObject:pawnInfo];
		[gkHelper sendData:[DataHelper serializeDataPacket:response] toPeer:serverPeerID withMode:GKSendDataReliable];
        [pawnInfo release];
	}
	
	//init pawn response from client
	if(packet.dataType == Data_InitPawnResponse)
	{
		clientInitCount++;
		[self initializeNetworkPlayers:packet.pawnInitData];
        [loadingScreen setProgress:25 + 25 * (clientInitCount/[playerList count])];
		//ok all initialized...lets synchronize on the clients
		if(clientInitCount == [playerList count])
		{
			[self initializeBots];
			response.dataType = Data_SynchPawnRequest;
			NSMutableArray* pawnInfos = [[self getPawnInfos] retain];
            response.pawnInitData = pawnInfos;
			[gkHelper sendDataToAllPeers:[DataHelper serializeDataPacket:response] withMode:GKSendDataReliable];
//            for(uint i = 0; i < [pawnInfos count]; i++)
//            {
//                [[pawnInfos objectAtIndex:i] release];
//            }
            [pawnInfos release];
		}
	}
	
	//request from server to synchronize network controllers
	if(packet.dataType == Data_SynchPawnRequest)
	{
        [loadingScreen setProgress:60];
		[self initializeNetworkPlayers:packet.pawnInitData];
		response.dataType = Data_SynchPawnResponse;
		[gkHelper sendData:[DataHelper serializeDataPacket:response] toPeer:serverPeerID withMode:GKSendDataReliable];
	}
	
	//synch pawn response from client
	if(packet.dataType == Data_SynchPawnResponse)
	{
		clientSyncCount++;
        [loadingScreen setProgress:50 + 25 * (clientSyncCount/[networkPlayerControllers count])];
		if(clientSyncCount == [networkPlayerControllers count])
		{
			response.dataType = Data_StartGame;
			[gkHelper sendDataToAllPeers:[DataHelper serializeDataPacket:response] withMode:GKSendDataReliable];
			[self delayedStart];
		}
	}
	
	//Start game request from server
	if(packet.dataType == Data_StartGame)
	{
		CCLOG(@"RECEIVED STARTGAME");
		[self delayedStart];
	}
	
	//Pawn Update
	if(packet.dataType == Data_PawnUpdate)
	{
		if(packet.playerInput != nil)
			[self processNetworkPlayerInput:packet.playerInput packetID:0];
		//for(uint i = 0; i < [packet.playerInputs count];i++)
		//[self processNetworkPlayerInput:[packet.playerInputs objectAtIndex:i]];
	}
	
	//Match Update
	if(packet.dataType == Data_MatchUpdate)
	{	
		GameController* controller;
		for(uint i = 0; i < [packet.matchInfo.pawnHealths count]; i++)
		{
			NSNumber* health = [packet.matchInfo.pawnHealths objectAtIndex:i];
			NSNumber* kills = [packet.matchInfo.playerKills objectAtIndex:i];
			NSNumber* deaths = [packet.matchInfo.playerDeaths objectAtIndex:i];
			NSString* playerID = [packet.matchInfo.playerIDs objectAtIndex:i];
			if([playerController.playerID isEqualToString:playerID])
			{
				playerController.pawn.health = [health intValue];
				playerController.kills = [kills intValue];
				playerController.deaths = [deaths intValue];
				continue;
			}
			controller = [networkPlayerControllers objectForKey:playerID];
			if(controller != nil)
			{
				controller.pawn.health = [health intValue];
				controller.kills = controller.kills < [kills intValue] ? [kills intValue] : controller.kills;
				controller.deaths = controller.deaths < [deaths intValue] ? [deaths intValue] : controller.deaths;
				continue;
			}
			for(uint b = 0; b < [botControllers count]; b++)
			{
				controller = [botControllers objectAtIndex:b];
				if([controller.playerID isEqualToString:playerID])
				{
					controller.pawn.health = [health intValue];
					controller.kills = controller.kills < [kills intValue] ? [kills intValue] : controller.kills;
					controller.deaths = controller.deaths < [deaths intValue] ? [deaths intValue] : controller.deaths;
					break;
				}
			}
			
		}
		team1.teamKills = [packet.matchInfo.team1Score intValue];
		team2.teamKills = [packet.matchInfo.team2Score intValue];
	}
	
	if(packet.dataType == Data_Ping)
	{
		packet.dataType = Data_PingResponse;
		[[GameKitHelper sharedGameKitHelper] sendData:[DataHelper serializeDataPacket:packet] toPeer:peer withMode:GKSendDataUnreliable];
	}
	
	if(packet.dataType == Data_PingResponse)
	{
		if(latestPingID == packet.pingID && pingSentTime != nil)
		{
			latestPing = [[NSDate date] timeIntervalSinceDate:pingSentTime];
			[uiLayer updatePing:latestPing*1000];

		}
	}
    
    if(packet.dataType == Data_PowerupEvent)
    {
        [self processPowerupEvent:packet.powerupEvent];
    }
	[packet release];
	/*[response release];
	packet = nil;
	response = nil;*/
}


#pragma mark SlideListProtocol
-(void) onCharacterSelect:(SlideListItem)item
{
    [quitMenu setVisible:false];
	[self removeChild:singlePlayCharacterPicker cleanup:false];
    loadingScreen = [[[LoadingScreen alloc] init] autorelease];
    [loadingScreen setProgress:0];
    [self addChild:loadingScreen z:10];
    singlePlayPawnType = [NSString stringWithString:item.key];
	[self schedule:@selector(startSinglePlay) interval:0.3];
}

-(void) onWorldSelect:(SlideListItem)item
{
    [quitMenu setVisible:true];
	worldName = [NSString stringWithString:item.key];
    worldImage = [NSString stringWithString:item.image];
    if(singlePlayWorldPicker != nil)
        [self removeChild:singlePlayWorldPicker cleanup:false];
    
    if(currentGameType == GameType_TeamDeathmatch)
    {
        singlePlayCharacterPicker = [[CharacterPicker alloc] init];
        [singlePlayCharacterPicker setTarget:self selector:@selector(onCharacterSelect:)];
        [self addChild:singlePlayCharacterPicker z:5];
        [self removeChild:quitMenu cleanup:false];
        [self addChild:quitMenu z:10];
    }
    else
    {
        singlePlayLevelPicker = [[LevelPicker alloc] initWithLevels:10 target:self selector:@selector(onLevelSelect:)];
        NSMutableArray* scores = [NSMutableArray array];
        if([gameType getGameType] == GameType_Infiltration)
        {
            scores = [[ScoreManager sharedScoreManager] GetInfiltrationScores:worldName];
        }
        else if([gameType getGameType] == GameType_Resistance)
        {
            scores = [[ScoreManager sharedScoreManager] GetResistanceScores:worldName];
        }
        [singlePlayLevelPicker SetLevelScores:scores];
        [singlePlayLevelPicker SetBackgroundImage:item.image];
        [self addChild:singlePlayLevelPicker z:5];
    }	
}

-(void) onLevelSelect:(uint)lvl{
    [quitMenu setVisible:true];
    level = lvl;
    if(singlePlayLevelPicker != nil)
        [self removeChild:singlePlayLevelPicker cleanup:false];
    [gameType SetLevel:level ForWorld:worldName];
    singlePlayCharacterPicker = [[CharacterPicker alloc] init];
    [singlePlayCharacterPicker setTarget:self selector:@selector(onCharacterSelect:)];
    [self addChild:singlePlayCharacterPicker z:5];
    [self removeChild:quitMenu cleanup:false];
    [self addChild:quitMenu z:10];
}

-(void) terminateGame{
    [self unschedule:@selector(tick:)];
    [self removeChild:gameWorld cleanup:true];
    [self removeChild:uiLayer cleanup:true];
    if(singlePlayLevelPicker)
    {
        [singlePlayLevelPicker release];
        singlePlayLevelPicker = nil;
    }
    if(singlePlayCharacterPicker)
    {
        [singlePlayCharacterPicker release];
        singlePlayCharacterPicker = nil;
    }
    if(singlePlayWorldPicker)
    {
        [singlePlayWorldPicker release];
        singlePlayWorldPicker = nil;
    }
    if(tapTarget)
    {
        [tapTarget release];
        tapTarget = nil;
    }
    if(playerController)
    {
        [playerController release];
        playerController = nil;
    }
    if(networkPlayerControllers)
    {
        [networkPlayerControllers release];
        networkPlayerControllers = nil;
    }
    if(botControllers)
    {
        [botControllers release];
        botControllers = nil;
    }
}

-(void) dealloc
{
//    [uiLayer release];
//    [uiLayer removeChild:joystickBase cleanup:false];
//    [joystickBase release];
    [self terminateGame];
    if(gameType)
        [gameType release];
    if(playerList)
        [playerList release];
    if(onlinePlayUI)
        [onlinePlayUI release];
	if(localPlayUI)
        [localPlayUI release];
	[super dealloc];
}

@end


