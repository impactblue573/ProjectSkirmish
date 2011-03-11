//
//  GameType.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 2/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameTeam.h"

@interface GameType : NSObject {

}

-(GameTeam*) GetWinningTeam:(NSArray*)teams;

@end
