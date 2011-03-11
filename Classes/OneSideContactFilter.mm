//
//  OneSideContactFilter.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 4/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "OneSideContactFilter.h"
#import "Box2D.h"

bool OneSideContactFilter::ShouldCollide (b2Fixture *fixtureA, b2Fixture *fixtureB)
{
	const b2Filter& filterA = fixtureA->GetFilterData();
	const b2Filter& filterB = fixtureB->GetFilterData();
	if(filterA.categoryBits == 8 || filterB.categoryBits == 8)
	{
		b2Fixture* staticFixture = filterA.categoryBits == 8 ? fixtureA : fixtureB;
		b2Fixture* dynamicFixture = filterA.categoryBits == 8 ? fixtureB: fixtureA;
		
		//Basically make sure the lowest point of the dynamic body is higher than the highest point of the
		//static body before allowing collision
		b2PolygonShape* staticShape = (b2PolygonShape*)staticFixture->GetShape();
		float staticY = staticShape->GetVertex(0).y;
		for(int i = 1; i < staticShape->GetVertexCount(); i++)
			if(staticShape->GetVertex(i).y > staticY)
				staticY = staticShape->GetVertex(i).y;
		staticY += staticFixture->GetBody()->GetPosition().y;

		b2PolygonShape* dynamicShape = (b2PolygonShape*)dynamicFixture->GetShape();
		float dynamicY = dynamicShape->GetVertex(0).y;
		for(int i = 1; i < dynamicShape->GetVertexCount(); i++)
			if(dynamicShape->GetVertex(i).y < dynamicY)
				dynamicY = dynamicShape->GetVertex(i).y;
		dynamicY += dynamicFixture->GetBody()->GetPosition().y;
		if(dynamicY < staticY)
			return false;
	}
	return b2ContactFilter::ShouldCollide(fixtureA,fixtureB);
}

