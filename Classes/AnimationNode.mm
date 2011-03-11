//
//  AnimationNode.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "AnimationNode.h"


@implementation AnimationNode

@synthesize child;
-(AnimationSequence) Eval:(GamePawn*)pawn
{
	if(child != nil)
		return [child Eval:pawn];
	else return [self AnimSeq:nil];
}

-(AnimationSequence) AnimSeq:(NSString*)animName
{
	return [self AnimSeq:animName loopAnim:true];
}

-(AnimationSequence) AnimSeq:(NSString*)animName loopAnim:(bool)loop
{
	return [self AnimSeq:animName loopAnim:loop ignoreDuplicate:false];
}

-(AnimationSequence) AnimSeq:(NSString*)animName loopAnim:(bool)loop ignoreDuplicate:(bool)ignoreDup;
{
	AnimationSequence aSeq;
	aSeq.animationName = animName;
	aSeq.loopAnimation = loop;
	aSeq.ignoreDuplicate = ignoreDup;
	return aSeq;
}
@end
