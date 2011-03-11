//
//  BattleInfo.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePawn.h"

@interface BattleInfo : NSObject {
	NSArray* pawnList;
}

-(id) initWithPawnList:(NSArray*)pList;
-(NSArray*) getEnemyLocations:(GamePawn*)pawn;
@end
