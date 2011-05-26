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

+(id) initWithSlideListItem:(SlideListItem)item target:(id)r selector:(SEL)s
{
	return [[[self alloc] initWithSlideListItem:item target:r selector:s] autorelease];
}

-(id) initWithSlideListItem:(SlideListItem)item target:(id)r selector:(SEL)s
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite* itemSprite;
    @try     {
        itemSprite = [CCSprite spriteWithSpriteFrameName:item.image];
    } 
    @catch (NSException* ex) {
        itemSprite = [CCSprite spriteWithFile:item.image];
    }
	[self initFromNormalImage:item.image selectedImage:nil disabledImage:nil target:r selector:s];
	slideListItem = item;
	CCLabelTTF* text = [CCLabelTTF labelWithString:item.text fontName:@"Marker Felt" fontSize:20];
	[text setColor:(ccColor3B){50,50,50}];
	text.position = ccp(200,30);
	[self addChild:text];
	return self;
}
@end
