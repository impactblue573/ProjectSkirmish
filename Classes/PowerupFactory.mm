//
//  PowerupFactory.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 9/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupFactory.h"
#import "ProteinPowerup.h"
#import "WingsPowerup.h"
#import "WindwalkPowerup.h"

@implementation PowerupFactory

@synthesize physicsBody, size, state,sprite,position,deactiveTime,powerupId;

+(PowerupType) parsePowerupType:(NSString *)pType
{
    if([pType isEqualToString:@"Protein"])
    {
        return Protein;
    }
    else if([pType isEqualToString:@"Wings"])
    {
        return Wings;
    }
    else if( [pType isEqualToString:@"Windwalk"])
    {
        return Windwalk;
    }
    return Random;
}

-(id) initWithPowerupType:(PowerupType)pType spriteName:(NSString*)sName position:(CGPoint)pos withID:(int)pId isDummy:(bool)dummy
{
    self = [super init];
    powerupId = pId;
    powerupType = pType;
    respawnTime = 20.0;
    deactiveTime = 0.0;
    size = CGSizeMake(20.0f, 20.0f);
    angularDirection = 1;
    verticalDirection = 1;
    angularVelocity = 30;
    verticalVelocity = 30;
    opacityVelocity = 500.0;
    scaleVelocity = 4.0;
    state = Active;
    position = pos;
    spriteName = [[NSString stringWithString:sName] retain];
    sprite = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
//    sprite = [[CCSprite spriteWithFile:spriteName] retain];
//    [sprite.texture setAntiAliasTexParameters];
    isDummy = dummy;
    return self;
}

-(Powerup*) getPowerup
{
    if(state == Active)
    {
        state = Equiping;
    
        switch(powerupType)
        {
            case Protein:
                return [[[ProteinPowerup alloc] init] autorelease];
                break;
            case Wings:
                return [[[WingsPowerup alloc] init] autorelease];
                break;
            case Windwalk:
                return [[[WindwalkPowerup alloc] init] autorelease];
            default:
                return [[[Powerup alloc] init] autorelease];
        }
    }   
    return nil;
}

-(void) reset
{
    if(state == Deactive)
    {
        deactiveTime = 0;
        sprite.rotation = 0;
        sprite.position = position;
        sprite.opacity = 255;
        sprite.scale = 1;
        angularDirection = 1;
        verticalDirection = 1;
        state = Activating;
    }
}

-(void) step:(ccTime)dt
{
    switch(state)
    {
        case Deactive:
            if(!isDummy)
            {
                deactiveTime += dt;
                if(deactiveTime >= respawnTime)
                {
                    [self reset];   
                }
            }
            break;
        case Active:
            [self animate:dt];
            break;
        case Equiping:
            [self animateEquip:dt];
        default:
            break;
    }    
}

-(void) animateEquip:(ccTime)dt
{
    float opacityDelta = dt * opacityVelocity;
    if(sprite.opacity <= opacityDelta)
    {
        state = Deactivating;
    }
    else
    {
        sprite.opacity -= opacityDelta;
        sprite.scale += dt * scaleVelocity;
    }
}

-(void) animate:(ccTime)dt
{
    if(fabs(sprite.rotation) > 10)
    {
        angularDirection *=  -1;
        sprite.rotation = sprite.rotation > 10 ? 10: -10;
    }
    else
    {
        sprite.rotation += dt * angularDirection * angularVelocity;   
    }
    if(fabs(verticalDelta) > 5)
    {
        verticalDirection *=  -1;
        verticalDelta = verticalDelta > 5 ? 5 : -5;       
    }
    else
    {
        verticalDelta += dt * verticalDirection * verticalVelocity;
        sprite.position = CGPointMake(position.x, position.y + verticalDelta);
    }
}

-(void) dealloc
{
    [spriteName release];
    [sprite release];
    [super dealloc];
}
@end
