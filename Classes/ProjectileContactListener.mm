//
//  ProjectileContactListener.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "ProjectileContactListener.h"
#import "GameScene.h"

void ProjectileContactListener::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody(); 
	b2Body* bodyB = contact->GetFixtureB()->GetBody(); 
	
	Projectile* proj;
	GamePawn* pawn;
	
	proj = (Projectile*)bodyA->GetUserData(); 
	pawn = (GamePawn*)bodyB->GetUserData(); 
	if([proj class] != [Projectile class])
	{
		proj = (Projectile*)bodyB->GetUserData(); 		
		pawn = (GamePawn*)bodyA->GetUserData(); 
	}
	
	if([proj class] == [Projectile class] && [pawn isKindOfClass:[GamePawn class]])
	{
		if([GameScene isServer] || [GameScene CurrentGameMode] == Game_Single)
		{
			if(![pawn isDead])
			{
				[pawn.controller pawnHit:proj.damage];
				if([pawn isDead])
					[proj.controller registerKill];
			}
		}
		proj.destroyed = true;
	}
}

void ProjectileContactListener::EndContact(b2Contact* contact)
{  }


void ProjectileContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{  }


void ProjectileContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)

{  }

