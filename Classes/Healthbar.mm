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
    self = [super initWithColor:ccc4(200, 200, 200, 128) width:width + 6 height:height + 6];
    CCSprite* border = [CCSprite spriteWithSpriteFrameName:@"HealthbarBorder.png"];
//    [border.texture setAliasTexParameters];
    border.anchorPoint = ccp(0,0);
    [self addChild:border z:1];
    bar = [[[CCLayerColor alloc] initWithColor:ccc4(0, 255, 0, 255) width:width height:height] autorelease];
    [bar setOpacity:186];
    bar.anchorPoint = ccp(0,0);
    bar.position = ccp(3,3);
    [self addChild:bar z:0];
    return self;
}

-(void) setValue:(float)val
{
    val = clampf(val, 0, maxValue);
    [bar setColor: ccc3(2 * maxValue * clampf((maxValue - val)/(maxValue/2),0,1), 4 * maxValue * fmin(maxValue/2,val) / maxValue, 0)];
    bar.scaleX = val/maxValue;
}
@end
