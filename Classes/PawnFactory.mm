//
//  PawnFactory.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "PawnFactory.h"


@implementation PawnFactory

+(GamePawn*) initializePawn
{
	int p = random()%100;
	if(p <= 33)
	{
		return [[GamePawn alloc] init];
	}
	else if(p <= 66)
	{
		return [[BullseyePawn alloc] init];
	}
	else
	{
		return [[GinjaNinja alloc] init];
	}
}

+(GamePawn*) initializePawnType:(NSString *)pawnType
{
	if([pawnType isEqualToString:@"Lambo"])
		return [[GamePawn alloc] init];
	else if([pawnType  isEqualToString:@"Bullseye"])
		return [[BullseyePawn alloc] init];
	else if([pawnType  isEqualToString:@"Ginja Ninja"])
		return [[GinjaNinja alloc] init];
	return [[GamePawn alloc] init];
}
@end
