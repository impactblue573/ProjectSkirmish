//
//  ProjectilePool.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "ProjectilePool.h"


@implementation ProjectilePool

-(id) init
{
	pendingProjectiles = [[NSMutableArray alloc] init];
	return self;
}

-(void) queueProjectile:(Projectile*)p;
{
	[pendingProjectiles addObject: p];
}

-(Projectile*) getNextProjectile
{
	if([pendingProjectiles count] > 0)
	{
		Projectile* projectile = [pendingProjectiles objectAtIndex:0];
		[pendingProjectiles removeObjectAtIndex:0];
		return projectile;
	}
	return nil;
}

@end
