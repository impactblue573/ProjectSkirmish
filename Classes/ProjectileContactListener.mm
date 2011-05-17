//
//  ProjectileContactListener.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "ProjectileContactListener.h"
#import "GameScene.h"
#import "PowerupFactory.h"
#import "PowerupManager.h"

void ProjectileContactListener::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody(); 
	b2Body* bodyB = contact->GetFixtureB()->GetBody(); 
    id dataA = (id)bodyA->GetUserData();
    id dataB = (id)bodyB->GetUserData();
    
	Projectile* proj = nil;
	GamePawn* pawn = nil;
    
	if([dataA class] == [Projectile class])
    {
        proj = (Projectile*)dataA;
    }
    else if([dataA isKindOfClass:[GamePawn class]])
    {
        pawn = (GamePawn*)dataA;
    }    
    
    if([dataB class] == [Projectile class])
    {
        proj = (Projectile*)dataB;
    }
    else if([dataB isKindOfClass:[GamePawn class]])
    {
        pawn = (GamePawn*)dataB;
    }
    
    if(proj != nil && pawn != nil)
	{
		if([GameScene isServer] || [GameScene CurrentGameMode] == Game_Single)
		{
			if(![pawn isDead])
			{
				bool killed = [pawn.controller pawnHit:proj.damage];
				if(killed)
					[proj.controller registerKill];
			}
		}
		proj.destroyed = true;
	}

}

void ProjectileContactListener::EndContact(b2Contact* contact)
{  }


void ProjectileContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{  
    b2Body* bodyA = contact->GetFixtureA()->GetBody(); 
    b2Body* bodyB = contact->GetFixtureB()->GetBody(); 
    id dataA = (id)bodyA->GetUserData();
    id dataB = (id)bodyB->GetUserData();
    
    GamePawn* pawn = nil;
    PowerupFactory* powerup = nil;
    
    if([dataA isKindOfClass:[GamePawn class]])
    {
        pawn = (GamePawn*)dataA;
    }
    else if([dataA class] == [PowerupFactory class])
    {
        powerup = (PowerupFactory*)dataA;
    }
    
    
    if([dataB isKindOfClass:[GamePawn class]])
    {
        pawn = (GamePawn*)dataB;
    }
    else if([dataB class] == [PowerupFactory class])
    {
        powerup = (PowerupFactory*)dataB;
    }
    
    if(pawn != nil && powerup != nil)
    {
        [[PowerupManager current] powerupContact:powerup withPawn:pawn];
        contact->SetEnabled(false);
    }
}


void ProjectileContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)

{  }

