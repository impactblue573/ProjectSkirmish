//
//  MessageBox.m
//  ProjectSkirmish
//
//  Created by Tony Luk on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageBox.h"

@implementation MessageBox

-(id) init{
    self = [super init];
    CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"MessageBox.png"];
    background.anchorPoint = ccp(0.5,0);
    background.position = ccp(125,0);    
    [self addChild:background z:0];
    
    CCMenuItemImage* okButton = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"Ok.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"OkActive.png"] target:self selector:@selector(close)];
    okButton.selectedImage.position = ccp(-3,-2);
    okButton.anchorPoint = ccp(0.5,0);
    CCMenu* menu = [CCMenu menuWithItems:okButton, nil];
    menu.anchorPoint = ccp(0.5,0);
    menu.position  = ccp(125,10);
    [self addChild:menu z:3];
    return self;
}

-(void) setTarget:(id)target selector:(SEL)selector{
    if(target && selector)
    {
        if(invocation != nil)
            [invocation release];
        NSMethodSignature* sig = nil;
        sig = [target methodSignatureForSelector:selector];
        invocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
        [invocation setTarget:target];
        [invocation setSelector:selector];
    }    
}

-(void) setText:(NSString *)text fontSize:(float)fontSize color:(ccColor3B)color
{
    if(textLabel != nil)
        [self removeChild:textLabel cleanup:true];
    textLabel = [CCLabelTTF labelWithString:text dimensions:CGSizeMake(240,150) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:fontSize];
    textLabel.anchorPoint = ccp(0.5,0);
    textLabel.position = ccp(125,0);
    [textLabel setColor:color];
    [self addChild:textLabel z:1];
}

-(void) close{
    if(invocation)
    {
        [invocation invoke];
    }
}

-(void) dealloc{
    if(invocation)
        [invocation release];
}
@end
