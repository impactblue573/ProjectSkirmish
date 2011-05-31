//
//  AnimationManager.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "AnimationManager.h"


@implementation AnimationManager

-(id) init
{
	animations = [[NSMutableDictionary dictionary] retain];
	sprites = [[NSMutableDictionary dictionary] retain];
	lastAnimations = [[NSMutableDictionary dictionary] retain];
	lastActions = [[NSMutableDictionary dictionary] retain];
	return self;
}

-(SpritePackage) addSprite:(NSString *)spriteName defaultFrame:(NSString*)frameName
{
    CCSpriteFrame* spriteFrame = [frameCache spriteFrameByName:frameName];
	CCSprite* sprite = [CCSprite spriteWithSpriteFrame:spriteFrame];
	[sprite.texture setAntiAliasTexParameters];
	[sprites setObject:sprite forKey:spriteName];	
	[spriteSheet addChild:sprite];
    SpritePackage package;
    package.sprite = sprite;
    package.size = spriteFrame.originalSizeInPixels;
	return package;
}

-(CCSprite*) getSprite:(NSString *)spriteName
{
	return [sprites objectForKey:spriteName];
}

-(void) initSpriteSheet:(NSString *)spriteSheetName
{
	frameCache = [AnimationHelper cacheSpriteSheet:spriteSheetName];
	spriteSheet = [AnimationHelper initializeSprite:spriteSheetName];
}

-(void) addAnimation:(NSString *)animationName usingFrames:(NSArray *)frameNames frameDelay:(float)delay
{
    [self addAnimation:animationName usingFrames:frameNames frameDelay:delay autoOffsetTo:CGSizeMake(0, 0)];
}
-(void) addAnimation:(NSString *)animationName usingFrames:(NSArray *)frameNames frameDelay:(float)delay autoOffsetTo:(CGSize)defaultSize
{
	CCAnimation* anim = [AnimationHelper createAnimation:frameNames withDelay:delay fromCache:frameCache autoOffsetTo:defaultSize];
	[animations setObject:anim forKey:(NSString *)animationName];
}

-(void) playAnimation:(NSString *)animationName forSprite:(NSString*)spriteName ignoreDuplicate:(bool)ignoreDup
{
	if(animationName != [lastAnimations objectForKey:spriteName] || ignoreDup)
	{
		CCAnimation* anim = [animations objectForKey:animationName];
		CCAction* action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:anim restoreOriginalFrame:NO] times:1];
		[self runAction:action forSprite:spriteName];
		[lastAnimations setObject:animationName forKey:spriteName];
	}
}

-(void) playAnimation:(NSString *)animationName forSprite:(NSString*)spriteName
{
	[self playAnimation:animationName forSprite:spriteName ignoreDuplicate:false];
}

-(void) playLoopAnimation:(NSString *)animationName forSprite:(NSString*)spriteName
{
	if(animationName != [lastAnimations objectForKey:spriteName])
	{
		CCAnimation* anim = [animations objectForKey:animationName];
		CCAction* action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim restoreOriginalFrame:NO]];	
		[self runAction:action forSprite:spriteName];		
		[lastAnimations setObject:animationName forKey:spriteName];
	}
}

-(void) runAction:(CCAction*)action forSprite:(NSString*)spriteName
{
	CCAction* lastAction = [lastActions objectForKey:spriteName];
	CCSprite* sprite = [sprites objectForKey:spriteName];
	if(lastAction != nil)
	{
		[sprite stopAction:lastAction];
	}
	[lastActions setObject:action forKey:spriteName];
	[sprite runAction:action];
}

-(void) addToLayer:(CCLayer*)layer
{
	[layer addChild:spriteSheet];
}

-(void) dealloc
{
    [animations release];
    [sprites release];
    [lastAnimations release];
    [lastActions release];
    [super dealloc];
}


@end
