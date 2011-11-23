//
//  TeamDeathmatch.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 2/03/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameType.h"

@interface TeamDeathmatch : GameType {
	NSInteger winScore;
}

-(id) initWithWinScore:(NSInteger)score numBots:(uint)bots;

@end
