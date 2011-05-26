//
//  Healthbar.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Healthbar : CCLayerColor {
    float value;
    float maxValue;
    float height;
    float width;
    CCLayerColor* bar;
}

-(id) initWithMaxValue:(float)max width:(float)w height:(float)h;
-(void) setValue:(float)val;

@end
