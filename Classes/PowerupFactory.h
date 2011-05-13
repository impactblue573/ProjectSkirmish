//
//  PowerupFactory.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 9/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "Powerup.h"

typedef enum PowerupType
{
    Random = 0,
    Protein = 1,
    Wings = 2,
    Windwalk = 3,
    
} PowerupType;

typedef enum PowerupState
{
    Active = 0,
    Activating = 1,
    Deactive = 2,
    Equiping = 3,
    Deactivating = 4
} PowerupState;
                                
@interface PowerupFactory : NSObject {
    PowerupType powerupType;
    float respawnTime;
    float deactiveTime;
    CGSize size;
    PowerupState state;
    b2Body* physicsBody;
    NSString* spriteName;
    CGPoint position;
    CCSprite* sprite;
    int angularDirection;
    int verticalDirection;
    float angularVelocity;
    float verticalVelocity;
    float verticalDelta;
    float opacityVelocity;
    float scaleVelocity;
    int powerupId;
    bool isDummy;
}

@property(assign) b2Body* physicsBody;
@property(readonly) CGSize size;
@property(assign) PowerupState state;
@property(readonly) CCSprite* sprite;
@property(readonly) CGPoint position;
@property(readonly) float deactiveTime;
@property(readonly) int powerupId;

+(PowerupType) parsePowerupType:(NSString*)pType;
-(void) step:(ccTime)dt;
-(Powerup*) getPowerup;
-(id) initWithPowerupType:(PowerupType)pType spriteName:(NSString*)sName position:(CGPoint)pos withID:(int)pId isDummy:(bool)dummy;
-(void) animate:(ccTime)dt;
-(void) animateEquip:(ccTime)dt;
-(void) reset;
@end
