//
//  TitleScene.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "TitleScene.h"
#import "SoundManager.h"
#import "Toggler.h"
#import "ScoreManager.h"
#import "LevelPicker.h"

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
		titleMenu = [CCMenu menuWithItems:singlePlayMenu,localPlayMenu,nil];
		titleMenu.position = ccp(screensize.width/2,screensize.height/2);
        
        CCMenuItemImage* skirmishMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Skirmish.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"SkirmishActive.png"] target:self selector:@selector(skirmishTouched:)];
        skirmishMenu.selectedImage.position = ccp(-15,-3);
        CCMenuItemImage* infiltrationMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Infiltration.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"InfiltrationActive.png"] target:self selector:@selector(infiltrationTouched:)];
        infiltrationMenu.selectedImage.position = ccp(-15,-3);
        infiltrationMenu.position = ccp(0,-50);
        CCMenuItemImage* resistanceMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Resistance.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ResistanceActive.png"] target:self selector:@selector(resistanceTouched:)];
        resistanceMenu.selectedImage.position = ccp(-15,-3);
        resistanceMenu.position = ccp(0,-100);
        CCMenuItemImage* backMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Quit.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"QuitActive.png"] target:self selector:@selector(backTouched:)];
        backMenu.selectedImage.position = ccp(-15,-3);
        backMenu.position = ccp(0,-150);
        gameTypeMenu = [CCMenu menuWithItems:skirmishMenu,infiltrationMenu,resistanceMenu,backMenu,nil];
        gameTypeMenu.position = ccp(screensize.width/2,screensize.height/2 + 20);
        [gameTypeMenu setVisible:false];

        
        CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"MainScreenBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background];
		[self addChild:titleMenu];
        [self addChild:gameTypeMenu];
        [[SoundManager sharedManager] playBackgroundMusic:@"Twinkle.mp3"];
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper]; 
        [gkHelper authenticateLocalPlayer];
	}
	return self;
}

-(void) singlePlayMenuTouched:(id) sender
{	
    [gameTypeMenu setVisible:true];
    [titleMenu setVisible:false];
}

-(void) skirmishTouched:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Single gameType:GameType_TeamDeathmatch]];
}

-(void) infiltrationTouched:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Single gameType:GameType_Infiltration]];
}

-(void) resistanceTouched:(id)sender{
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Single gameType:GameType_Resistance]];

}

-(void) backTouched:(id)sender{
    [titleMenu setVisible:true];
    [gameTypeMenu setVisible:false];
}

-(void) onlinePlayMenuTouched:(id) sender
{	
	[[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Online gameType:GameType_TeamDeathmatch]];
}

-(void) localPlayMenuTouched:(id) sender
{
	[[CCDirector sharedDirector] replaceScene:[GameScene sceneWithGameMode:Game_Local gameType:GameType_TeamDeathmatch]];
}
@end
