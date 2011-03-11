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

-(void) processNetworkInput:(NetworkPlayerInput*)input
{
	if(![pawn isDead])
	{
		if(pawn.health != 0)
		{
			b2Vec2 pos = [pawn position];
			if(input.positionX != nil)
			{
				b2Vec2 vel = b2Vec2([input.velocityX floatValue],[input.velocityY floatValue]);
				CGPoint pos = ccp([input.positionX floatValue],[input.positionY floatValue]);
				[pawn setPosition:pos];
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
}

@end
