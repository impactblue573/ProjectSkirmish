//
//  SoundManager.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 19/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "SoundManager.h"
#import "GameScene.h"


@implementation SoundManager
static SoundManager* sharedSoundManager;

+(SoundManager*) sharedManager
{
	if(sharedSoundManager == nil)
		sharedSoundManager = [[SoundManager alloc] init];
	return sharedSoundManager;
}

-(void) playSound:(NSString *)sound atPosition:(CGPoint)position
{
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
@end
