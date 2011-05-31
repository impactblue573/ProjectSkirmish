//
//  AnimationHelper.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "AnimationHelper.h"

static CCSpriteFrameCache* _sharedFrameCache;

@implementation AnimationHelper

+(CCSpriteFrameCache*) sharedFrameCache
{
    if(!_sharedFrameCache)
    {
        _sharedFrameCache = [[CCSpriteFrameCache alloc] init];
    }
    return _sharedFrameCache;
}

+(CCSpriteFrameCache*) cacheSpriteSheet:(NSString*)spriteName
{	
//	CCSpriteFrameCache* frameCache = [[[CCSpriteFrameCache alloc] init] autorelease];
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[frameCache addSpriteFramesWithFile: [NSString stringWithFormat:@"%@.plist", spriteName]];
	return frameCache;
}

+(CCSpriteBatchNode*) initializeSprite:(NSString*)spriteName
{
	CCSpriteBatchNode* spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", spriteName]];
	return spriteSheet;
}

+(CCAnimation*) createAnimation:(NSArray*)frameNames withDelay:(float)delay fromCache:(CCSpriteFrameCache*)frameCache autoOffsetTo:(CGSize)defaultSize
{
	NSMutableArray* frames = [NSMutableArray array];
	for(NSUInteger i = 0; i < [frameNames count]; i++)
	{
		NSString* name = [frameNames objectAtIndex:i];
		CCSpriteFrame* sprite = [frameCache spriteFrameByName:name];
        if(defaultSize.width > 0 && defaultSize.height > 0)
        {
            sprite.offsetInPixels = ccp((defaultSize.width - sprite.originalSizeInPixels.width)/2,(sprite.originalSizeInPixels.height - defaultSize.height)/2);
        }
        [frames addObject:sprite];
	}
	CCAnimation* animation = [CCAnimation animationWithFrames:frames delay:delay];
	return animation;
}

@end
