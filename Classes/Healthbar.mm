//
//  Healthbar.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Healthbar.h"


@implementation Healthbar

-(id) initWithMaxValue:(float)max width:(float)w height:(float)h
{
    maxValue = max;
    value = maxValue;
    height = h;
    width = w;
    self = [super initWithColor:ccc4(128, 128, 128, 128) width:width + 4 height:height + 4];
    CCSprite* border = [CCSprite spriteWithSpriteFrameName:@"HealthbarBorder.png"];
    [border.texture setAliasTexParameters];
    border.anchorPoint = ccp(0,0);
    border.opacity = 128;
    [self addChild:border z:0];
    bar = [[[CCLayerColor alloc] initWithColor:ccc4(0, 255, 0, 255) width:width height:height] autorelease];
    [bar setOpacity:186];
    bar.anchorPoint = ccp(0,0);
    bar.position = ccp(2,2);
    [self addChild:bar];
    return self;
}

-(void) setValue:(float)val
{
    val = clampf(val, 0, maxValue);
    [bar setColor: ccc3(2 * maxValue * clampf((maxValue - val)/(maxValue/2),0,1), 4 * maxValue * fmin(maxValue/2,val) / maxValue, 0)];
    bar.scaleX = val/maxValue;
}
@end
