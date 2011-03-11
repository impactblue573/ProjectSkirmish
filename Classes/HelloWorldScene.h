//
//  HelloWorldScene.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 26/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "SneakyJoystick.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{	
	b2Body* PlayerBody;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	SneakyJoystick *leftJoystick;
	CCLayer* gameLayer;
	CGPoint gameLayerPosition;
	CCLayer* uiLayer;
	bool jumpReleased;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

// adds a new sprite at a given coordinate
-(void) addStaticBox:(CGPoint)p ofSize:(b2Vec2)s withSprite:(CCSprite*)sprite;
-(b2Body*) addNewSpriteWithCoords:(CGPoint)p;
-(void) AddJoystick;

@end
