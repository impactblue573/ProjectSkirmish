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
    bool releaseProperties;
}

@property(retain) NSString* pawnType;
@property(retain) NSString* playerID;
@property(retain) NSNumber* teamID;
@property(retain) NSString* playerName;
@property(retain) NSNumber* spriteVariation;
@end
