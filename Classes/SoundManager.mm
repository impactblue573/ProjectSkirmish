//
//  SoundManager.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 19/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "SoundManager.h"
#import "GameScene.h"

static bool enabled = true;

@implementation SoundManager
static SoundManager* sharedSoundManager;

+(SoundManager*) sharedManager
{
	if(sharedSoundManager == nil)
		sharedSoundManager = [[SoundManager alloc] init];
	return sharedSoundManager;
}

-(void) preloadSound:(NSString*)sound
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:sound];
}

-(void) playSound:(NSString *)sound atPosition:(CGPoint)position
{
	if(!enabled)
		return;
	ViewPort vp = [GameScene getViewPort];
	CGPoint center = ccp(vp.position.x + vp.dimensions.width/2,vp.position.y + vp.dimensions.height/2);
	float deltaX = position.x - center.x;
	if(fabsf(deltaX) <= vp.dimensions.width * 1.5)
	{
		float gain = fabsf(deltaX) < vp.dimensions.width ? 1 : (fabs(deltaX) - vp.dimensions.width) / vp.dimensions.width; 
		float pan = deltaX / vp.dimensions.width;
		if(pan < -1)
			pan = -1;
		if(pan > 1)
			pan = 1;
		[[SimpleAudioEngine sharedEngine] playEffect:sound pitch:1 pan:pan gain:gain];
	}	
}

-(void) playBackgroundMusic:(NSString*)music
{
    if(!enabled)
        return;
    if(!currentBackgroundMusic || ![music isEqualToString:currentBackgroundMusic])
    {
        [currentBackgroundMusic release];
        currentBackgroundMusic = [[NSString stringWithString:music] retain];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:currentBackgroundMusic loop:true];
        [self fadeInBackgroundMusic:0.4];
    }
}

-(void) fadeInBackgroundMusic:(float)volume;
{
    backgroundVolume = volume;
    currentBackgroundVolume = 0;
    [[CCScheduler sharedScheduler] unscheduleSelector:@selector(increaseBackgroundVolume) forTarget:self];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
    [[CCScheduler sharedScheduler] scheduleSelector:@selector(increaseBackgroundVolume) forTarget:self interval:0.2 paused:false];
}

-(void) increaseBackgroundVolume
{
    currentBackgroundVolume += 0.05;
    if(currentBackgroundVolume >= backgroundVolume)
    {
        currentBackgroundVolume = backgroundVolume;
        [[CCScheduler sharedScheduler] unscheduleSelector:@selector(increaseBackgroundVolume) forTarget:self];
    }
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:currentBackgroundVolume];
}

-(void) dealloc
{
    [[CCScheduler sharedScheduler] unscheduleSelector:@selector(increaseBackgroundVolume) forTarget:self];
    [currentBackgroundMusic release];
    [super dealloc];
}
@end
