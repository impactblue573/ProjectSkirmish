//
//  LoadManager.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadManager.h"
#import "ScoreManager.h"
#import "TitleScene.h"
#import "SoundManager.h"

static LoadManager* sharedLoadManager;

@implementation LoadManager

+(id) sharedLoadManager{
    if(sharedLoadManager == nil)
        sharedLoadManager = [[LoadManager alloc] init];
    return sharedLoadManager;
}

-(void) startLoad{
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"UI.plist"];
    
    loadingScreen = [[[LoadingScreen alloc] init] autorelease];
    loadingScene = [CCScene node];
    [loadingScene addChild:loadingScreen];
    [[CCDirector sharedDirector] runWithScene:loadingScene];
    [self cacheSounds];
}

-(void) cacheSounds{
    [self unschedule:@selector(cacheSounds)];
    [[SoundManager sharedManager] preloadSound:@"Twinkle.mp3"];
    [loadingScreen setProgress:50];
    [[CCScheduler sharedScheduler] scheduleSelector:@selector(loadScores) forTarget:self interval:0.5 paused:false];
}

-(void) loadScores{
    [self unschedule:@selector(loadScores)];
    [[ScoreManager sharedScoreManager] LoadScores];
    [loadingScreen setProgress:100];
    [[CCScheduler sharedScheduler] scheduleSelector:@selector(finishLoad) forTarget:self interval:1.0 paused:false];
}

-(void) finishLoad{
    [self unschedule:@selector(finishLoad)];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]];
}


@end
