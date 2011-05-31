//
//  LoadingScreen.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingScreen.h"


@implementation LoadingScreen

-(id) init
{
    CGSize size = [CCDirector sharedDirector].winSize;
    self = [super initWithColor:ccc4(255,255,255,255) width:size.width height:size.height];
    CCSprite* loadingSprite = [CCSprite spriteWithSpriteFrameName:@"Loading.png"];
    loadingSprite.anchorPoint = ccp(0.5,0.5);
    loadingSprite.position = ccp(size.width/2,size.height/2);
    CCSprite* loadingBar = [CCSprite spriteWithSpriteFrameName:@"LoadingBar.png"];
    loadingBar.anchorPoint = ccp(0,0.5);
    loadingBar.position = ccp(size.width/2 - 132,size.height/2 - 20);
    maxClippingSize = 264;
    clippingHeight = 41;
    clippingY = size.height/2 - 40;
    maxLeftMargin = size.width/2 + 132;
    clippingMask = [[[CCLayerColor alloc] initWithColor:ccc4(255,255,255,255) width:264 height:41] autorelease];
    clippingMask.position = ccp(maxLeftMargin - 264,clippingY);
    [self addChild:loadingSprite z:2];
    [self addChild:clippingMask z:1];
    [self addChild:loadingBar z:0];
    [self setProgress:0];
    return self;
}

-(void) setProgress:(float)progress
{
    float width = maxClippingSize - maxClippingSize * clampf(progress, 0, 100)/100;
    [clippingMask setContentSize:CGSizeMake(width,clippingHeight)];
    clippingMask.position = ccp(maxLeftMargin - width,clippingY);
}

@end
