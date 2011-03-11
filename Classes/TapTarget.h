//
//  TapTarget.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "cocos2d.h"

@interface TapTarget : CCNode <CCTargetedTouchDelegate> {
	NSMutableArray* ignoreZones;
	CGPoint tapPosition;
	bool isActive;
	float minTapTime;
}

-(id) initWithMinTouchDuration:(float)time;
-(bool) shouldIgnore:(CGPoint)point;
-(void) addIgnoreZone:(CGRect)zone;
-(void) clearTap:(float)delta;

@property bool isActive;
@property CGPoint tapPosition;
@end
