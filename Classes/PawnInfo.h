//
//  PawnInfo.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 7/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PawnInfo : NSObject <NSCoding> {
	NSString* pawnType;
	NSNumber* teamID;
    NSNumber* spriteVariation;
	NSString* playerID;
	NSString* playerName;
}

@property(assign) NSString* pawnType;
@property(assign) NSString* playerID;
@property(assign) NSNumber* teamID;
@property(assign) NSString* playerName;
@property(assign) NSNumber* spriteVariation;
@end
