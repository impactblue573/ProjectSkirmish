//
//  Powerup.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 9/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Powerup : NSObject {
    float moveFactor;
    float damageFactor;
    float defenceBoost;
    float jumpFactor;
    float lifetime;
    bool expired;
}

-(id) init;
-(void) step:(ccTime)dt;
-(NSString*) getEquipMessage;

@property(readonly) float moveFactor;
@property(readonly) float damageFactor;
@property(readonly) float defenceBoost;
@property(readonly) float jumpFactor;
@property(readonly) bool expired;
@end
