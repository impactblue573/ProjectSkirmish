//
//  SlideList.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "SlideList.h"


@implementation SlideList


-(id) initWithSlideListItems:(NSMutableArray *)items
{
    self = [super init];
    NSMutableArray* menuItems = [NSMutableArray array];
	for(uint i = 0; i < [items count]; i++)
    {
        SlideListItem item;
        [[items objectAtIndex:i] getValue:&item];
        SlideListMenuItem* slideListItem = [SlideListMenuItem initWithSlideListItem:item target:self selector:@selector(slideItemSelect:)];
        [menuItems addObject:slideListItem];
    }
    [self initWithSlideListMenuItems:menuItems];
    return self;
}


-(id) initWithSlideListMenuItems:(NSMutableArray *)items
{
	screenSize = [[CCDirector sharedDirector] winSize];
	if((self = [super initWithColor:(ccColor4B){255,255,255,255} width:screenSize.width height:screenSize.height]))
	{
		//[self processSlideListItems:items];
		slideListItems = [[NSMutableArray arrayWithArray:items] retain];
		length = [slideListItems count];
		position = 0;
		menu = [CCMenu menuWithItems:nil];
        menu.anchorPoint = ccp(0,0);
		menu.position = ccp(-position * screenSize.width,0);
		for(uint i = 0; i < [slideListItems count]; i++)
		{
			SlideListMenuItem* slideListItem = [slideListItems objectAtIndex:i]; 
            [slideListItem setTarget:self selector:@selector(slideItemSelect:)];
            slideListItem.position = ccp(i * screenSize.width + (screenSize.width)/2, screenSize.height/2);
			[menu addChild:slideListItem];
		}
		[self addChild:menu z:1];
		leftArrow = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Arrow-Right.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Arrow-Right-Active.png"] disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Arrow-Right-Disabled.png"] target:self selector:@selector(onArrowClick:)];
		leftArrow.position = ccp(27,0);
		leftArrow.rotation = 180;
		[leftArrow setIsEnabled:false];
		rightArrow = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Arrow-Right.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"Arrow-Right-Active.png"] disabledSprite:[CCSprite spriteWithSpriteFrameName:@"Arrow-Right-Disabled.png"] target:self selector:@selector(onArrowClick:)];
		rightArrow.position = ccp(screenSize.width - 27,0);
		[rightArrow setIsEnabled:length > 1];
		arrowsMenu = [CCMenu menuWithItems:leftArrow,rightArrow,nil];
		arrowsMenu.position = ccp(0,screenSize.height/2);
		[self addChild:arrowsMenu z:2];
		
	}
	return self;
}


-(void) setTarget:(id)t selector:(SEL)s
{
	if(t && s)
	{
		NSMethodSignature* sig = nil;
		sig = [t methodSignatureForSelector:s];
        if(callbackInvocation)
            [callbackInvocation release];
		callbackInvocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
		[callbackInvocation setTarget:t];
		[callbackInvocation setSelector:s];
	}
}

-(void) processSlideListItems:(NSMutableArray*)items
{
    if(slideListItems)
        [slideListItems release];
	slideListItems = [[NSMutableArray arrayWithArray:items] retain];
}

-(void) slideItemSelect:(id)menuItem
{
	SlideListMenuItem* item = menuItem;
	SlideListItem slItem = [item getItem];
	[callbackInvocation setArgument:&slItem atIndex:2];
	[callbackInvocation invoke];
}

-(void) onArrowClick:(id)arrow
{
	if(arrow == leftArrow)
		position--;
	else
		position++;
	
	if(position == 0)
		[leftArrow setIsEnabled:false];
	else
		[leftArrow setIsEnabled:true];
	
	if(position >= length-1)
		[rightArrow setIsEnabled:false];
	else
		[rightArrow setIsEnabled:true];

	target = ccp(-position * screenSize.width,0);
	[self unschedule:@selector(doSlideAnimation:)];
	[self schedule:@selector(doSlideAnimation:)];
}

-(void) doSlideAnimation:(ccTime)delta
{
	if(menu.position.x < target.x)
		menu.position = ccp(menu.position.x+40,menu.position.y);
	else if(menu.position.x > target.x)
		menu.position = ccp(menu.position.x-40,menu.position.y);
	else
		[self unschedule:@selector(doSlideAnimation:)];
}

-(void) dealloc
{
    if(callbackInvocation)
        [callbackInvocation release];
    [slideListItems release];
    [super dealloc];
}
@end
