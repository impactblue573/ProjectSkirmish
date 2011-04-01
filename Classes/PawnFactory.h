//
//  PawnFactory.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LamboPawn.h"
#import "BullseyePawn.h"
#import "GinjaNinjaPawn.h"
#import "PorcusMaximusPawn.h"

@class GameController;

@interface PawnFactory : NSObject {

}

//Random
+(GamePawn*) initializePawn;

+(GamePawn*) initializePawnType:(NSString*)pawnType;
@end
