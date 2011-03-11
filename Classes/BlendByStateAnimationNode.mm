//
//  BlendByStateAnimationNode.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 3/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "BlendByStateAnimationNode.h"


@implementation BlendByStateAnimationNode

-(id) initWithDeathAnimation:(NSString *)anim
{
	deathAnim = anim;
	return self;
}

-(AnimationSequence) Eval:(GamePawn *)pawn
{
	if([pawn isDead])
	{
		return [self AnimSeq:deathAnim];
	}
	return [super Eval:pawn];
}
@end
