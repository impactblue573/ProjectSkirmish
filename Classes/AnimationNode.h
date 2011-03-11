//
//  AnimationNode.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePawn.h"

#define ANIM_INLINE static inline
struct AnimationSequence {
	NSString* animationName;
	int loopAnimation;
	bool ignoreDuplicate; 
};
typedef struct AnimationSequence AnimationSequence;

@interface AnimationNode : NSObject {
	AnimationNode* child;
}

-(AnimationSequence) Eval:(GamePawn*)pawn;
-(AnimationSequence) AnimSeq:(NSString*)animName;
-(AnimationSequence) AnimSeq:(NSString*)animName loopAnim:(bool)loop;
-(AnimationSequence) AnimSeq:(NSString*)animName loopAnim:(bool)loop ignoreDuplicate:(bool)ignoreDup;

@property(assign) AnimationNode* child;
@end
