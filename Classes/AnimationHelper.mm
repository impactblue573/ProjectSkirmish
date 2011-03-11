//
//  AnimationHelper.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "AnimationHelper.h"


@implementation AnimationHelper

+(CCSpriteFrameCache*) cacheSpriteSheet:(NSString*)spriteName
{	
	CCSpriteFrameCache* frameCache = [[CCSpriteFrameCache alloc] init];
	[frameCache addSpriteFramesWithFile: [NSString stringWithFormat:@"%@.plist", spriteName]];
	return frameCache;
}

+(CCSpriteBatchNode*) initializeSprite:(NSString*)spriteName
{
	CCSpriteBatchNode* spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", spriteName]];
	return spriteSheet;
}

+(CCAnimation*) createAnimation:(NSArray*)frameNames withDelay:(float)delay fromCache:(CCSpriteFrameCache*)frameCache
{
	NSMutableArray* frames = [NSMutableArray array];
	for(NSUInteger i = 0; i < [frameNames count]; i++)
	{
		NSString* name = [frameNames objectAtIndex:i];
		[frames addObject:[frameCache spriteFrameByName:name]];
	}
	CCAnimation* animation = [CCAnimation animationWithFrames:frames delay:delay];
	return animation;
}

@end
