//
//  ProjectileContactListener.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "Projectile.h"
#import "GameController.h"
#import "GamePawn.h"

class ProjectileContactListener : public b2ContactListener
{
	public:
	
	void BeginContact(b2Contact* contact);
				
		
	void EndContact(b2Contact* contact);
			
			
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
				
								
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};
