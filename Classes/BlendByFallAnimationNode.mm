//
//  BlendByFallAnimationNode.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "BlendByFallAnimationNode.h"


@implementation BlendByFallAnimationNode

-(id) initWithRiseAnimation:(NSString *)rAnim fallAnim:(NSString *)fAnim
{
	fallAnimation = fAnim;
	riseAnimation = rAnim;
	return self;
}

-(AnimationSequence) Eval:(GamePawn *)pawn
{
	if(pawn.physicsState == Physics_Jumping)
		return [self AnimSeq:riseAnimation loopAnim:false];
	else if(pawn.physicsState == Physics_Falling)
		return [self AnimSeq:fallAnimation loopAnim:false];
	return [super Eval:pawn];
}
@end
