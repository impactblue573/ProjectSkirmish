//
//  AnimationTreeManager.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationNode.h"

@interface AnimationTreeManager : NSObject {
	AnimationNode* rootNode;
	NSMutableArray* nodeList;
}

-(AnimationSequence) Eval:(GamePawn *)pawn;
-(void) appendNode:(AnimationNode*)node;
@end
