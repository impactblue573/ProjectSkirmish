//
//  NumberScroller.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 8/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DialList : CCNode {
	CCMenuItemImage* upButton;
	CCMenuItemImage* downButton;
	CCLabelTTF* valueLabel;
	NSArray* valueList;
	uint index;
}

-(id) initWithList:(NSArray*)list withWidth:(float)width;
-(NSString*) getSelectedValue;
@end