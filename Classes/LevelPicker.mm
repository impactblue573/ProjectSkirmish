//
//  LevelPicker.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelPicker.h"

@implementation LevelPicker

-(id) initWithLevels:(uint)numLevels target:(id)target selector:(SEL)selector
{
    self = [super init];
    levels = numLevels;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];    
    menu = [CCMenu menuWithItems:nil];
    menu.anchorPoint = ccp(0,0);
    menu.position = ccp(0,0);
    uint col = 0;
    uint row = 0;
    for(uint i = 0; i < levels; i++)
    {
        CCMenuItemImage* item = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"LevelSelect.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"LevelSelectActive.png"] target:self selector:@selector(levelClick:)];
        item.anchorPoint = ccp(0,1);
        item.position = ccp(3 + 96 * col, screenSize.height - (3 + 66 * row));
//        item.position = ccp(0,0);
        CCLabelTTF* levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d",i+1] fontName:@"Marker Felt" fontSize:16]; 
        [levelLabel setColor:ccc3(20, 20, 20)];
        levelLabel.anchorPoint = ccp(0,1);
        levelLabel.position = ccp(6,60);
        CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",i*10] dimensions:CGSizeMake(screenSize.width/4-20,22) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:20];
        [scoreLabel setColor:ccc3(255, 20, 20)];
        scoreLabel.anchorPoint = ccp(0,0);
        scoreLabel.position = ccp(0,20);
        [item addChild:levelLabel z:50 tag:0];
        [item addChild:scoreLabel z:50 tag:1];
        col++;
        if(col >= 5)
        {
            col = 0;
            row++;
        }        
        [menu addChild:item z:0 tag:i];
    }
    [self addChild:menu z:1];
    
    //store invocation
    if(target && selector)
	{
		NSMethodSignature* sig = nil;
		sig = [target methodSignatureForSelector:selector];
		invocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
		[invocation setTarget:target];
		[invocation setSelector:selector];
	}
    return self;
}

-(void) levelClick:(id)item
{
    uint level = ((CCMenuItem*)item).tag + 1;
    if(invocation != nil)
    {
        [invocation setArgument:&level atIndex:2];
        [invocation invoke];
    }
}

-(void) SetBackgroundImage:(NSString*)name{
    if(background)
    {
        [self removeChild:background cleanup:false];
    }
    
    background = [CCSprite spriteWithSpriteFrameName:name];
    background.anchorPoint = ccp(0,0);
    background.position = ccp(0,0);
    [self addChild:background z:0];
}

-(void) SetLevelScores:(NSMutableArray *)scores{
    for(uint i = 0; i < levels; i++)
    {
        CCMenuItemImage* item = (CCMenuItemImage*)[menu getChildByTag:i];
        uint score = 0;
        if(i < [scores count])
        {
            score = [[scores objectAtIndex:i] intValue];
        }
        CCLabelTTF* scoreLabel = (CCLabelTTF*)[item getChildByTag:1];
        if(score > 0)
        {
            [item setNormalImage:[CCSprite spriteWithSpriteFrameName:@"LevelSelectComplete.png"]];
            [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
        }
        else
        {
            [item setNormalImage:[CCSprite spriteWithSpriteFrameName:@"LevelSelect.png"]];
            [scoreLabel setString:@""];
        }
        
    }
}

-(void) dealloc{
    [super dealloc];
    if(invocation != nil)
        [invocation release];
}
@end
