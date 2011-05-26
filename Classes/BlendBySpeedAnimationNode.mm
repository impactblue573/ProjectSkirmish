//
//  BlendBySpeedAnimationNode.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "BlendBySpeedAnimationNode.h"


@implementation BlendBySpeedAnimationNode

-(id) initWithSpeedList:(NSArray *)sList animationMapping:(NSArray *)aList
{
	speedList = [[NSArray arrayWithArray:sList] retain];
	animationList = [[NSArray arrayWithArray:aList] retain];
	return self;
}

-(AnimationSequence) Eval:(GamePawn *)pawn
{
	float speed = fabsf(pawn.velocity.x);
	if(speed == [[speedList objectAtIndex:0] floatValue])
		return [self AnimSeq:[animationList objectAtIndex:0]];
	for(NSUInteger i = 1; i < [speedList count]; i++)
	{
		if(speed > [[speedList objectAtIndex:i-1] floatValue] && speed <= [[speedList objectAtIndex:i] floatValue])
			return [self AnimSeq:[animationList objectAtIndex:i]];
	}
	return [super Eval:pawn];
}

-(void) dealloc
{
    [speedList release];
    [animationList release];
    [super dealloc];
}

@end
