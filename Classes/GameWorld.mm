//
//  GameWorld.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 28/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//
//	Collision Categories:
//	1 - World Boxes and Projectiles
//	2 - Team 1
//  4 - Team 2 
//  8 - One Sided World Boxes
//

#import "GameWorld.h"
#import "Helper.h"
#import "SoundManager.h"
static bool debugDraw = false;


@implementation GameWorld

@synthesize worldSize;

-(id) init
{
	if((self=[super init])) 
	{
		worldSize = CGSizeMake(2880.0f,640.0f);
		[self buildWorld];
		gamePawnList = [[NSMutableArray alloc] init];
		projectilePool = [[ProjectilePool alloc] init];		
		activeProjectiles = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) buildWorld
{
	b2Vec2 gravity;
	gravity.Set(0.0f, -20.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = false;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	ProjectileContactListener* listener = new ProjectileContactListener();
	physicsWorld = new b2World(gravity, doSleep);	
	physicsWorld->SetContactListener(listener);
	
	OneSideContactFilter* contactFilter = new OneSideContactFilter();
	physicsWorld->SetContactFilter(contactFilter);
	physicsWorld->SetContinuousPhysics(true);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = physicsWorld->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonShape groundBox;		
	b2Fixture* fixture;
	
	b2Vec2 topLeft = b2Vec2(0,worldSize.height/PTM_RATIO);
	b2Vec2 bottomLeft = b2Vec2(0,20.0f/PTM_RATIO);
	b2Vec2 topRight = b2Vec2(worldSize.width/PTM_RATIO,worldSize.height/PTM_RATIO);
	b2Vec2 bottomRight = b2Vec2(worldSize.width/PTM_RATIO,20.0f/PTM_RATIO);
	// bottom
	groundBox.SetAsEdge(bottomLeft,bottomRight);
	fixture = groundBody->CreateFixture(&groundBox,0);
	// top
	groundBox.SetAsEdge(topLeft,topRight);
	fixture = groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.SetAsEdge(topLeft,bottomLeft);
	fixture = groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.SetAsEdge(topRight,bottomRight);
	fixture = groundBody->CreateFixture(&groundBox,0);
	
	//Background sprite
	CCSprite* backgroundSprite1 = [CCSprite spriteWithFile:@"Farm1.png"];
	backgroundSprite1.position = CGPointMake(750,320);
	CCSprite* backgroundSprite2 = [CCSprite spriteWithFile:@"Farm2.png"];
	backgroundSprite2.position = CGPointMake(2130,320);
	if(!debugDraw)
	{
		[self addChild:backgroundSprite1];
		[self addChild:backgroundSprite2];
	}
	
	//Foreground Sprites
	CCSprite* sprite = [CCSprite spriteWithFile:@"TreeLeaves.png"];
	sprite.position = CGPointMake(1340,300);
	[self addChild:sprite z:2];
	
	//Add Some static boxes to jump on
	b2Filter filter;
	filter.categoryBits = 1;
	//Team1 Safe Area
	//Safe Block
	filter.maskBits = 65535 - 3;
	[self addStaticBody:CGPointMake(180,80) ofSize:b2Vec2(320,120) withSprite:nil usingFilter:filter];

	//Frontwall
	filter.maskBits = 1;
	[self addStaticBody:CGPointMake(335,80) ofSize:b2Vec2(10, 120) withSprite:nil usingFilter:filter];

	//Backwall
	filter.maskBits = 65535;	
	[self addStaticBody:CGPointMake(10,80) ofSize:b2Vec2(20, 120) withSprite:nil usingFilter:filter];
	
	//Roof
	[self addStaticBody:CGPointMake(180,200) ofSize:b2Vec2(320,120) withSprite:nil usingFilter:filter];
	
	
	//Team2 Safe Area
	//Safe Block
	filter.maskBits = 65535 - 5;
	[self addStaticBody:CGPointMake(worldSize.width - 180,80) ofSize:b2Vec2(320,120) withSprite:nil usingFilter:filter];
	
	//Frontwall
	filter.maskBits = 1;
	[self addStaticBody:CGPointMake(worldSize.width - 335,80) ofSize:b2Vec2(10, 120) withSprite:nil usingFilter:filter];
	
	//Backwall
	filter.maskBits = 65535;	
	[self addStaticBody:CGPointMake(worldSize.width - 10,80) ofSize:b2Vec2(20, 120) withSprite:nil usingFilter:filter];
	
	//Roof
	[self addStaticBody:CGPointMake(worldSize.width - 180,200) ofSize:b2Vec2(320,120) withSprite:nil usingFilter:filter];
	
	
	//Haystack1	
	[self addStaticBody:CGPointMake(818,42) ofSize:b2Vec2(178,44) withSprite:nil usingFilter:filter];
	[self addStaticBody:CGPointMake(818,86) ofSize:b2Vec2(100,44) withSprite:nil usingFilter:filter];
	
	//Well	
	[self addStaticBody:CGPointMake(1722,66) ofSize:b2Vec2(106,84) withSprite:nil usingFilter:filter];
	[self addStaticBody:CGPointMake(1648,39) ofSize:b2Vec2(32,38) withSprite:nil usingFilter:filter];
	[self addStaticBody:CGPointMake(1798,39) ofSize:b2Vec2(32,38) withSprite:nil usingFilter:filter];
	filter.categoryBits = 8;
	[self addStaticBody:CGPointMake(1722,192) ofSize:b2Vec2(114,4) withSprite:nil usingFilter:filter];
	filter.categoryBits = 1;
	//Rock
	[self addStaticBody:CGPointMake(1400,44) ofSize:b2Vec2(108,48) withSprite:nil usingFilter:filter];
	
	//Branch1	
	filter.categoryBits = 8;
	[self addStaticBody:CGPointMake(1282,138) ofSize:b2Vec2(70,4) withSprite:nil usingFilter:filter];
	//Branch2
	[self addStaticBody:CGPointMake(1468,210) ofSize:b2Vec2(82,4) withSprite:nil usingFilter:filter];
	//Branch3
	[self addStaticBody:CGPointMake(1492,286) ofSize:b2Vec2(86,4) withSprite:nil usingFilter:filter];
	//Branch 4
	[self addStaticBody:CGPointMake(1472,344) ofSize:b2Vec2(66,4) withSprite:nil usingFilter:filter];
	//Branch 5
	[self addStaticBody:CGPointMake(1456,398) ofSize:b2Vec2(67,4) withSprite:nil usingFilter:filter];
	//Branch 6
	[self addStaticBody:CGPointMake(1245,307) ofSize:b2Vec2(65,4) withSprite:nil usingFilter:filter];
	
	//Left Fence
	[self addStaticBody:CGPointMake(480,104) ofSize:b2Vec2(300,4) withSprite:nil usingFilter:filter];
	//Right Fence
	[self addStaticBody:CGPointMake(worldSize.width - 468,102) ofSize:b2Vec2(250,4) withSprite:nil usingFilter:filter];
	
	//Debug Draw Stuff
	m_debugDraw = new GLESDebugDraw	( PTM_RATIO );
	physicsWorld->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	//		flags += b2DebugDraw::e_jointBit;
	//		flags += b2DebugDraw::e_aabbBit;
	//		flags += b2DebugDraw::e_pairBit;
	//		flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	if(debugDraw)
	{
		glDisable(GL_TEXTURE_2D);
		glDisableClientState(GL_COLOR_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		
		physicsWorld->DrawDebugData();
		
		// restore default GL states
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_COLOR_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	}
}

-(b2Body*) addStaticBody:(CGPoint)pos ofSize:(b2Vec2)size withSprite:(CCSprite*)sprite usingFilter:(b2Filter)filter
{	
	if(filter.categoryBits == 0)
		filter.categoryBits = 1;
	if(filter.maskBits == 0)
		filter.maskBits = 65535;
	
	if(sprite != nil)
	{
		sprite.position = pos;
		[self addChild:sprite];
	}
	
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
	
	bodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = physicsWorld->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape staticBox;
	staticBox.SetAsBox(size.x/2/PTM_RATIO, size.y/2/PTM_RATIO);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &staticBox;	
	//if(filter != 
	fixtureDef.filter = filter;
	
	body->CreateFixture(&fixtureDef);
	return body;
}

-(void) spawnGamePawn:(GamePawn*)pawn
{	
	[pawn setProjectilePool:projectilePool];
	[self createPawnBody:pawn];
	[gamePawnList addObject:pawn];
	[pawn synchronizePawnPhysics:0];
}

-(void) createPawnBody:(GamePawn*)pawn
{
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(pawn.team.spawnPoint.spawnPoint.x/PTM_RATIO, pawn.team.spawnPoint.spawnPoint.y/PTM_RATIO);
	bodyDef.userData = pawn;
	bodyDef.fixedRotation = true;
	pawn.physicsBody = physicsWorld->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2Vec2 center;
	center.Set(pawn.offset.x/PTM_RATIO,pawn.offset.y/PTM_RATIO);
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(pawn.size.x/2/PTM_RATIO, pawn.size.y/2/PTM_RATIO,center,0);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.6f;
	fixtureDef.filter.categoryBits = pawn.team.teamIndex;
	fixtureDef.filter.maskBits = 65535 - 6; //no collision between players 
	pawn.physicsBody->CreateFixture(&fixtureDef);
}

-(void) respawn:(GamePawn*)pawn
{
	physicsWorld->DestroyBody(pawn.physicsBody);
	[pawn reset];
	[self createPawnBody:pawn];
	[pawn synchronizePawnPhysics:0];
}

-(void) updateWorld:(ccTime) dt
{
	int32 velocityIterations = 4;
	int32 positionIterations = 1;
	physicsWorld->Step(dt, velocityIterations, positionIterations);
	[self updateProjectiles:dt];
	//[self synchronizePawnPhysics];
}

-(void) updateProjectiles:(ccTime)dt
{
	//ViewPort variables
	CGSize s = [CCDirector sharedDirector].winSize;
	CGPoint p = ccp(-self.position.x,-self.position.y);
	//Spawn pending projectiles
	Projectile* proj;
	while((proj = [projectilePool getNextProjectile]))
	{
		[self spawnProjectile:proj];
		[activeProjectiles addObject:proj];
	}
	
	//Update position of active projectiles
	for(NSUInteger i = 0; i < [activeProjectiles count];i++)
	{
		proj = [activeProjectiles objectAtIndex:i];
		proj.lifetime = proj.lifetime + dt;
		if(proj.destroyed || (fabsf(proj.physicsBody->GetLinearVelocity().x) < 0.5 && proj.lifetime > 0.2))
		{
			CGPoint pos = [Helper toCGPoint:proj.physicsBody->GetPosition() multiply:PTM_RATIO];
			if(proj.deathEffect != nil)
			{
				proj.deathEffect.position = pos;
				[self addChild:proj.deathEffect];
			}
			[self removeChild:proj.sprite cleanup:true];
			[activeProjectiles removeObjectAtIndex:i];
			physicsWorld->DestroyBody(proj.physicsBody);
			[proj release];
			//Determine if sound should be played
			/*if(pos.x >= p.x && pos.x <= (p.x + s.width) && pos.y >= p.y && pos.y <= (p.y + s.height))
			{
				//play destroy sound;
				[[SimpleAudioEngine sharedEngine] playEffect:@"Paintball-Impact.aif"];
			}*/
			[[SoundManager sharedManager] playSound:@"Paintball-Impact.aif" atPosition:pos];
			i--;
		}
		else 
		{
			b2Vec2 pBodyPos = proj.physicsBody->GetPosition();
			proj.sprite.position = ccp(pBodyPos.x * PTM_RATIO,pBodyPos.y * PTM_RATIO);
		}

	}
}

-(void) spawnProjectile:(Projectile*)proj
{
	proj.sprite.position = ccp(proj.launchPosition.x, proj.launchPosition.y);
	[self addChild:proj.sprite];
	b2Vec2 pos = b2Vec2(proj.launchPosition.x/PTM_RATIO,proj.launchPosition.y/PTM_RATIO);
	b2BodyDef projBodyDef;
	projBodyDef.type = b2_dynamicBody;
	projBodyDef.position.Set(pos.x,pos.y);
	projBodyDef.fixedRotation = true;
	proj.physicsBody = physicsWorld->CreateBody(&projBodyDef);
	proj.physicsBody->SetUserData(proj);
	// Define another box shape for our dynamic body.
	b2Vec2 center;
	center.Set(0,0);
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(2.5f/PTM_RATIO, 2.5f/PTM_RATIO,center,0);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = proj.mass;
	fixtureDef.friction = 0.1f;
	fixtureDef.filter.categoryBits = proj.teamIndex + 1;
	fixtureDef.filter.maskBits = 65535 - proj.teamIndex - 8;
	proj.physicsBody->CreateFixture(&fixtureDef);
	proj.physicsBody->ApplyForce(b2Vec2(proj.launchForce.x,proj.launchForce.y), pos);
}


NSInteger sortByPawnPosition(id arg1,id arg2, void* reverse)
{
	GamePawn* p1 = (GamePawn*)arg1;
	GamePawn* p2 = (GamePawn*)arg2;
	if([p1 position].x < [p2 position].x)
		return (NSComparisonResult)NSOrderedAscending;
	else if([p1 position].x > [p2 position].x)
		return (NSComparisonResult)NSOrderedDescending;
	return (NSComparisonResult)NSOrderedSame;
}

-(TeamSpawnPoint) getTeamASpawnPoint
{
	TeamSpawnPoint spawn;
	spawn.spawnPoint = ccp(100,100);
	spawn.homeArea = (CGRect){ ccp(10,20),CGSizeMake(320,120) };
	return spawn;
}

-(TeamSpawnPoint) getTeamBSpawnPoint
{
	TeamSpawnPoint spawn;
	spawn.spawnPoint = ccp(worldSize.width-100,100);
	spawn.homeArea = (CGRect){ ccp(worldSize.width - 330,20),CGSizeMake(320,120) };
	return spawn;
}

-(BattleInfo*) getBattleInfo
{
	NSMutableArray* alivePawnList = [[NSMutableArray alloc] init];
	for(NSUInteger i = 0; i < [gamePawnList count];i++)
	{
		GamePawn* pawn = [gamePawnList objectAtIndex:i];
		if(![pawn isDead])
			[alivePawnList addObject:pawn];
	}
	//BOOL reverseSort = NO;
	//NSArray* sortedPawnList = [alivePawnList sortedArrayUsingFunction:sortByPawnPosition context:&reverseSort];
	BattleInfo* info = [[BattleInfo alloc] initWithPawnList:alivePawnList];
	return info;
}

@end
