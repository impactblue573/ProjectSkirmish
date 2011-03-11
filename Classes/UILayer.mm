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
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	team1ScoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(50,50) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:32];
	[team1ScoreLabel setColor:ccc3(255,0,0)];
	team1ScoreLabel.position = ccp( screenSize.width/2-50, screenSize.height-30);
	[self addChild:team1ScoreLabel z:0];
	
	team2ScoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(50,50) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:32];
	[team2ScoreLabel setColor:ccc3(0,0,255)];
	team2ScoreLabel.position = ccp( screenSize.width/2+50, screenSize.height-30);
	[self addChild:team2ScoreLabel z:0];
	
	healthLabel = [CCLabelTTF labelWithString:@"+100" dimensions:CGSizeMake(80,50) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:32];
	[healthLabel setColor:ccc3(0,100,0)];
	healthLabel.position = ccp(40, screenSize.height-25);
	[self addChild:healthLabel z:0];
	
	pingLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(50,20) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
	pingLabel.position = ccp( screenSize.width-25, screenSize.height-10);
	[self addChild:pingLabel z:0];
	
	messageLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(screenSize.width,40) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:32];
	messageLabel.position = ccp(screenSize.width/2,screenSize.height/2 -20);
	[self addChild:messageLabel z:0];
	
	CCLabelTTF* pauseLabel = [CCLabelTTF labelWithString:@"Menu" fontName:@"Marker Felt" fontSize:20];
	[pauseLabel setColor:(ccColor3B){128,128,128}];
	CCMenuItem* pauseMenuItem = [CCMenuItemFont itemWithLabel:pauseLabel target:self selector:@selector(showPauseMenu:)];	
	pauseMenu = [CCMenu menuWithItems:pauseMenuItem,nil];
	pauseMenu.position = ccp(screenSize.width-30,screenSize.height-10);
	[self addChild:pauseMenu z:4];
	
	CCMenuItem* resumeMenuItem = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(hidePauseMenu:)];
	CCMenuItem* quitMenuItem = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(quitGame:)];
	quitMenuItem.position = ccp(0,-30);
	gameMenu = [[CCMenu menuWithItems:resumeMenuItem,quitMenuItem,nil] retain];
	gameMenu.position = ccp(screenSize.width/2,screenSize.height/2);
	return self;
}

-(void) updateTeam1Score:(int)t1Score team2Score:(int)t2Score
{
	[team1ScoreLabel setString:[NSString stringWithFormat:@"%d",t1Score]];
	[team2ScoreLabel setString:[NSString stringWithFormat:@"%d",t2Score]];
}

-(void) updateHealth:(float)health
{
	[healthLabel setColor:ccc3(200 * clampf((100.0f - health)/50.0f,0,1), 200 * fmin(50,health) / 50.0f, 0) ];
	[healthLabel setString:[NSString stringWithFormat:@"+%.0f",health]];
}

-(void) updatePing:(float)ping
{
	ping  = fabs(ping);
	[pingLabel setString:[NSString stringWithFormat:@"%.0fms",ping]];
}

-(void) showMessage:(NSString*) message
{
	[self showMessage:message withColor:ccc3(255, 255, 255)];
}

-(void) showMessage:(NSString*) message withColor:(ccColor3B)color
{
	[messageLabel setString:message];
	[messageLabel setColor:color];
}

-(void) showPauseMenu:(id)sender
{
	[self addChild:gameMenu z:5];
}

-(void) hidePauseMenu:(id)sender
{
	[self removeChild:gameMenu cleanup:false];
}

-(void) quitGame:(id)sender
{
	if(delegate != nil)
	{
		[delegate onQuitGame];
	}
}
@end
