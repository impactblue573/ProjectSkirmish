//
//  SlideListToggleMenuItem.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 1/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SlideListToggleMenuItem.h"


@implementation SlideListToggleMenuItem

+(id) initWithSlideToggleListItem:(SlideListToggleItem)item target:(id)target selector:(SEL)selector;
{
    return [[[self alloc] initWithSlideToggleListItem:item target:target selector:selector] autorelease];
}
-(id) initWithSlideToggleListItem:(SlideListToggleItem)item target:(id)target selector:(SEL)selector;
{
    self = [super initWithTarget:target selector:selector];
    [self setTarget:target selector:selector];
    toggleItems = [[NSMutableArray array] retain];
    for(uint i = 0; i < [item.images count]; i++)
    {
        ToggleItem toggleItem;
        toggleItem.spriteName = [NSString stringWithString:[item.images objectAtIndex:i]];
        toggleItem.value = [NSString stringWithString:[item.keys objectAtIndex:i]];
        [toggleItems addObject:[NSValue valueWithBytes:&toggleItem objCType:@encode(ToggleItem)]];
    }
    toggler = [[Toggler alloc] initWithItemList:toggleItems toggleSprite:item.toggleSprite activeToggleSprite:item.activeToggleSprite labelSprite:item.labelSprite];
    [toggler setTarget:self selector:@selector(togglerSelect:)];
    [self setContentSize:[toggler contentSize]];
    [self addChild:toggler];
    return self;
}

-(SlideListItem) getItem
{
    SlideListItem item;
    ToggleItem toggleItem = [toggler getSelected];
    item.key = [NSString stringWithString:toggleItem.value];
    return item;
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

-(void) togglerSelect:(ToggleItem)toggleItem
{
    if(selectInvocation)
    {
//        slideListItem.key = [NSString stringWithString:toggleItem.value];
        [selectInvocation setArgument:&self atIndex:2];
        [selectInvocation invoke];
    }
}

-(void) dealloc
{
    [toggleItems release];
    [selectInvocation release];
    [super dealloc];
}
@end
