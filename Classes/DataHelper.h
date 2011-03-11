//
//  DataHelper.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DataPacket.h"

@interface DataHelper : NSObject {

}

+(NSData*) serializeDataPacket:(DataPacket*)dataPacket;

+(DataPacket*) deserializeDataPacket:(NSData*)data;
@end
