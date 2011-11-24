//
//  Projectile.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"

@class GameController;

@interface Projectile : NSObject {
	CCSprite* sprite;
	b2Body* physicsBody;
	GameController* controller;
	CGPoint launchForce;
	CGPoint launchPosition;
	float mass;
	bool destroyed;
	float lifetime;
	CCParticleSystem* deathEffect;
	int teamIndex;
	float damage;
}

-(void) setProjectileSprite:(CCSprite*)spr;

@property(assign) GameController* controller;
@property(assign) CCSprite* sprite;
@property(assign) b2Body* physicsBody;
@property(assign) CGPoint launchForce;
@property(assign) CGPoint launchPosition;
@property(assign) float mass;
@property(assign) bool destroyed;
@property(assign) float lifetime;
@property(assign) CCParticleSystem* deathEffect; 
@property(assign) int teamIndex;
@property(assign) float damage;

@end
