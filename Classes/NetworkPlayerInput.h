//
//  NetworkPlayerInput.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkPlayerInput : NSObject <NSCoding> {
	/*bool hasMove;
	bool hasShoot;
	bool hasJump;
	bool hasSyncPosition;
	CGPoint moveVector;
	CGPoint shootPoint;
	CGPoint position;
	CGPoint velocity;
	NSString* playerID;
	float health;*/
	NSNumber* hasJump;
	NSNumber* positionX;
	NSNumber* positionY;
	NSNumber* velocityX;
	NSNumber* velocityY;
	NSNumber* shootPointX;
	NSNumber* shootPointY;
	NSNumber* moveVector;
	NSNumber* health;
	NSString* playerID;
}

/*@property(assign) bool hasMove,hasShoot,hasJump,hasSyncPosition;
@property(assign) CGPoint moveVector,shootPoint,position,velocity;
@property (assign) float health;*/
@property(assign) NSNumber* hasJump;
@property(assign) NSNumber* positionX;
@property(assign) NSNumber* positionY;
@property(assign) NSNumber* velocityX;
@property(assign) NSNumber* velocityY;
@property(assign) NSNumber* shootPointX;
@property(assign) NSNumber* shootPointY;
@property(assign) NSNumber* moveVector;
@property(assign) NSNumber* health;
@property(assign) NSString* playerID;
@end
