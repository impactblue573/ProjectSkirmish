//
//  LocalPlayUI.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 6/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import "LocalPlayUI.h"
#import "ProjectSkirmishAppDelegate.h"

@implementation LocalPlayUI
@synthesize delegate;

-(id) init
{
	if((self = [super init]))
	{
        appDelegate = [UIApplication sharedApplication].delegate;
		CGSize screensize = [CCDirector sharedDirector].winSize;
		[CCMenuItemFont setFontName:@"Marker Felt"]; 
		[CCMenuItemFont setFontSize:32];
		//Init Main Menu
		CCMenuItemFont* hostGameMenu = [CCMenuItemFont itemFromString:@"Host Game" target:self selector:@selector(hostGameMenuTouched:)]; 
		hostGameMenu.position = ccp(0,50);
		CCMenuItemFont* joinGameMenu = [CCMenuItemFont itemFromString:@"Join Game" target:self selector:@selector(joinGameMenuTouched:)]; 
		CCMenuItemFont* quitMenu = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(quitMenuTouched:)]; 
		quitMenu.position = ccp(0,-50);
		CCMenu* localPlayMenu = [CCMenu menuWithItems:hostGameMenu,joinGameMenu,quitMenu,nil];
		localPlayMenu.position = ccp(screensize.width/2,screensize.height/2);
		mainMenuLayer = [[CCLayer node] retain];
		[mainMenuLayer addChild:localPlayMenu];
		
		//Init Lobby Menu
		
		//Misc Stuff
		cancelMenuItem = [CCMenuItemFont itemFromString:@"Cancel" target:self selector:@selector(cancelMenuTouched:)];
 		cancelMenuItem.position = ccp(0,0);
		startMenuItem = [[CCMenuItemFont itemFromString:@"Start" target:self selector:@selector(startMenuTouched:)] retain]; 
		startMenuItem.position = ccp(0,-30);
		pendingGameMenu = [CCMenu menuWithItems:cancelMenuItem,nil];
		pendingGameMenu.position = ccp(screensize.width/2,screensize.height - 100);		
		pendingGameLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
		pendingGameLabel.position = ccp(screensize.width/2,screensize.height - 70);
		
		[CCMenuItemFont setFontSize:22];
		
		//Player Name
		CCLabelTTF* playerLabel = [[CCLabelTTF labelWithString:@"Player Name:" dimensions:CGSizeMake(200,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:22] retain];
		playerLabel.position = ccp(screensize.width/2 + 60,screensize.height-30);
		playerTextField = [[[UITextField alloc] initWithFrame:CGRectMake(screensize.height/2 + 30, screensize.width-70,200, 30)] retain];
		playerTextField.transform = CGAffineTransformMakeRotation(M_PI * (90.0 / 180.0));
		playerTextField.delegate = self;
		playerTextField.returnKeyType = UIReturnKeyDone;        
		[playerTextField setText:appDelegate.playerName];
		[playerTextField setTextColor:[UIColor whiteColor]];
		[playerTextField setFont:[UIFont fontWithName:@"Marker Felt" size:22]];
		
		//World Select
		worldPicker = [[[WorldPicker alloc] init] retain];
		[worldPicker setTarget:self selector:@selector(onWorldSelect:)];
		worldLabel = [[CCLabelTTF labelWithString:@"World:" fontName:@"Marker Felt" fontSize:22] retain];
		worldLabel.position = ccp(34,120);
		worldLauncher = [CCMenuItemFont itemFromString:@"The Farm" target:self selector:@selector(launchWorldSelector:)];
		worldLauncher.anchorPoint = ccp(0,0.5);
		worldLauncherMenu = [[CCMenu menuWithItems:worldLauncher,nil] retain];
		worldLauncherMenu.position = ccp(110,120);
		selectedWorld = @"Farm_World";
		
		//Num Bot Scroller
		botLabel = [[CCLabelTTF labelWithString:@"Num Bots:" fontName:@"Marker Felt" fontSize:22] retain];
		botLabel.position = ccp(50,90);
		botDial = [[[DialList alloc] initWithList:[NSArray arrayWithObjects: @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil] withWidth:70] retain];
		botDial.position = ccp(140,90);
		
		//team select
		CCLabelTTF* teamLabel = [CCLabelTTF labelWithString:@"Team:" fontName:@"Marker Felt" fontSize:20];
		teamLabel.position = ccp(30,60);
		teamAButton = [CCMenuItemFont itemFromString:@"Team A" target:self selector:@selector(toggleTeam:)];	
		teamAButton.position = ccp(0,0);
		selectedTeam = 1;
		[teamAButton setColor:ccWHITE];
		teamBButton = [CCMenuItemFont itemFromString:@"Team B" target:self selector:@selector(toggleTeam:)];
		teamBButton.position = ccp(80,0);
		[teamBButton setColor:ccGRAY];
		CCMenu* teamMenu = [CCMenu menuWithItems:teamAButton,teamBButton,nil];
		teamMenu.position = ccp(140,60);
		
		//character select
		characterPicker = [[[CharacterPicker alloc] init] retain];
		[characterPicker setTarget:self selector:@selector(onCharacterSelect:)];
		
		CCLabelTTF* characterLabel = [CCLabelTTF labelWithString:@"Character:" fontName:@"Marker Felt" fontSize:22];
		characterLabel.position = ccp(54,30);
		characterLauncher = [CCMenuItemFont itemFromString:@"Lambo" target:self selector:@selector(launchCharacterSelector:)];
		characterLauncher.anchorPoint = ccp(0,0.5);
		CCMenu* characterLauncherMenu = [CCMenu menuWithItems:characterLauncher,nil];
		characterLauncherMenu.position = ccp(140,30);
		selectedCharacter = @"Lambo";
		
		playersJoinedLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(screensize.width,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:24];
		playersJoinedLabel.position = ccp(screensize.width/2,screensize.height-30);
		pendingGameMenuLayer = [[CCLayer node] retain];
		
		[pendingGameMenuLayer addChild:pendingGameLabel];
		[pendingGameMenuLayer addChild:pendingGameMenu];
		[pendingGameMenuLayer addChild:playersJoinedLabel];
		[pendingGameMenuLayer addChild:playerLabel];
		[pendingGameMenuLayer addChild:teamLabel];
		[pendingGameMenuLayer addChild:teamMenu];
		[pendingGameMenuLayer addChild:characterLabel];
		[pendingGameMenuLayer addChild:characterLauncherMenu];
	}
	return self;
}

