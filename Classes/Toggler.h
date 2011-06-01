//
//  Toggler.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef struct ToggleItem
{
    NSString* spriteName;
    NSString* value;
} ToggleItem;

@interface Toggler : CCLayerColor {
    NSMutableArray* itemList;
    NSMutableArray* spriteList;
    uint itemCount;
    uint currentIndex;
    NSInvocation* selectInvocation;
}

-(void) setTarget:(id)target selector:(SEL)selector;
-(id) initWithItemList:(NSMutableArray*)list toggleSprite:(NSString*)toggleSprite activeToggleSprite:(NSString*)activeToggleSprite labelSprite:(NSString*)labelSprite;
-(void) setIndex:(uint)index;
-(void) toggleItem;
-(void) onSelect;
-(ToggleItem) getSelected;
@end
