//
//  Projectile.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "Projectile.h"


@implementation Projectile

@synthesize sprite,physicsBody,launchForce,launchPosition,mass,destroyed,controller,lifetime,deathEffect,teamIndex,damage;

-(void) setProjectileSprite:(CCSprite*)spr
{
    if(sprite != nil)
        [sprite release];
    sprite = [spr retain];
}

-(void) dealloc
{
	//[physicsBody release];
    if(sprite != nil)
        [sprite release];
	[super dealloc];
}
@end
