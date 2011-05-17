//
//  ProjectSkirmishAppDelegate.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 26/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ProjectSkirmishAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    NSString* playerName;
}

-(void) savePlayerName:(NSString*)name;

@property (nonatomic, retain) UIWindow *window;
@property (readonly) NSString* playerName;

@end
