//
//  BlendByFiringAnimationNode.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationNode.h"

@interface BlendByFiringAnimationNode : AnimationNode {
	NSString* fireAnim;
	bool firePlayed;
}

-(id) initWithFireAnimation:(NSString*)anim;

@end
