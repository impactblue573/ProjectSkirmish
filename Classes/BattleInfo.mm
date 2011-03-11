//
//  BattleInfo.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "BattleInfo.h"


@implementation BattleInfo

-(id) initWithPawnList:(NSArray*)pList
{
	pawnList = [[NSArray arrayWithArray:pList] retain];
	return self;
}

-(NSArray*) getEnemyLocations:(GamePawn *)pawn
{
	NSMutableArray* enemyList = [[NSMutableArray alloc] init];
	for(NSUInteger i = 0; i < [pawnList count]; i++)
	{
		GamePawn* p = [pawnList objectAtIndex:i];
		if(p.team.teamIndex != pawn.team.teamIndex)
			[enemyList addObject:[NSValue valueWithCGPoint:[Helper toCGPoint:[p position]]]];
	}
	return enemyList ;
}

-(void) dealloc
{
	[pawnList release];
	[super dealloc];
}
@end
