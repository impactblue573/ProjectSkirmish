//
//  PaintballExplodeParticleSystem.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 31/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "PaintballExplodeParticleSystem.h"


@implementation PaintballExplodeParticleSystem

-(id) initVelocity:(CGPoint)vel withColor:(ccColor3B)color
{
	if( (self=[super initWithTotalParticles:500]) ) {
		
		self.autoRemoveOnFinish = true;
		// duration
		duration = 0.2f;
		
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity Mode: gravity
		self.gravity = [Helper CGPointMultiply:vel multiply:1000];
		
		// Gravity Mode: speed of particles
		self.speed = 100;
		self.speedVar = 25;
		
		// Gravity Mode: radial
		self.radialAccel = 100;
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
		life = 0.2f;
		lifeVar = 0.2f;
		
		// size, in pixels
		startSize = 1.0f;
		startSizeVar = 2.0f;
		endSize = 1.0f;
		
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles		
		startColor.r = color.r/255;
		startColor.g = color.g/255;
		startColor.b = color.b/255;
		startColor.a = 1.0f;
		startColorVar.r = 0.0f;
		startColorVar.g = 0.0f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.3f;
		endColor.r = color.r/255;
		endColor.g = color.g/255;
		endColor.b = color.b/255;
		endColor.a = 0.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		//self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
		
		// additive
		self.blendAdditive = NO;
	}
	 return self;
}

@end
