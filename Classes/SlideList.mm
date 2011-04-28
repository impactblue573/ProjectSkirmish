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
	screenSize = [[CCDirector sharedDirector] winSize];
	if((self = [super initWithColor:(ccColor4B){255,255,255,255} width:screenSize.width height:screenSize.height]))
	{
		//[self processSlideListItems:items];
		slideListItems = [[NSMutableArray arrayWithArray:items] retain];
		length = [slideListItems count];
		position = 0;
		menu = [CCMenu menuWithItems:nil];
		menu.position = ccp(-position * screenSize.width + 200,screenSize.height/2);
		for(uint i = 0; i < [slideListItems count]; i++)
		{
			SlideListItem item;
			[[slideListItems objectAtIndex:i] getValue:&item];
			SlideListMenuItem* slideListItem = [SlideListMenuItem initWithSlideListItem:item target:self selector:@selector(slideItemSelect:)];
			slideListItem.position = ccp(i * screenSize.width + (screenSize.width-400)/2, 0);
			[menu addChild:slideListItem];
		}
		[self addChild:menu z:1];
		leftArrow = [CCMenuItemImage itemFromNormalImage:@"Arrow-Right.png" selectedImage:@"Arrow-Right-Active.png" disabledImage:@"Arrow-Right-Disabled.png" target:self selector:@selector(onArrowClick:)];
		leftArrow.position = ccp(27,0);
		leftArrow.rotation = 180;
		[leftArrow setIsEnabled:false];
		rightArrow = [CCMenuItemImage itemFromNormalImage:@"Arrow-Right.png" selectedImage:@"Arrow-Right-Active.png" disabledImage:@"Arrow-Right-Disabled.png" target:self selector:@selector(onArrowClick:)];
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
		callbackInvocation = nil;
		callbackInvocation = [NSInvocation invocationWithMethodSignature:sig];
		[callbackInvocation setTarget:t];
		[callbackInvocation setSelector:s];
		[callbackInvocation retain];
	}
}

-(void) processSlideListItems:(NSMutableArray*)items
{
	slideListItems = [[NSMutableArray arrayWithArray:items] retain];
}

-(void) slideItemSelect:(id)menuItem
{
	SlideListMenuItem* item = menuItem;
	SlideListItem slItem = item.slideListItem;
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

	target = ccp(-position * screenSize.width + 200,screenSize.height/2);
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
@end