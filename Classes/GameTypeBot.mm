//
//  GameTypeBot.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameTypeBot.h"


@implementation GameTypeBot

@synthesize pawnType,team,handicap,x,y,ai;


-(id) init
{
    self = [super init];
    handicap = 1.0;
    return self;
}

@end
