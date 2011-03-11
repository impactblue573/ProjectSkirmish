//
//  BlendByFiringAnimationNode.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "BlendByFiringAnimationNode.h"


@implementation BlendByFiringAnimationNode

-(id) initWithFireAnimation:(NSString *)anim
{
	fireAnim = anim;
	return self;
}

-(AnimationSequence) Eval:(GamePawn *)pawn
{
	if(pawn.isFiring)
	{
		if(!firePlayed)
		{
			firePlayed = true;
			//CCLOG(@"Play Fire Anim");
			return [self AnimSeq:fireAnim loopAnim:false ignoreDuplicate:true];
		}
		else
		{
			//CCLOG(@"Already Played Fire Anim for Current Fire");
			return [self AnimSeq:nil];
		}
	}
	firePlayed = false;
	return [super Eval:pawn];
}
@end
