//
//  BlendByFallAnimationNode.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationNode.h"

@interface BlendByFallAnimationNode : AnimationNode {
	NSString* fallAnimation;
	NSString* riseAnimation;
}

-(id)initWithRiseAnimation:(NSString*)rAnim fallAnim:(NSString*)fAnim; 
@end
