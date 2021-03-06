//
//  PaintballExplodeParticleSystem.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 31/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Helper.h"

@interface PaintballExplodeParticleSystem : CCParticleSystemQuad {

}

-(id) initVelocity:(CGPoint)vel withColor:(ccColor3B)color numParticles:(int)particles;

@end
