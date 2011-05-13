//
//  NetworkController.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 5/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "NetworkGameController.h"
#import "GameScene.h"

@implementation NetworkGameController

static int packetIDLimit = 4000; 

@synthesize sentPacketID;

-(id) init
{
	self = [super init];
	networkSyncInterval = 0.15;
	sentPacketID = 0;
	return self;
}

-(void) processNetworkInput:(NetworkPlayerInput*)input packetID:(int)packetID
{
	//if((packetID < receivedPacketID && receivedPacketID > packetIDLimit-200) || packetID > receivedPacketID)
	//{
	//	receivedPacketID = packetID;
		if(![pawn isDead])
		{
			if(pawn.health != 0)
			{
				b2Vec2 pos = [pawn position];
				if(input.positionX != nil)
				{
					b2Vec2 vel = b2Vec2([input.velocityX floatValue],[input.velocityY floatValue]);
					CGPoint pos = ccp([input.positionX floatValue],[input.positionY floatValue]);
                    b2Vec2 pawnPos = [pawn position];
                    float delta = sqrtf(powf(pos.x - pawnPos.x,2) + powf(pos.y - pawnPos.y, 2));
                    if(delta > 40)
                    {
                        [pawn setPosition:pos];
                    }
                    else if (delta > 4)
                    {
                        pos = ccp(pawnPos.x + (pos.x - pawnPos.x) * 0.1, pawnPos.y + (pos.y - pawnPos.y) * 0.1);
                        [pawn setPosition:pos];
                    }
					
					[pawn setVelocity:vel];
				}

				if(input.hasJump)
					[pawn jump];
				if(input.moveVector != nil)
				{
					[pawn walk:b2Vec2([input.moveVector floatValue],0)];
				}
				if(input.shootPointX != nil)
					[pawn fire:ccp([input.shootPointX floatValue],[input.shootPointY floatValue])];
			}
			
		}
	//}
	//else {
	//	NSLog(@"Packet out of order ignoring...%d | %d",receivedPacketID,packetID);	
	//}

}

-(int) incrementPacketID
{
	sentPacketID++;
	if(sentPacketID > packetIDLimit)
		sentPacketID = 0;
	return sentPacketID;
}

@end
