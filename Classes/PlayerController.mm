//
//  PlayerController.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerController.h"
#import "GameScene.h"

@implementation PlayerController

@synthesize camera;

-(id) init
{
	self = [super init];
	netMoveInterval = 0.1f;
	netJumpInterval = 0.2f;
	return self;
}

-(void) setCamera:(GameCamera*)cam
{
	camera = [cam retain];
	camera.target = pawn;
}

-(void) setPlayerInput:(PlayerInput*)input
{
    [input retain];
	playerInput = input;
}

-(void) initializeGamePawn
{
	[super initializeGamePawn];
	camera.target = pawn;
}

-(NetworkPlayerInput*) processInput:(ccTime)dt
{
	timeSinceLastNetJump += dt;
	timeSinceLastNetMove += dt;
	bool smartClient = [GameScene isServer] || [GameScene CurrentGameMode] == Game_Single;
	//Init Network Inpt
	b2Vec2 pos = [pawn position];
	b2Vec2 vel = [pawn velocity];
	NetworkPlayerInput* netInput = [[[NetworkPlayerInput alloc] init] autorelease];
	netInput.playerID = playerID;
	//Do position synch
	if(lastNetworkSync > networkSyncInterval)
	{
		lastNetworkSync = 0;	
		netInput.positionX = [NSNumber numberWithFloat:pos.x];
		netInput.positionY = [NSNumber numberWithFloat:pos.y];
		netInput.velocityX = [NSNumber numberWithFloat:vel.x];
		netInput.velocityY = [NSNumber numberWithFloat:vel.y];
	}
	else
		lastNetworkSync += dt;
	
	//Process movement
	CGPoint inputVec = playerInput.moveVector;
	b2Vec2 pPos = [pawn position];
	b2Vec2 pVelocity = [pawn velocity];
	b2Vec2 moveVec = b2Vec2(0,0);
	b2Vec2 jumpVec = b2Vec2(0,0);

	moveVec.x = fabsf(inputVec.x) < 0.3 ? 0 : fabsf(inputVec.x)/inputVec.x;	

	//Do some optimization here...
	if(timeSinceLastNetMove > netMoveInterval)
	{	
		netInput.moveVector = [NSNumber numberWithFloat:moveVec.x];
		timeSinceLastNetMove = 0;
	}
	if(smartClient)
		[pawn walk:moveVec];

	if(inputVec.y > 0.5)
	{		
		if(smartClient)
			[pawn jump:1.0];
		
		if(timeSinceLastNetJump > netJumpInterval)
		{
			netInput.hasJump = [NSNumber numberWithFloat:1.0];
			timeSinceLastNetJump = 0;
		}
	}
	
	//Process Tap Targetting
	if([playerInput targetTapped])
	{
		CGPoint tapPos = [playerInput tapPosition];		
		CGPoint worldPos = CGPointMake(tapPos.x - camera.position.x,  tapPos.y - camera.position.y);
		//we fire regardless of server or client, but the collision is confirmed on server
		if([pawn fire:worldPos])
		{
			netInput.shootPointX = [NSNumber numberWithFloat:worldPos.x];
			netInput.shootPointY = [NSNumber numberWithFloat:worldPos.y];
		}
	}
	
	return netInput;
}

-(void) processCamera:(ccTime)dt;
{
	[camera updatePosition];
}

//Client Synchronization...since they are smart clients we only sync the movements not the position, velocity and shooting
-(void) processNetworkInput:(NetworkPlayerInput*)input packetID:(int)packetID
{
//	if((packetID < receivedPacketID && receivedPacketID > packetIDLimit-200) || packetID > receivedPacketID)
//	{
//		receivedPacketID = packetID;
		if(![pawn isDead])
		{
			
			//if(![GameScene isServer])
			//	pawn.health = input.health;
			
			if(pawn.health != 0)
			{			
				if(input.hasJump)
					[pawn jump:[input.hasJump floatValue]];
				if(input.moveVector != nil)
				{
					[pawn walk:b2Vec2([input.moveVector floatValue],0)];
				}
			}			
		}
//	}
//	else {
//		NSLog(@"Packet out of order ignoring...%d | %d",receivedPacketID,packetID);
//	}

}

-(void) dealloc
{
    [playerInput release];
    [camera release];
    [super dealloc];
}

@end
