//
//  Windwalk.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WindwalkPowerup.h"


@implementation WindwalkPowerup

-(id) init
{
    self = [super init];
    moveFactor = 2.0;
    return self;
}

-(NSString*) getEquipMessage
{
    return @"Speed Boost!";
}
@end
