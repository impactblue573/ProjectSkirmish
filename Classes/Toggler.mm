//
//  Toggler.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Toggler.h"


@implementation Toggler

-(id) initWithItemList:(NSMutableArray *)list toggleSprite:(NSString*)toggleSprite activeToggleSprite:(NSString*)activeToggleSprite labelSprite:(NSString*)labelSprite
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self = [super initWithColor:ccc4(0, 0, 0, 0) width:winSize.width height:winSize.height];
    itemList = [[NSMutableArray arrayWithArray:list] retain];
    spriteList = [[NSMutableArray array] retain];
    itemCount = [itemList count];
    currentIndex = 0;
    [self setAnchorPoint:ccp(0,0)];
    
    CCMenu* toggleItemMenu = [CCMenu menuWithItems:nil];
    toggleItemMenu.anchorPoint = ccp(0.5,0);
    toggleItemMenu.position = ccp(winSize.width/2,60);
    for(uint i = 0; i < itemCount; i++)
    {
        ToggleItem item;
        [[itemList objectAtIndex:i] getValue:&item];
        CCMenuItemImage* sprite = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:item.spriteName] selectedSprite:[CCSprite spriteWithSpriteFrameName:item.spriteName] target:self selector:@selector(onSelect)];
        sprite.anchorPoint = ccp(0.5,0);
        sprite.opacity = 0;
        [toggleItemMenu addChild:sprite];
        [spriteList addObject:sprite];        
    }
    CCSprite* label = [CCSprite spriteWithSpriteFrameName:labelSprite];
    label.anchorPoint = ccp(0.5,1);
    label.position = ccp(winSize.width/2,winSize.height - 4);
    CCMenuItemImage* toggleItem = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:toggleSprite] selectedSprite:[CCSprite spriteWithSpriteFrameName:activeToggleSprite] target:self selector:@selector(toggleItem)];
    toggleItem.selectedImage.position = ccp(-10,-3);
    CCMenu* toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
    toggleMenu.anchorPoint = ccp(0.5,0);
    toggleMenu.position = ccp(winSize.width/2,30);
    [self addChild:label z:2];
    [self addChild:toggleItemMenu z:0];
    [self addChild:toggleMenu z:1];
    [self setIndex:0];
    return self;
}

-(void) setTarget:(id)target selector:(SEL)selector
{
    if(target && selector)
	{
		NSMethodSignature* sig = nil;
		sig = [target methodSignatureForSelector:selector];
        if(selectInvocation)
            [selectInvocation release];
		selectInvocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
		[selectInvocation setTarget:target];
		[selectInvocation setSelector:selector];
	}
}

-(void) toggleItem
{
    [self setIndex:(currentIndex + 1 < itemCount ? currentIndex + 1 : 0)];
}

-(void) setIndex:(uint)index
{
    if(index < itemCount)
    {
        CCSprite* previous = [spriteList objectAtIndex:currentIndex];
        previous.opacity = 0;
        CCSprite* current = [spriteList objectAtIndex:index];
        current.opacity = 255;
        currentIndex = index;
    }
}

-(void) onSelect
{
    if(selectInvocation)
    {
        ToggleItem item = [self getSelected];
        [selectInvocation setArgument:&item atIndex:2];
        [selectInvocation invoke];
    }
}

-(ToggleItem) getSelected
{
    ToggleItem item;
    [[itemList objectAtIndex:currentIndex] getValue:&item];
    return item;
}

-(void) dealloc
{
    [selectInvocation release];
    [itemList release];
    [spriteList release];
    [super dealloc];
}
@end
