//
//  LoadingScreen.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingScreen : CCLayerColor {
    CCLayerColor* clippingMask;
    float maxClippingSize;
    float maxLeftMargin;
    float clippingY;
    float clippingHeight;
}

-(void) setProgress:(float)progress;
@end
