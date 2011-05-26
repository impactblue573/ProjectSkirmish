//
//  AnimationHelper.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 29/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AnimationHelper : NSObject {

}

+(CCSpriteFrameCache*) sharedFrameCache;
+(CCSpriteFrameCache*) cacheSpriteSheet:(NSString *)spriteName;
+(CCSpriteBatchNode*) initializeSprite:(NSString*)spriteName;
+(CCAnimation*) createAnimation:(NSArray *)frameNames withDelay:(float)delay fromCache:(CCSpriteFrameCache*)frameCache;

@end
