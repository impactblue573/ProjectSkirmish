//
//  OneSideContactFilter.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 4/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "OneSideContactFilter.h"
#import "Box2D.h"
#import "Helper.h"

bool OneSideContactFilter::ShouldCollide (b2Fixture *fixtureA, b2Fixture *fixtureB)
{
	const b2Filter& filterA = fixtureA->GetFilterData();
	const b2Filter& filterB = fixtureB->GetFilterData();
	if(filterA.categoryBits == 8 || filterB.categoryBits == 8)
	{
		b2Fixture* staticFixture = filterA.categoryBits == 8 ? fixtureA : fixtureB;
		b2Fixture* dynamicFixture = filterA.categoryBits == 8 ? fixtureB: fixtureA;
		
		
		BodyBounds staticBounds = [Helper GetBounds:staticFixture];
        BodyBounds dynamicBounds = [Helper GetBounds:dynamicFixture];
        b2Body* dynamicBody = dynamicFixture->GetBody();
        
        //Basically make sure the lowest point of the dynamic body is higher than the highest point of the
		//static body before allowing collision
//        NSLog(@"Dynamic left:%f right:%f",dynamicBounds.left,dynamicBounds.right);
//        NSLog(@"Static left:%f right:%f",staticBounds.left,staticBounds.right);
        b2Vec2 dynamicVel = dynamicBody->GetLinearVelocity();
        if(dynamicVel.y > 0 || (uint)dynamicVel.y == 0)
        {
            if(dynamicBounds.bottom < staticBounds.top)
            {
                return false;
            }
        }
        else
        {
            if(staticBounds.bottom - dynamicBounds.bottom > 1)
            {
                return false;
            }
        }
	}
	return b2ContactFilter::ShouldCollide(fixtureA,fixtureB);
}
