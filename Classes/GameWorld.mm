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
//  16 - Powerups

#import "GameWorld.h"
#import "Helper.h"
#import "SoundManager.h"
static bool debugDraw = false;


@implementation GameWorld

@synthesize worldSize;

-(id) initWorld:(NSString*)worldName
{
	if((self=[super init])) 
	{
        minTimeStep = 1.0f/60.0f;
        currentTimeStep = 0;        
		[self buildWorld:worldName];
		gamePawnList = [[NSMutableArray alloc] init];
		projectilePool = [[ProjectilePool alloc] init];		
		activeProjectiles = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) destroyPhysicsBody:(b2Body*)body
{
    physicsWorld->DestroyBody(body);
}

-(void) buildWorld:(NSString*)worldName
{
	//Load World Property List
	NSDictionary* pListData = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",worldName]]];
	worldSize = CGSizeMake([[pListData objectForKey:@"WorldWidth"] floatValue], [[pListData objectForKey:@"WorldHeight"] floatValue]);
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -20.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
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
	
	b2Vec2 topLeft = b2Vec2(0,(worldSize.height + 100)/PTM_RATIO);
	b2Vec2 bottomLeft = b2Vec2(0,20.0f/PTM_RATIO);
	b2Vec2 topRight = b2Vec2(worldSize.width/PTM_RATIO,(worldSize.height + 100)/PTM_RATIO);
	b2Vec2 bottomRight = b2Vec2(worldSize.width/PTM_RATIO,20.0f/PTM_RATIO);
	// bottom
	groundBox.SetAsEdge(bottomLeft,bottomRight);
	fixture = groundBody->CreateFixture(&groundBox,0);
	// top
	//groundBox.SetAsEdge(topLeft,topRight);
//	fixture = groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.SetAsEdge(topLeft,bottomLeft);
	fixture = groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.SetAsEdge(topRight,bottomRight);
	fixture = groundBody->CreateFixture(&groundBox,0);
	
	//Load World Sprites
	if(!debugDraw)
	{
		NSArray* worldSprites = (NSArray*)[pListData objectForKey:@"Sprites"];
		for(uint i = 0; i < [worldSprites count];i++)
		{
			NSDictionary* spriteData = (NSDictionary*)[worldSprites objectAtIndex:i];
			CCSprite* sprite = [CCSprite spriteWithFile:[spriteData objectForKey:@"SpriteName"]];
			sprite.position = ccp([[spriteData objectForKey:@"PosX"] floatValue],[[spriteData objectForKey:@"PosY"] floatValue]);
			[self addChild:sprite z:[[spriteData objectForKey:@"Z"] intValue]];		
		}
	}
	
	//Load Blocks
	NSArray* worldBlocks = (NSArray*)[pListData objectForKey:@"Blocks"];
	for(uint i = 0; i < [worldBlocks count];i++)
	{
		NSDictionary* blockData = (NSDictionary*)[worldBlocks objectAtIndex:i];
		b2Filter filter;
		filter.maskBits = [[blockData objectForKey:@"MaskBits"] intValue];
		filter.categoryBits = [[blockData objectForKey:@"CategoryBits"] intValue];
		[self addStaticBody:CGPointMake([[blockData objectForKey:@"PosX"] floatValue],[[blockData objectForKey:@"PosY"] floatValue]) 
					 ofSize:b2Vec2([[blockData objectForKey:@"Width"] floatValue],[[blockData objectForKey:@"Height"] floatValue]) 
				 withSprite:nil 
				usingFilter:filter];
	}
	
	//Load Spawn Points
	NSDictionary* teamAData = [pListData objectForKey:@"TeamA"];
	teamASpawnPoint.spawnPoint = ccp([[teamAData objectForKey:@"SpawnX"] floatValue], [[teamAData objectForKey:@"SpawnY"] floatValue]);
	teamASpawnPoint.homeArea = (CGRect){ccp([[teamAData objectForKey:@"HomeX"] floatValue], [[teamAData objectForKey:@"HomeY"] floatValue]),CGSizeMake([[teamAData objectForKey:@"HomeWidth"] floatValue],[[teamAData objectForKey:@"HomeHeight"] floatValue]) };

	NSDictionary* teamBData = [pListData objectForKey:@"TeamB"];
	teamBSpawnPoint.spawnPoint = ccp([[teamBData objectForKey:@"SpawnX"] floatValue], [[teamBData objectForKey:@"SpawnY"] floatValue]);
	teamBSpawnPoint.homeArea = (CGRect){ccp([[teamBData objectForKey:@"HomeX"] floatValue], [[teamBData objectForKey:@"HomeY"] floatValue]),CGSizeMake([[teamBData objectForKey:@"HomeWidth"] floatValue],[[teamBData objectForKey:@"HomeHeight"] floatValue]) };
	
    //Load Powerups
    NSArray* powerupList = [pListData objectForKey:@"Powerups"];
    powerupManager = [[PowerupManager alloc] initWithWorld:self];
    for(uint i = 0; i < [powerupList count]; i++)
    {
        NSDictionary* powerupData = [powerupList objectAtIndex:i];
        PowerupType type = [PowerupFactory parsePowerupType:[powerupData objectForKey:@"Type"]];
        PowerupFactory* powerup = [[PowerupFactory alloc] initWithPowerupType:type spriteName:[powerupData objectForKey:@"SpriteName"] position:CGPointMake([[powerupData objectForKey:@"PosX"] floatValue], [[powerupData objectForKey:@"PosY"] floatValue])];
        [powerupManager addPowerupFactory:powerup];
    }
    
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
	center.Set(0,pawn.offset.y/PTM_RATIO);
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
	int32 velocityIterations = 16;
	int32 positionIterations = 1;
    //currentTimeStep += dt;
    //if(currentTimeStep > minTimeStep)
    //{
        physicsWorld->Step(dt, velocityIterations, positionIterations);
        physicsWorld->ClearForces();
    //    currentTimeStep = 0;
    //}
	[self updateProjectiles:dt];
    [powerupManager processPowerups:dt];
	//[self synchronizePawnPhysics];
}

-(void) updateProjectiles:(ccTime)dt
{
	//ViewPort variables
//	CGSize s = [CCDirector sharedDirector].winSize;
//	CGPoint p = ccp(-self.position.x,-self.position.y);
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

-(void) spawnPowerup:(PowerupFactory*)powerup
{
    b2Filter filter;
    filter.categoryBits = 16;
    filter.maskBits = 65535-4;

    powerup.physicsBody = [self addStaticBody:powerup.position ofSize:b2Vec2(powerup.size.width,powerup.size.height) withSprite:powerup.sprite usingFilter:filter];
    powerup.physicsBody->SetUserData(powerup);
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
	fixtureDef.filter.maskBits = 65535 - proj.teamIndex - 8 - 16;
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
	return teamASpawnPoint;
}

-(TeamSpawnPoint) getTeamBSpawnPoint
{
	return teamBSpawnPoint;
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
