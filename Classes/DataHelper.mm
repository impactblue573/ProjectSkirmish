//
//  DataHelper.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "DataHelper.h"
#import "PawnInfo.h"

@implementation DataHelper


+(NSData*) serializeDataPacket:(DataPacket*)dataPacket
{	
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataPacket];
	return data;
}

+(DataPacket*) deserializeDataPacket:(NSData*)data
{
	DataPacket* packet = (DataPacket*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
	return packet;
}
@end
