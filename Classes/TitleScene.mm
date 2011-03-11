//
//  TitleScene.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "TitleScene.h"


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
		[CCMenuItemFont setFontName:@"Marker Felt"]; 
		[CCMenuItemFont setFontSize:32];
		CCMenuItemFont* singlePlayMenu = [CCMenuItemFont itemFromString:@"Single Play" target:self selector:@selector(singlePlayMenuTouched:)]; 
		singlePlayMenu.position = ccp(0,50);
		CCMenuItemFont* localPlayMenu = [CCMenuItemFont itemFromString:@"Local Play" target:self selector:@selector(localPlayMenuTouched:)]; 
		CCMenuItemFont* onlinePlayMenu = [CCMenuItemFont itemFromString:@"Online Play" target:self selector:@selector(onlinePlayMenuTouched:)]; 
		onlinePlayMenu.position = ccp(0,-50);
		CCMenu* titleMenu = [CCMenu menuWithItems:singlePlayMenu,localPlayMenu,nil];
		titleMenu.position = ccp(screensize.width/2,screensize.height/2);
		[self addChild:titleMenu];
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
