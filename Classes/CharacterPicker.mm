//
//  CharacterPicker.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "CharacterPicker.h"
#import "SlideListMenuItem.h"
#import "SlideListToggleMenuItem.h"

@implementation CharacterPicker

-(id) init
{
	NSMutableArray* items = [NSMutableArray array];
	SlideListToggleItem lamboItem;
    lamboItem.images = [NSMutableArray arrayWithObjects:@"LamboProfile.png",nil];
    lamboItem.keys = [NSMutableArray arrayWithObjects:@"Lambo", nil];
    lamboItem.toggleSprite = @"Costume.png";
    lamboItem.activeToggleSprite = @"CostumeActive.png";
    lamboItem.labelSprite = @"LamboProfileLabel.png";
    SlideListToggleMenuItem* toggleMenuItem = [[[SlideListToggleMenuItem alloc] initWithSlideToggleListItem:lamboItem target:nil selector:nil] autorelease];
    [items addObject:toggleMenuItem];
    
    SlideListToggleItem bullseyeItem;
    bullseyeItem.images = [NSMutableArray arrayWithObjects:@"BullseyeProfile.png", nil];
    bullseyeItem.keys = [NSMutableArray arrayWithObjects:@"Bullseye",nil];
    bullseyeItem.toggleSprite = @"Costume.png";
    bullseyeItem.activeToggleSprite = @"CostumeActive.png";
    bullseyeItem.labelSprite = @"BullseyeProfileLabel.png";
    toggleMenuItem = [[[SlideListToggleMenuItem alloc] initWithSlideToggleListItem:bullseyeItem target:nil selector:nil] autorelease];
    [items addObject:toggleMenuItem];
    
    SlideListToggleItem ginjaItem;
    ginjaItem.images = [NSMutableArray arrayWithObjects:@"GinjaNinjaProfile.png", nil];
    ginjaItem.keys = [NSMutableArray arrayWithObjects:@"Ginja Ninja", nil];
    ginjaItem.toggleSprite = @"Costume.png";
    ginjaItem.activeToggleSprite = @"CostumeActive.png";
    ginjaItem.labelSprite = @"GinjaNinjaProfileLabel.png";
    toggleMenuItem = [[[SlideListToggleMenuItem alloc] initWithSlideToggleListItem:ginjaItem target:nil selector:nil] autorelease];
    [items addObject:toggleMenuItem];
    
    SlideListToggleItem porcusItem;
    porcusItem.images = [NSMutableArray arrayWithObjects:@"PorcusMaximusProfile.png",@"PorcusMaximusAltProfile.png", nil];
    porcusItem.keys = [NSMutableArray arrayWithObjects:@"Porcus Maximus", @"Porcus Maximus Alt", nil];
    porcusItem.toggleSprite = @"Costume.png";
    porcusItem.activeToggleSprite = @"CostumeActive.png";
    porcusItem.labelSprite = @"PorcusMaximusProfileLabel.png";
    toggleMenuItem = [[[SlideListToggleMenuItem alloc] initWithSlideToggleListItem:porcusItem target:nil selector:nil] autorelease];
    [items addObject:toggleMenuItem];
	self = [self initWithSlideListMenuItems:items];
//	CCLabelTTF* topLabel = [CCLabelTTF labelWithString:@"Character Select" fontName:@"Marker Felt" fontSize:24];
//	[topLabel setColor:(ccColor3B){50,50,50}];
//	topLabel.position = ccp(90,screenSize.height-15);
//	[self addChild:topLabel z:6];
	return self;
}
@end
