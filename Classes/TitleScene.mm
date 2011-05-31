//
//  TitleScene.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "TitleScene.h"
#import "SoundManager.h"

@implementation TitleScene

+(id) scene
{
	CCScene* scene = [CCScene node];
	TitleScene* titleScene = [TitleScene node];
	[scene addChild:titleScene];
	return scene;
}

-(id) init
{
	if((self = [super init]))
	{
		CGSize screensize = [CCDirector sharedDirector].winSize;
		CCMenuItemImage* singlePlayMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"SinglePlay.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"SinglePlayActive.png"] target:self selector:@selector(singlePlayMenuTouched:)];
        singlePlayMenu.selectedImage.position = ccp(-15,-3);
		CCMenuItemImage* localPlayMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MultiPlay.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MultiPlayActive.png"] target:self selector:@selector(localPlayMenuTouched:)]; 
        localPlayMenu.position = ccp(0,-50);
        localPlayMenu.selectedImage.position = ccp(-15,-3);
		CCMenu* titleMenu = [CCMenu menuWithItems:singlePlayMenu,localPlayMenu,nil];
		titleMenu.position = ccp(screensize.width/2,screensize.height/2);
        CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"MainScreenBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background];
		[self addChild:titleMenu];
        [[SoundManager sharedManager] playBackgroundMusic:@"Twinkle.aif"];
	}
	return self;
}

-(void) singlePlayMenuTouched:(id) sender
{	
	[[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Single]];
}

-(void) onlinePlayMenuTouched:(id) sender
{	
	[[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Online]];
}

-(void) localPlayMenuTouched:(id) sender
{
	[[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Local]];
}
@end
