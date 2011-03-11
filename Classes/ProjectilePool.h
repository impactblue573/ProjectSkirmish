//
//  ProjectilePool.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectile.h";

@interface ProjectilePool : NSObject {
	NSMutableArray* pendingProjectiles;
}

-(void) queueProjectile:(Projectile*)p;

-(Projectile*) getNextProjectile;
@end
