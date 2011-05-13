//
//  DataPacket.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkPlayerInput.h"
#import "MatchInfo.h"
#import "PowerupEvent.h"

typedef enum
{
	Data_InitPawnRequest = 1,
	Data_InitPawnResponse = 2,
	Data_SynchPawnRequest = 3,
	Data_SynchPawnResponse = 4,
	Data_StartGame = 5,
	Data_PawnUpdate = 6,
	Data_MatchUpdate,
	Data_Ping,
	Data_PingResponse,
    Data_PowerupEvent,
} DataType;

@interface DataPacket : NSObject<NSCoding> {

	DataType dataType;
	NSDate* sendTime;
	NSMutableArray* pawnInitData;
	NetworkPlayerInput* playerInput;
	NSString* worldName;
	MatchInfo* matchInfo;
    PowerupEvent* powerupEvent;
	int pingID;
}

@property(assign) DataType dataType;
@property(assign) NSMutableArray* pawnInitData;
@property(assign) NetworkPlayerInput* playerInput;
@property(assign) MatchInfo* matchInfo;
@property(assign) NSDate* sendTime;
@property(assign) NSString* worldName;
@property(assign) int pingID;
@property(assign) PowerupEvent* powerupEvent;
//@property(assign) NSMutableArray* playerInputs;

@end
