//
//  SlideListToggleMenuItem.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideListMenuItem.h"
#import "Toggler.h"

struct SlideListToggleItem {
	NSMutableArray* images;
	NSMutableArray* keys;
    NSString* toggleSprite;
    NSString* activeToggleSprite;
    NSString* labelSprite;
};

@interface SlideListToggleMenuItem : SlideListMenuItem {
    NSMutableArray* toggleItems;
    Toggler* toggler;
    NSInvocation* selectInvocation;
}

+(id) initWithSlideToggleListItem:(SlideListToggleItem)item target:(id)target selector:(SEL)selector;
-(id) initWithSlideToggleListItem:(SlideListToggleItem)item target:(id)target selector:(SEL)selector;
-(void) togglerSelect:(ToggleItem)toggleItem;
@end
