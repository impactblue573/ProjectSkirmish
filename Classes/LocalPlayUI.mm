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
		CCMenuItemImage* hostGameMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Host.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"HostActive.png"] target:self selector:@selector(hostGameMenuTouched:)]; 
		hostGameMenu.selectedImage.position = ccp(-10,-3);
		CCMenuItemImage* joinGameMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Join.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"JoinActive.png"] target:self selector:@selector(joinGameMenuTouched:)]; 
		joinGameMenu.position = ccp(0,-50);
        joinGameMenu.selectedImage.position = ccp(-10,-3);
        CCMenuItemImage* quitMenu = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Quit.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"QuitActive.png"] target:self selector:@selector(quitMenuTouched:)]; 
		quitMenu.position = ccp(0,-100);
        quitMenu.selectedImage.position = ccp(-10,-3);
		CCMenu* localPlayMenu = [CCMenu menuWithItems:hostGameMenu,joinGameMenu,quitMenu,nil];
		localPlayMenu.position = ccp(screensize.width/2,screensize.height/2);
		mainMenuLayer = [[CCLayer node] retain];
		[mainMenuLayer addChild:localPlayMenu];
		
		//Init Lobby Menu
		
		//Misc Stuff
		cancelMenuItem = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Close.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"CloseActive.png"] target:self selector:@selector(cancelMenuTouched:)];
 		cancelMenuItem.position = ccp(50 - screensize.width/2,screensize.height/2 - 88);
        cancelMenuItem.selectedImage.position = ccp(-3,-3);
		startMenuItem = [[CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Play.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"PlayActive.png"] target:self selector:@selector(startMenuTouched:)] retain]; 
		startMenuItem.position = ccp(screensize.width/2 - 60,-30 -screensize.height/2);
        startMenuItem.selectedImage.position = ccp(-10,-5);
		pendingGameMenu = [CCMenu menuWithItems:cancelMenuItem,nil];
		pendingGameMenu.position = ccp(screensize.width/2,screensize.height - 100);		
		pendingGameLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
		pendingGameLabel.position = ccp(screensize.width/2,screensize.height * 0.9);
		
		[CCMenuItemFont setFontSize:22];
		
		//Player Name
		CCLabelTTF* playerLabel = [[CCLabelTTF labelWithString:@"Player Name:" dimensions:CGSizeMake(200,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:22] retain];
		playerLabel.position = ccp(screensize.width * 0.05 + 100,screensize.height * 0.65);
		playerTextField = [[[UITextField alloc] initWithFrame:CGRectMake(screensize.height * 0.65 - 100, screensize.width * 0.05 + 220,200, 30)] retain];
		playerTextField.transform = CGAffineTransformMakeRotation(M_PI * (90.0 / 180.0));
		playerTextField.delegate = self;
		playerTextField.returnKeyType = UIReturnKeyDone;        
		[playerTextField setText:appDelegate.playerName];
		[playerTextField setTextColor:[UIColor whiteColor]];
		[playerTextField setFont:[UIFont fontWithName:@"Marker Felt" size:22]];
		
		//World Select
		worldPicker = [[[WorldPicker alloc] init] retain];
		[worldPicker setTarget:self selector:@selector(onWorldSelect:)];
		worldLabel = [[CCLabelTTF labelWithString:@"World:" dimensions:CGSizeMake(200,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:22] retain];
		worldLabel.position = ccp(screensize.width * 0.05,screensize.height * 0.2);
		worldLabel.anchorPoint = ccp(0,0.5);
        worldLauncher = [CCMenuItemFont itemFromString:@"The Farm" target:self selector:@selector(launchWorldSelector:)];
		worldLauncher.anchorPoint = ccp(0,0.5);
		worldLauncherMenu = [[CCMenu menuWithItems:worldLauncher,nil] retain];
		worldLauncherMenu.position = ccp(screensize.width * 0.05 + 120,screensize.height * 0.2);
		selectedWorld = @"Farm_World";
		
		//Num Bot Scroller
		botLabel = [[CCLabelTTF labelWithString:@"Num Bots:" dimensions:CGSizeMake(200,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:22] retain];
		botLabel.position = ccp(screensize.width * 0.05,screensize.height * 0.1);
		botLabel.anchorPoint = ccp(0,0.5);
        botDial = [[[DialList alloc] initWithList:[NSArray arrayWithObjects: @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil] withWidth:70] retain];
		botDial.position = ccp(screensize.width * 0.05 + 120,screensize.height * 0.1);
		
		//team select
		CCLabelTTF* teamLabel = [CCLabelTTF labelWithString:@"Team:" dimensions:CGSizeMake(100,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:22];
		teamLabel.position = ccp(screensize.width * 0.05 + 50,screensize.height * 0.35);
		teamAButton = [CCMenuItemFont itemFromString:@"Team A" target:self selector:@selector(toggleTeam:)];	
		teamAButton.position = ccp(0,0);
		selectedTeam = 1;
		[teamAButton setColor:ccWHITE];
		teamBButton = [CCMenuItemFont itemFromString:@"Team B" target:self selector:@selector(toggleTeam:)];
		teamBButton.position = ccp(80,0);
		[teamBButton setColor:ccGRAY];
		CCMenu* teamMenu = [CCMenu menuWithItems:teamAButton,teamBButton,nil];
        teamMenu.anchorPoint = ccp(0,0.5);
		teamMenu.position = ccp(screensize.width * 0.05 + 120,screensize.height * 0.35);
		
		//character select
		characterPicker = [[[CharacterPicker alloc] init] retain];
		[characterPicker setTarget:self selector:@selector(onCharacterSelect:)];
		
		CCLabelTTF* characterLabel = [CCLabelTTF labelWithString:@"Character:" dimensions:CGSizeMake(100,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:22];
		characterLabel.position = ccp(screensize.width * 0.05 + 50,screensize.height * 0.45);
		characterLauncher = [CCMenuItemFont itemFromString:@"Lambo" target:self selector:@selector(launchCharacterSelector:)];
		characterLauncher.anchorPoint = ccp(0,0.5);
		CCMenu* characterLauncherMenu = [CCMenu menuWithItems:characterLauncher,nil];
		characterLauncherMenu.position = ccp(screensize.width * 0.05 + 120,screensize.height * 0.45 + 3);
        characterLauncherMenu.anchorPoint = ccp(0,0.5);
		selectedCharacter = @"Lambo";
		
		playersJoinedLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(screensize.width,30) alignment:CCTextAlignmentLeft fontName:@"Marker Felt" fontSize:24];
		playersJoinedLabel.position = ccp(screensize.width * 0.05,screensize.height * 0.75);
		playersJoinedLabel.anchorPoint = ccp(0,0.5);
        pendingGameMenuLayer = [[CCLayer node] retain];
		
        
        //backgrounds
        backgrounds = [[NSMutableArray array] retain];
        CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"MainScreenBackground.png"];
        background.position = ccp(240,160);        
        [backgrounds addObject:background];
        [self addChild:background];

        background = [CCSprite spriteWithSpriteFrameName:@"LobbyBackground.png"];
        background.position = ccp(240,160);  
        background.visible = false;
        [backgrounds addObject:background];
        [self addChild:background];

		[pendingGameMenuLayer addChild:pendingGameLabel];
		[pendingGameMenuLayer addChild:pendingGameMenu];
		[pendingGameMenuLayer addChild:playersJoinedLabel];
		[pendingGameMenuLayer addChild:playerLabel];
		[pendingGameMenuLayer addChild:teamLabel];
		[pendingGameMenuLayer addChild:teamMenu];
		[pendingGameMenuLayer addChild:characterLabel];
		[pendingGameMenuLayer addChild:characterLauncherMenu];
        [pendingGameMenuLayer addChild:botLabel];
        [pendingGameMenuLayer addChild:botDial];
        [pendingGameMenuLayer addChild:worldLabel];
        [pendingGameMenuLayer addChild:worldLauncherMenu];
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
		[pendingGameMenu removeChild:startMenuItem cleanup:true];

}

-(void) setPendingText:(NSString*)text
{
	[pendingGameLabel setString:text];
}

-(void) showMainMenu
{
	[self removeChild:pendingGameMenuLayer cleanup:false];
	[self addChild:mainMenuLayer];
    [self showBackground:0];
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
        botLabel.visible = TRUE;
        botDial.visible = TRUE;
	}
	else {
        botLabel.visible = FALSE;
        botDial.visible = FALSE;
	}
}

-(void) showWorld:(bool)show
{
	if(show)
	{
        worldLabel.visible = TRUE;
        worldLauncherMenu.visible = TRUE;
	}
	else {
        worldLabel.visible = FALSE;
        worldLauncherMenu.visible = FALSE;
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

-(void) showBackground:(uint)index
{
    //hide all
    for(uint i = 0; i < [backgrounds count]; i++)
    {
        CCSprite* background = [backgrounds objectAtIndex:i];

        if(i == index)
        {
            background.visible = true;
        }
        else
        {
            background.visible = false;
        }
    }
}

-(void) dealloc
{
	[botDial release];
	[botLabel release];
	[startMenuItem release];	
	[mainMenuLayer release];
	[pendingGameMenuLayer release];
//    for(uint i = 0; i < [backgrounds count];i++)
//    {
//        [[backgrounds objectAtIndex:i] release];
//    }
    [backgrounds release];
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
