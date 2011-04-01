//
//  SlideListMenuItem.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

struct SlideListItem {
	NSString* image;
	NSString* key; 
	NSString* text;
};

typedef struct SlideListItem SlideListItem;

@interface SlideListMenuItem : CCMenuItemImage {
	SlideListItem slideListItem;
}

+(id) initWithSlideListItem:(SlideListItem)item target:(id)target selector:(SEL)selector;
-(id) initWithSlideListItem:(SlideListItem)item target:(id)target selector:(SEL)selector;

@property(assign) SlideListItem slideListItem;
@end
