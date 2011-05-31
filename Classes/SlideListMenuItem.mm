//
//  SlideListMenuItem.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "SlideListMenuItem.h"


@implementation SlideListMenuItem

@synthesize slideListItem;

+(id) initWithSlideListItem:(SlideListItem)item target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithSlideListItem:item target:target selector:selector] autorelease];
}

-(id) initWithSlideListItem:(SlideListItem)item target:(id)target selector:(SEL)selector
{
    slideListItem = item;
	[self initFromNormalSprite:[CCSprite spriteWithSpriteFrameName:item.image] selectedSprite:[CCSprite spriteWithSpriteFrameName:item.image] disabledSprite:nil target:target selector:selector];
	CCLabelTTF* text = [CCLabelTTF labelWithString:item.text fontName:@"Marker Felt" fontSize:20];
	[text setColor:(ccColor3B){50,50,50}];
	text.position = ccp(200,30);
	[self addChild:text];
	return self;
}
@end