-(void) setPlayersJoined:(int)num
{
	[playersJoinedLabel setString:[NSString stringWithFormat:@"%d players joined",num]];
}

-(void) setPlayersJoinedVisible:(bool)vis
{
	if(!vis)
		[playersJoinedLabel setString:@""];
}

-(void) showPlayerNameField:(bool)show
{
	if(show)
		[[[[CCDirector sharedDirector] openGLView] window] addSubview:playerTextField] ;
	else
		[playerTextField removeFromSuperview];
}

-(void) hostGameMenuTouched:(id) sender
{
	[self showPlayerNameField:true];
	[delegate hostGame];
}

-(void) joinGameMenuTouched:(id) sender
{
	[self showPlayerNameField:true];	
	[delegate joinGame];
}

-(void) quitMenuTouched:(id) sender
{
	[delegate quitGame];
}

-(void) cancelMenuTouched:(id)sender
{
	[self clearTextFields];
	[delegate cancelGame];
}

-(void) startMenuTouched:(id)sender
{
	[self clearTextFields];
	[delegate startGame];
}

-(void) showPendingMenu:(NSString*)text
{
	[pendingGameLabel setString:text];
	[self removeChild:mainMenuLayer cleanup:false];
	[self addChild:pendingGameMenuLayer];
}

