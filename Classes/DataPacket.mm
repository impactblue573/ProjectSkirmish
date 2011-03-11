//
//  DataPacket.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "DataPacket.h"

@implementation DataPacket

@synthesize dataType, pawnInitData, playerInput, matchInfo,sendTime;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	NSValue* dataTypeVal = [NSValue valueWithBytes:&dataType objCType:@encode(DataType)];
	[aCoder encodeObject:dataTypeVal];
	if(dataType == Data_InitPawnResponse || dataType == Data_SynchPawnRequest)
		[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:pawnInitData]];	
	if(dataType == Data_PawnUpdate)
	{
		[aCoder encodeObject:playerInput];	
		//[aCoder encodeObject:sendTime];
		//[aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:playerInputs]];
	}
	if(dataType == Data_MatchUpdate)
		[aCoder encodeObject:matchInfo];
}
	 
- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSValue* dataTypeVal = [aDecoder decodeObject];
	[dataTypeVal getValue:&dataType];
	if(dataType == Data_InitPawnResponse || dataType == Data_SynchPawnRequest)
	{ 
		pawnInitData = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[aDecoder decodeObject]];
		[pawnInitData retain];
	}
	if(dataType == Data_PawnUpdate)
	{
		playerInput = [aDecoder decodeObject];
		[playerInput retain];		
		//sendTime = [[aDecoder decodeObject] retain];
		//playerInputs = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObject]];
//		[playerInputs retain];
	}
	if(dataType == Data_MatchUpdate)
	{
		matchInfo = [aDecoder decodeObject];
		[matchInfo retain];
	}
	
	return self;
}

/*-(void) dealloc
{
	//[pawnInitData release];
	//[playerInput release];
	//[matchInfo release];
	[super dealloc];
}*/
	 
@end