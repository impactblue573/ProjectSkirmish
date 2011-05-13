//
//  PorcusMaximusPawn.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 31/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PorcusMaximusPawn.h"


@implementation PorcusMaximusPawn

-(id) init
{
    self = [super init];
    size = b2Vec2(54.0f,80.0f);
    fireForce = 3.0f;
    fireDamage = 12;
    jumpSpeed = 12.0;
    maxSpeed = 5.0;
    jumpForceMag = 3000.0;
    pawnType = @"Porcus Maximus";
    
    //apply randomisation to alternate costumer
    int rand = arc4random()%100;
    if(rand > 50)
    {
        [self setVariation:1]; 
    }
    else
    {
        [self setVariation:2]; 
    }
    return self;
}

-(void) setVariation:(int)variation
{
    [super setVariation:variation];
    switch(spriteVariation)
    {
        case 1:
            spriteName = @"PorcusMaximusAlternate";
            gunOffset = CGPointMake(-14.0,-11.0);
            offset = b2Vec2(0.0f,-6.0f);  
            break;
        default:
        case 2:
            spriteVariation = 1;
            spriteName = @"PorcusMaximus";
            gunOffset = CGPointMake(-14.0,-16.0);
            offset = b2Vec2(0.0f,-14.0f);  
    }
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
