//
//  OnlinePlayUI.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "OnlinePlayUI.h"


@implementation OnlinePlayUI

@synthesize delegate;

-(id) init
{
	if((self = [super init]))
	{
		CGSize screensize = [CCDirector sharedDirector].winSize;
		[CCMenuItemFont setFontName:@"Marker Felt"]; 
		[CCMenuItemFont setFontSize:32];
		//Init Main Menu
		CCMenuItemFont* hostGameMenu = [CCMenuItemFont itemFromString:@"Host Game" target:self selector:@selector(hostGameMenuTouched:)]; 
		hostGameMenu.position = ccp(0,50);
		CCMenuItemFont* joinGameMenu = [CCMenuItemFont itemFromString:@"Join Game" target:self selector:@selector(joinGameMenuTouched:)]; 
		CCMenuItemFont* quitMenu = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(quitMenuTouched:)]; 
		quitMenu.position = ccp(0,-50);
		CCMenu* onlinePlayMenu = [CCMenu menuWithItems:hostGameMenu,joinGameMenu,quitMenu,nil];
		onlinePlayMenu.position = ccp(screensize.width/2,screensize.height/2);
		mainMenu = [[CCLayer node] retain];
		[mainMenu addChild:onlinePlayMenu];
		
		//Init Joining Game Menu
		CCMenuItemFont* cancelMenu = [CCMenuItemFont itemFromString:@"Cancel" target:self selector:@selector(cancelMenuTouched:)]; 
		CCMenu* cancelGameMenu = [CCMenu menuWithItems:cancelMenu,nil];
		cancelGameMenu.position = ccp(screensize.width/2,screensize.height/2 - 50);
		
		CCLabelTTF* joiningLabel = [CCLabelTTF labelWithString:@"Finding games..." fontName:@"Marker Felt" fontSize:32];
		joiningLabel.position = ccp(screensize.width/2,screensize.height/2);
		joiningGameMenu = [[CCLayer node] retain];
		[joiningGameMenu addChild:joiningLabel];
		[joiningGameMenu addChild:cancelGameMenu];
	}
	return self;
}

-(void) hostGameMenuTouched:(id) sender
{
	[delegate hostGame];
}

-(void) joinGameMenuTouched:(id) sender
{	
	[delegate joinGame];
}

-(void) quitMenuTouched:(id) sender
{
	[delegate quitGame];
}

-(void) cancelMenuTouched:(id)sender
{
	[delegate cancelJoinGame];
}

-(void) showJoiningMenu
{
	[self removeChild:mainMenu cleanup:false];
	[self addChild:joiningGameMenu];
}

-(void) showMainMenu
{
	[self removeChild:joiningGameMenu cleanup:false];
	[self addChild:mainMenu];
}
@end
