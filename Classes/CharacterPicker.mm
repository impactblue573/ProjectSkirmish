//
//  CharacterPicker.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "CharacterPicker.h"


@implementation CharacterPicker

-(id) init
{
	NSMutableArray* items = [NSMutableArray array];
	SlideListItem item = (SlideListItem){@"LamboProfile.png",@"Lambo",nil};
	[items addObject:[NSValue value:&item withObjCType:@encode(struct SlideListItem)]];
	item = (SlideListItem){@"BullseyeProfile.png",@"Bullseye",nil};
	[items addObject:[NSValue value:&item withObjCType:@encode(struct SlideListItem)]];
	item = (SlideListItem){@"GinjaNinjaProfile.png",@"Ginja Ninja",nil};
	[items addObject:[NSValue value:&item withObjCType:@encode(struct SlideListItem)]];
    item = (SlideListItem){@"PorcusMaximusProfile.png",@"Porcus Maximus",nil};
	[items addObject:[NSValue value:&item withObjCType:@encode(struct SlideListItem)]];
	self = [self initWithSlideListItems:items];
	CCLabelTTF* topLabel = [CCLabelTTF labelWithString:@"Character Select" fontName:@"Marker Felt" fontSize:24];
	[topLabel setColor:(ccColor3B){50,50,50}];
	topLabel.position = ccp(90,screenSize.height-15);
	[self addChild:topLabel z:6];
	return self;
}
@end
