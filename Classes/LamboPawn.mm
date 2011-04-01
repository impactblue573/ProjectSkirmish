//
//  LamboPawn.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 25/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "LamboPawn.h"


@implementation LamboPawn


-(id) init
{
	//use default values for now
	if((self = [super init]))
	{
		gunOffset = CGPointMake(-14.0,-16.0);
		size = b2Vec2(54.0f,80.0f);
		offset = b2Vec2(0.0f,-7.0f);
		spriteName = @"Lambo";
		pawnType = @"Lambo";
	}
	return self;
}

-(void) initializeJumpAnimation:(AnimationManager*)animationManager
{
	//Jump Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Default.png",@"Jump-1.png",@"Jump-2.png",@"Jump-3.png",nil];
	[animationManager addAnimation:@"Jump" usingFrames:frameNames frameDelay:0.05];
}

-(void) initializeFallAnimation:(AnimationManager*)animationManager
{
	//Fall Animation
	NSArray* frameNames = [NSArray arrayWithObjects:@"Fall-1.png",@"Fall-2.png",@"Fall-3.png",nil];
	[animationManager addAnimation:@"Fall" usingFrames:frameNames frameDelay:0.1];
}
@end
