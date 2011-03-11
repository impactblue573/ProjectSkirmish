//
//  GameCamera.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameCamera.h"


@implementation GameCamera

@synthesize position;
@synthesize target;

-(id) initToViewportSize:(CGSize)vpSize WorldSize:(CGSize)wSize Position:(CGPoint)pos
{
	viewportSize = vpSize;
	worldSize = wSize;
	position = pos;
	return self;
}

-(void) updatePosition
{
	float maxX = 0;
	float minX = -worldSize.width + viewportSize.width;
	float maxY = 0;
	float minY = -worldSize.height + viewportSize.height;
	
	position.x = clampf(-target.position.x + viewportSize.width/2,minX,maxX);	
	position.y = clampf(-target.position.y + viewportSize.height/2,minY,maxY);
}

@end
