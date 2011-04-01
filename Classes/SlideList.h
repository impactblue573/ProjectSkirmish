//
//  SlideList.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SlideListMenuItem.h"

@protocol SlideListProtocol

-(void) onSelect:(SlideListItem)item;

@end


@interface SlideList : CCLayerColor {
	NSInvocation* callbackInvocation;
	NSMutableArray* slideListItems;
	CCMenu* arrowsMenu;
	CCMenuItemImage* leftArrow;
	CCMenuItemImage* rightArrow;
	CCMenu* menu;
	int length;
	int position;
	CGPoint target;
	CGSize screenSize;
}
	
-(id) initWithSlideListItems:(NSMutableArray*)items;
-(void) setTarget:(id)t selector:(SEL)s;

@end
