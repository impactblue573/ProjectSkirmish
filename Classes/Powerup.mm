//
//  Powerup.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 9/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"


@implementation Powerup

@synthesize moveFactor, damageFactor, defenceBoost, jumpFactor,expired;


-(id) init
{
    self = [super init];
    moveFactor = 1.0;
    damageFactor = 1.0;
    defenceBoost = 0.0;
    jumpFactor = 1.0;
    lifetime = 10.0;
    expired = false;
    return self;
}

-(void) step:(ccTime)dt
{
    lifetime -= dt;
    if(lifetime <= 0)
        expired = true;
}

-(NSString*) getEquipMessage
{
    return @"Powerup!";
}

@end
