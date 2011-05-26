//
//  NumberScroller.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 8/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "DialList.h"


@implementation DialList

-(id) initWithList:(NSArray *)list withWidth:(float)width
{
	self = [super init];
	valueList = [[NSArray arrayWithArray:list] retain];
	upButton = [CCMenuItemImage itemFromNormalImage:@"UpArrow.png" selectedImage:@"UpArrowSelected.png" target:self selector:@selector(upButtonPress:)];
	upButton.position = ccp(0,10);
	downButton = [CCMenuItemImage itemFromNormalImage:@"DownArrow.png" selectedImage:@"DownArrowSelected.png" target:self selector:@selector(downButtonPress:)];
	downButton.position = ccp(0,-10);
	CCMenu* dialMenu = [CCMenu menuWithItems:upButton,downButton,nil];
	dialMenu.position = ccp(width,0);
	valueLabel = [CCLabelTTF labelWithString:[list objectAtIndex:0] dimensions:CGSizeMake(width,20) alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:20];
	[self addChild:valueLabel];
	[self addChild:dialMenu];
	return self;
}

-(void) upButtonPress:(id)sender
{
	index = (index+1)%[valueList count];
	[valueLabel setString:[valueList objectAtIndex:index]];
}
	 
-(void) downButtonPress:(id)sender
{
	index = index == 0 ? [valueList count] -1 :index-1;
	[valueLabel setString:[valueList objectAtIndex:index]];
}

-(NSString*) getSelectedValue
{
	return [valueList objectAtIndex:index];
}

-(void) dealloc
{
    [valueList release];
    [super dealloc];
}
@end
