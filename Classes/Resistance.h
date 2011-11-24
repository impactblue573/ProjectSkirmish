//
//  Resistance.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameType.h"

@interface Resistance : GameType {
@private
    NSDate* startDate;
    uint botScore;
}

@end
