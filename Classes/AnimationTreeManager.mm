//
//  AnimationTreeManager.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "AnimationTreeManager.h"


@implementation AnimationTreeManager

-(id)init
{
	nodeList = [[NSMutableArray alloc] init];
	return self;
}

-(void) appendNode:(AnimationNode *)node
{
    [node retain];
	if(rootNode == nil)
		rootNode = node;
	else 
	{
		AnimationNode* lastNode = [nodeList lastObject];
		lastNode.child = node;
	}
	[nodeList addObject:node];
}

-(AnimationSequence) Eval:(GamePawn*)pawn
{
	return [rootNode Eval:pawn];
}

-(void) dealloc
{
    for(uint i = 0; i < [nodeList count];i++)
    {
        [[nodeList objectAtIndex:i] release];
    }
    [nodeList release];
    [super dealloc];
}
@end
