//
//  AnimationManager.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationHelper.h"
#import "cocos2d.h"

@interface AnimationManager : NSObject {
	NSMutableDictionary* animations;
	NSMutableDictionary* sprites;
	CCSpriteBatchNode* spriteSheet;
	CCSpriteFrameCache* frameCache;
	NSMutableDictionary* lastActions;
	NSMutableDictionary* lastAnimations;
}

-(void) initSpriteSheet:(NSString*)spriteSheetName;
-(void) addAnimation:(NSString*)animationName usingFrames:(NSArray*)frameNames frameDelay:(float)delay;
-(void) addToLayer:(CCLayer*)layer;
-(void) playLoopAnimation:(NSString*)animationName forSprite:(NSString*)spriteName;
-(void) playAnimation:(NSString *)animationName forSprite:(NSString *)spriteName ignoreDuplicate:(bool)ignoreDup;
-(void) playAnimation:(NSString *)animationName forSprite:(NSString*)spriteName;
-(void) runAction:(CCAction*)action forSprite:(NSString*)spriteName;
-(CCSprite*) addSprite:(NSString *)spriteName defaultFrame:(NSString*)frameName;
-(CCSprite*) getSprite:(NSString*)spriteName;
@end