-(void) setStartMenuVisible:(bool)isVisible
{
	if(isVisible)
	{
		CCNode* child = [pendingGameMenu getChildByTag:3];
		if(child == nil)
			[pendingGameMenu addChild:startMenuItem z:0 tag:3];
	}
	else 
		[pendingGameMenu removeChild:startMenuItem cleanup:false];

}

-(void) setPendingText:(NSString*)text
{
	[pendingGameLabel setString:text];
}

-(void) showMainMenu
{
	[self removeChild:pendingGameMenuLayer cleanup:false];
	[self addChild:mainMenuLayer];
}

-(void) toggleTeam:(id)sender
{
	if(sender == teamAButton)
	{
		selectedTeam = 1;
		[teamAButton setColor:ccWHITE];
		[teamBButton setColor:ccGRAY];
	}
	else {
		selectedTeam = 2;
		[teamAButton setColor:ccGRAY];
		[teamBButton setColor:ccWHITE];
	}
}

-(int) getSelectedTeam
{
	return selectedTeam;
}

-(void) launchCharacterSelector:(id)menuItem
{
	[self showPlayerNameField:false];
	[self addChild:characterPicker z:5];
}

-(void) launchWorldSelector:(id)menuItem
{
	[self showPlayerNameField:false];
	[self addChild:worldPicker z:5];
}

-(NSString*) getSelectedCharacter
{
	return selectedCharacter;
}

-(NSString*) getSelectedWorld
{
	return selectedWorld;
}

-(int) getNumBots
{
	return [[botDial getSelectedValue] intValue];
}

-(void) showBots:(bool)show
{
	if(show)
	{
		if([pendingGameMenuLayer getChildByTag:1] == nil)			
			[pendingGameMenuLayer addChild:botLabel z:0 tag:1];
		if([pendingGameMenuLayer getChildByTag:2] == nil)
			[pendingGameMenuLayer addChild:botDial z:0 tag:2];
	}
	else {
		[pendingGameMenuLayer removeChild:botLabel cleanup:false];
		[pendingGameMenuLayer removeChild:botDial cleanup:false];
	}
}

-(void) showWorld:(bool)show
{
	if(show)
	{
		if([pendingGameMenuLayer getChildByTag:3] == nil)			
			[pendingGameMenuLayer addChild:worldLabel z:0 tag:3];
		if([pendingGameMenuLayer getChildByTag:4] == nil)
			[pendingGameMenuLayer addChild:worldLauncherMenu z:0 tag:4];
	}
	else {
		[pendingGameMenuLayer removeChild:worldLabel cleanup:false];
		[pendingGameMenuLayer removeChild:worldLauncherMenu cleanup:false];
	}
}

-(NSString*) getPlayerName
{
	return playerTextField.text;
}

-(void) clearTextFields
{
	[self showPlayerNameField:false];
}

-(void) dealloc
{
	[botDial retain];
	[botLabel retain];
	[pendingGameLabel release];
	[playersJoinedLabel release];
	[cancelMenuItem release];
	[startMenuItem release];	
	[pendingGameMenu release];
	[mainMenuLayer release];
	[pendingGameMenuLayer release];
	[super dealloc];
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	if([textField.text length] > 0)
	{
		[textField resignFirstResponder];
        [appDelegate savePlayerName:textField.text];
		return true;
	}
	return false;
}

-(void) onCharacterSelect:(SlideListItem)item
{
	selectedCharacter = [NSString stringWithString:item.key];
	[characterLauncher setString:item.key];
	[self removeChild:characterPicker cleanup:false];
	[self showPlayerNameField:true];
}

-(void) onWorldSelect:(SlideListItem)item
{
	selectedWorld = [NSString stringWithString:item.key];
	[worldLauncher setString:item.text];
	[self removeChild:worldPicker cleanup:false];
	[self showPlayerNameField:true];
}

@end
