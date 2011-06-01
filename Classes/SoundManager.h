//
//  SoundManager.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 19/01/11.
//  Copyright 2011 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundManager : NSObject {
    NSString* currentBackgroundMusic;
    float currentBackgroundVolume;
    float backgroundVolume;
}

+(SoundManager*) sharedManager;
-(void) preloadSound:(NSString*)sound;
-(void) playSound:(NSString*)sound atPosition:(CGPoint)position;
-(void) playBackgroundMusic:(NSString*)music;
-(void) fadeInBackgroundMusic:(float)volume;
-(void) increaseBackgroundVolume;

@end
