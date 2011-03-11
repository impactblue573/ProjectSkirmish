//
//  OneSideContactFilter.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 4/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

class OneSideContactFilter: public b2ContactFilter
{
	public:
	bool ShouldCollide (b2Fixture *fixtureA, b2Fixture *fixtureB);
};