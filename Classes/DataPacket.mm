//
//  DataPacket.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "DataPacket.h"

@implementation DataPacket

@synthesize dataType, pawnInitData, playerInput, matchInfo,sendTime,worldName,pingID,powerupEvent;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	NSValue* dataTypeVal = [NSValue valueWithBytes:&dataType objCType:@encode(DataType)];
	[aCoder encodeObject:dataTypeVal];
	if(dataType == Data_InitPawnRequest)
		[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:worldName]];
	if(dataType == Data_InitPawnResponse || dataType == Data_SynchPawnRequest)
	{
		[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:pawnInitData]];	
	}
	if(dataType == Data_PawnUpdate)
	{
		[aCoder encodeObject:playerInput];	
		//[aCoder encodeObject:sendTime];
	}
	if(dataType == Data_MatchUpdate)
		[aCoder encodeObject:matchInfo];
	if(dataType == Data_Ping || dataType == Data_PingResponse)
		[aCoder encodeObject:[NSNumber numberWithInt:pingID]];
    if(dataType == Data_PowerupEvent)
        [aCoder encodeObject:powerupEvent];
}
	 
- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSValue* dataTypeVal = [aDecoder decodeObject];
	[dataTypeVal getValue:&dataType];
	if(dataType == Data_InitPawnRequest)
	{
		worldName = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[aDecoder decodeObject]];
		[worldName retain];
	}
	if(dataType == Data_InitPawnResponse || dataType == Data_SynchPawnRequest)
	{ 
		pawnInitData = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[aDecoder decodeObject]];
		[pawnInitData retain];
	}
	if(dataType == Data_PawnUpdate)
	{
		playerInput = [[aDecoder decodeObject] retain];
	}
	if(dataType == Data_MatchUpdate)
	{
		matchInfo = [aDecoder decodeObject];
		[matchInfo retain];
	}
	if(dataType == Data_Ping || dataType == Data_PingResponse)
		pingID = [[aDecoder decodeObject] intValue];
    if(dataType == Data_PowerupEvent)
        powerupEvent = [[aDecoder decodeObject] retain];
	
	return self;
}

-(void) dealloc
{
	[pawnInitData release];
	//[playerInput release];
	[matchInfo release];
	[super dealloc];
}
	 
@end