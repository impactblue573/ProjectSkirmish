//
//  BlendBySpeedAnimationNode.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationNode.h"

@interface BlendBySpeedAnimationNode : AnimationNode {
	NSArray* speedList;
	NSArray* animationList;
}

-(id) initWithSpeedList:(NSArray*)sList animationMapping:(NSArray*)aList;
@end
