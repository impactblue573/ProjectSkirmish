//
//  BlendByStateAnimationNode.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationNode.h"

@interface BlendByStateAnimationNode : AnimationNode {
	NSString* deathAnim;
}

-(id) initWithDeathAnimation:(NSString*)anim;

@end
