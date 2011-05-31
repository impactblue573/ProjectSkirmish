//
//  UILayer.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UILayer.h"

@implementation UILayer
@synthesize delegate;
-(id) init
{
	self = [super init];
	screenSize = [CCDirector sharedDirector].winSize;
    //Team 1 Score
	team1ScoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(50,50) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:32];
	[team1ScoreLabel setColor:ccc3(255,0,0)];
	team1ScoreLabel.position = ccp( screenSize.width/2-50, screenSize.height-30);
	[self addChild:team1ScoreLabel z:0];
	
    //Team 2 Score
	team2ScoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(50,50) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:32];
	[team2ScoreLabel setColor:ccc3(0,0,255)];
	team2ScoreLabel.position = ccp( screenSize.width/2+50, screenSize.height-30);
	[self addChild:team2ScoreLabel z:0];
	
    //Health
//	healthLabel = [CCLabelTTF labelWithString:@"+100" dimensions:CGSizeMake(80,50) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:32];
//	[healthLabel setColor:ccc3(0,100,0)];
//	healthLabel.position = ccp(40, screenSize.height-25);
    
    healthbar = [[[Healthbar alloc] initWithMaxValue:100 width:70 height:14] autorelease];
    healthbar.position = ccp(2,screenSize.height - 24);
    [self addChild:healthbar];
	//[self addChild:healthLabel z:0];
	
	pingLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(50,20) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
	pingLabel.position = ccp( screenSize.width-25, 10);
	[self addChild:pingLabel z:0];
	
	messageLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(screenSize.width,40) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:32];
	messageLabel.position = ccp(screenSize.width/2,screenSize.height/2 -20);
	[self addChild:messageLabel z:0];
	
	CCLabelTTF* pauseLabel = [CCLabelTTF labelWithString:@"Menu" fontName:@"Marker Felt" fontSize:20];
	[pauseLabel setColor:(ccColor3B){128,128,128}];
	CCMenuItemImage* pauseMenuItem = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Menu.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MenuActive.png"] target:self selector:@selector(showPauseMenu:)];	
	pauseMenuItem.selectedImage.position = ccp(-6,-4);
    pauseMenu = [CCMenu menuWithItems:pauseMenuItem,nil];
	pauseMenu.position = ccp(screenSize.width-30,screenSize.height-13);
	[self addChild:pauseMenu z:4];
	
	int menuWidth = screenSize.width - 80;
	resumeMenuItem = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Resume.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"ResumeActive.png"] target:self selector:@selector(hidePauseMenu:)];
	resumeMenuItem.selectedImage.position = ccp(-6,-2);
	resumeMenuItem.position = ccp(-50,0);
	CCMenuItemImage* quitMenuItem = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"QuitSmall.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"QuitSmallActive.png"] target:self selector:@selector(quitGame:)];
	quitMenuItem.selectedImage.position = ccp(-6,-2);
	quitMenuItem.position = ccp(50,0);
	gameMenu = [CCMenu menuWithItems:resumeMenuItem,quitMenuItem,nil];
	gameMenu.position = ccp(menuWidth/2,17);
	gameMenuParent = [[CCLayerColor layerWithColor:(ccColor4B){255,255,255,200} width:menuWidth height:34] retain];
	gameMenuParent.position = ccp(40,6);
	[gameMenuParent addChild:gameMenu];
	return self;
}

-(void) updateTeam1Score:(int)t1Score team2Score:(int)t2Score
{
	[team1ScoreLabel setString:[NSString stringWithFormat:@"%d",t1Score]];
	[team2ScoreLabel setString:[NSString stringWithFormat:@"%d",t2Score]];
}

-(void) updateHealth:(float)health
{
//	[healthLabel setColor:ccc3(200 * clampf((100.0f - health)/50.0f,0,1), 200 * fmin(50,health) / 50.0f, 0) ];
//	[healthLabel setString:[NSString stringWithFormat:@"+%.0f",health]];
    [healthbar setValue:health];
}

-(void) updatePing:(float)ping
{
	return;
	ping  = fabs(ping);
	[pingLabel setString:[NSString stringWithFormat:@"%.0fms",ping]];
}

-(void) showMessage:(NSString*) message forInterval:(float)interval
{
	[self showMessage:message forInterval:interval withColor:ccc3(255, 255, 255)];
}

-(void) showMessage:(NSString*) message forInterval:(float)interval withColor:(ccColor3B)color
{
    [self unschedule:@selector(clearMessage:)];
	[messageLabel setString:message];
	[messageLabel setColor:color];
    if(interval > 0)
    {
        [self schedule:@selector(clearMessage) interval:interval];
    }
}

-(void) clearMessage
{
    [messageLabel setString:@""];
    [self unschedule:@selector(clearMessage)];
}

-(void) showCompletitionScreen
{
    [self hideResume];
	[self hidePauseMenuItem];
    if(!pauseMenuVisible)
        [self showPauseMenu:nil];
}

-(void) showPauseMenu:(id)sender
{
	if(!pauseMenuVisible)
	{
		pauseMenuVisible = true;
		NSArray* leaderboardEntries = [delegate getLeaderboardEntries];
		leaderboard = [[[Leaderboard alloc] initWithLeaderboardEntries:leaderboardEntries] autorelease];
		leaderboard.position = ccp(40,40);
		[self addChild:leaderboard z:4];
		[self addChild:gameMenuParent z:5];
	}
	else {
		[self hidePauseMenu:nil];
	}

}

-(void) hidePauseMenu:(id)sender
{
	[self removeChild:leaderboard cleanup:true];
	[self removeChild:gameMenuParent cleanup:false];
	pauseMenuVisible = false;
}

-(void) hideResume
{
	[gameMenu removeChild:resumeMenuItem cleanup:true];
}

-(void) hidePauseMenuItem
{
	[self removeChild:pauseMenu cleanup:true];
}

-(void) quitGame:(id)sender
{
	if(delegate != nil)
	{
		[delegate onQuitGame];
	}
}

-(void) dealloc
{
    [gameMenuParent release];
    [super dealloc];
}
@end
