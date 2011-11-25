//
//  MessageBox.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MessageBox : CCNode
{
    CCLabelTTF* textLabel;
    NSInvocation* invocation;
}

-(void) setText:(NSString*)text fontSize:(float)fontSize color:(ccColor3B)color;
-(void) setTarget:(id)target selector:(SEL)selector;
-(void) close;
@end
