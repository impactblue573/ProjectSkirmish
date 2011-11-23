//
//  GameTypeBot.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 22/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameTypeBot : NSObject {
@private
    
}

@property(retain) NSString* pawnType;
@property(retain) NSString* ai;
@property(assign) int team;
@property(assign) float handicap;
@property(assign) float x;
@property(assign) float y;


@end
