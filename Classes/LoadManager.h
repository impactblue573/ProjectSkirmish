//
//  LoadManager.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingScreen.h"

@interface LoadManager : CCNode
{
    LoadingScreen* loadingScreen;
    CCScene* loadingScene;
}

+(id) sharedLoadManager;
-(void) startLoad;
-(void) cacheSounds;
-(void) loadScores;
-(void) finishLoad;
@end
