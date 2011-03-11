//
//  PaintballSplatParticleSystem.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 31/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "PaintballSplatParticleSystem.h"


@implementation PaintballSplatParticleSystem

-(id) initVelocity:(CGPoint)vel
{
	if( (self=[super initWithTotalParticles:1000]) ) {
		
		// duration
		duration = 2.0f;
		
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity Mode: gravity
		self.gravity = [Helper CGPointMultiply:vel multiply:2];
		
		// Gravity Mode: speed of particles
		self.speed = 3;
		self.speedVar = 1;
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		
		// angle
		angle = 90 * (vel.x - 1);
		angleVar = 180;
		
		// emitter position
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.position = ccp(winSize.width/2, winSize.height/2);
		posVar = CGPointZero;
		
		// life of particles
		life = 2.0f;
		lifeVar = 0.2f;
		
		// size, in pixels
		startSize = 1.0f;
		startSizeVar = 0.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
		
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles
		startColor.r = 1.0f;
		startColor.g = 0.0f;
		startColor.b = 0.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0.0f;
		startColorVar.g = 0.3f;
		startColorVar.b = 0.3f;
		startColorVar.a = 0.0f;
		endColor.r = 1.0f;
		endColor.g = 0.0f;
		endColor.b = 0.0f;
		endColor.a = 0.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.3f;
		endColorVar.b = 0.3f;
		endColorVar.a = 0.0f;
		
		//self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
		
		// additive
		self.blendAdditive = NO;
	}
	return self;
}

@end
