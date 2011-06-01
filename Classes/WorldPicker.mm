//
//  WorldPicker.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "WorldPicker.h"


@implementation WorldPicker

-(id) init
{
	NSMutableArray* items = [NSMutableArray array];
	SlideListItem item = (SlideListItem){@"TheFarmProfile.png",@"Farm_World",@"The Farm"};
	[items addObject:[NSValue value:&item withObjCType:@encode(struct SlideListItem)]];
	self = [self initWithSlideListItems:items];
//	CCLabelTTF* topLabel = [CCLabelTTF labelWithString:@"World Select" fontName:@"Marker Felt" fontSize:24];
//	[topLabel setColor:(ccColor3B){50,50,50}];
//	topLabel.position = ccp(70,screenSize.height-15);
//	[self addChild:topLabel z:6];
	return self;
}

@end
