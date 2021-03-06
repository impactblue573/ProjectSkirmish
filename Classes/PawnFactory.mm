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
	int p = arc4random()%100;
	if(p <= 25)
	{
		return [[[LamboPawn alloc] init] autorelease];
	}
	else if(p <= 50)
	{
		return [[[BullseyePawn alloc] init] autorelease];
	}
    else if(p <= 75)
	{
		return [[[PorcusMaximusPawn alloc] init] autorelease];
	}
	else
	{
		return [[[GinjaNinjaPawn alloc] init] autorelease];
	}
}

+(GamePawn*) initializePawnType:(NSString *)pawnType
{
	if([pawnType isEqualToString:@"Lambo"])
	{
		GamePawn* pawn = [[[LamboPawn alloc] init] autorelease];
        [pawn setVariation:1];
        return pawn;
	}
    else if([pawnType isEqualToString:@"Lambo (Spec Ops)"])
    {
		GamePawn* pawn = [[[LamboPawn alloc] init] autorelease];
        [pawn setVariation:2];
        return pawn;
	}
    else if([pawnType isEqualToString:@"Bullseye"])
	{
		GamePawn* pawn = [[[BullseyePawn alloc] init] autorelease];
        [pawn setVariation:1];
        return pawn;
	}
    else if([pawnType isEqualToString:@"Bullseye (Punk)"])
    {
		GamePawn* pawn = [[[BullseyePawn alloc] init] autorelease];
        [pawn setVariation:2];
        return pawn;
	}
	else if([pawnType isEqualToString:@"Ginja Ninja"])
    {
        GamePawn* pawn = [[[GinjaNinjaPawn alloc] init] autorelease];
        [pawn setVariation:1];
        return pawn;
	}
    else if([pawnType isEqualToString:@"Ginja Ninja (Ghost)"])
    {
        GamePawn* pawn = [[[GinjaNinjaPawn alloc] init] autorelease];
        [pawn setVariation:2];
        return pawn;
	}
    else if([pawnType isEqualToString:@"Porcus Maximus"])
    {
        GamePawn* pawn = [[[PorcusMaximusPawn alloc] init] autorelease];
        [pawn setVariation:1];
        return pawn;
	}
    else if([pawnType isEqualToString:@"Porcus Maximus (Caesar)"])
    {
        GamePawn* pawn = [[[PorcusMaximusPawn alloc] init] autorelease];
        [pawn setVariation:2];
        return pawn;
	}
    return [[[GamePawn alloc] init] autorelease];
}
@end
