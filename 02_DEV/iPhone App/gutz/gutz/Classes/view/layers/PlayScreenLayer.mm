//
//  PlayScreenLayer.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "PlayScreenLayer.h"

#import "LvlStarSprite.h"
#import "ScoreSprite.h"
#import "ElapsedTimeSprite.h"


#import "CreatureNodeVO.h"

#import "RandUtils.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32


@implementation PlayScreenLayer


@synthesize score_amt;
@synthesize arrCreatureVO;

-(id) init {
    NSLog(@"%@.init()", [self class]);
    
    //if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
	
	self = [super init];
    
    CCSprite *bg = [CCSprite spriteWithFile: @"background_white.jpg"];
	bg.position = ccp(160, 240);
    [self addChild: bg z:0];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		
		
		segHolderSprite = [CCSprite node];
		[self addChild:segHolderSprite];
		
		[self box2dSetup];
		
		
		
		[self scaffoldHUD];
		
		[self schedule:@selector(physicsStepper:)];// interval:(1.0f / 60.0f)];
	
	return (self);
}

-(void) scaffoldHUD {
	
	CCMenuItemImage *btnPause = [CCMenuItemImage itemFromNormalImage:@"HUD_pauseButton_nonActive.png" selectedImage:@"HUD_pauseButton_Active.png" target:nil selector:nil];
    CCMenuItemImage *btnPlay = [CCMenuItemImage itemFromNormalImage:@"HUD_pauseButton_nonActive.png" selectedImage:@"HUD_pauseButton_Active.png" target:nil selector:nil];
    btnPlayPauseToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(onPlayPauseToggle:) items:btnPause, btnPlay, nil];
	CCMenu *mnuPlayPause = [CCMenu menuWithItems: btnPlayPauseToggle, nil];
	
	mnuPlayPause.position = ccp(280, 440);
	[mnuPlayPause alignItemsVerticallyWithPadding: 20.0f];
	[self addChild: mnuPlayPause];
	
	hudStarsSprite = [[LvlStarSprite alloc] init];
	[hudStarsSprite setPosition:ccp(28, 32)];
	[self addChild:hudStarsSprite];
	
	scoreDisplaySprite = [[ScoreSprite alloc] init];
	[scoreDisplaySprite setPosition:ccp(55, 450)];
	[self addChild:scoreDisplaySprite];
	
	timeDisplaySprite = [[ElapsedTimeSprite alloc] init];
	[timeDisplaySprite setPosition:ccp(250, 32)];
	[self addChild:timeDisplaySprite];
	
	
	if (kShowDebugMenus)
		[self debuggingSetup];
	
	
}


-(void) box2dSetup {
	
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	
	// Define the gravity vector.
	b2Vec2 gravity;
	//gravity.Set(0.0f, -10.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	flags += b2DebugDraw::e_jointBit;
	//		flags += b2DebugDraw::e_aabbBit;
	//		flags += b2DebugDraw::e_pairBit;
	flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body *groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonShape groundBox;		
	
	// bottom
	groundBox.SetAsEdge(b2Vec2(0, 0), b2Vec2(screenSize.width / PTM_RATIO, 0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// top
	groundBox.SetAsEdge(b2Vec2(0, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
	
	// left
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0, 0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// right
	groundBox.SetAsEdge(b2Vec2(screenSize.width / PTM_RATIO, screenSize.height / PTM_RATIO), b2Vec2(screenSize.width / PTM_RATIO, 0));
	groundBody->CreateFixture(&groundBox, 0);
	
	CGPoint spokeSpringVals = CGPointMake(220.0, 0.2);
	CGPoint interSpringVals = CGPointMake(32.0, 0.15);
	CGPoint perimSpringVals = CGPointMake(192.0, 0.1);
	CGPoint diagSpringVals = CGPointMake(16.0, 0.1);
	
	arrCreatureVO = [[NSMutableArray alloc] init];
	CGPoint orgPt = CGPointMake(160, 180);
	CGPoint pos = orgPt;
	
	CCSprite *axisSprite = [CCSprite spriteWithFile:@"debug_node-00.png"];
	[axisSprite setPosition:orgPt];
	[axisSprite setScale:3.0f];
	[segHolderSprite addChild:axisSprite];
	
	b2BodyDef axisBodyDef;
	axisBodyDef.type = b2_dynamicBody;
	
	axisBodyDef.position.Set(orgPt.x / PTM_RATIO, orgPt.y / PTM_RATIO);
	axisBodyDef.userData = axisSprite;
	b2Body *axisBody = world->CreateBody(&axisBodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape axisShape;
	axisShape.SetAsBox(0.5f, 0.5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef axisFixture;
	axisFixture.shape = &axisShape;	
	axisFixture.density = 1.0f;
	axisFixture.friction = 0.5f;
	axisBody->CreateFixture(&axisFixture);
	
	[arrCreatureVO addObject:[CreatureNodeVO initWithData:-1 nodeSprite:axisSprite body:axisBody shape:axisShape pos:pos]];
	
	int lvlRad = 1;
	
	int segRad = 9;
	int degRad = 360 / segRad;
	
	int minRad = 48;
	int incRad = 32;
	
	//float nodeMass = 128.0;
	//float nodeRad = 24.0;
	//float nodeRes = 0.33;
	//float nodeFric = 0.1;
	
	int ind = 1;
	for (int j=0; j<lvlRad; j++) {
		for (int i=0; i<360; i+=degRad) {
			
			pos.x = orgPt.x + sinf(CC_DEGREES_TO_RADIANS(i)) * (minRad + (j * incRad));
			pos.y = orgPt.y + cosf(CC_DEGREES_TO_RADIANS(i)) * (minRad + (j * incRad));
			
			int node_id = i + (j * 1000);
			NSLog(@"j:[%d] i:[%d] ind:[%d] node_id:[%d] pos:[%f, %f]", j, i, ind, node_id, pos.x, pos.y);
			
			
			CCSprite *segSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"debug_node-0%d.png", j + 1]];
			[segSprite setPosition:pos];
			[segSprite setScale:3.33f];
			[segHolderSprite addChild:segSprite];
			
			
			b2BodyDef segBodyDef;
			segBodyDef.type = b2_dynamicBody;
			
			segBodyDef.position.Set(pos.x / PTM_RATIO, pos.y / PTM_RATIO);
			segBodyDef.userData = segSprite;
			b2Body *segBody = world->CreateBody(&segBodyDef);
			
			// Define another box shape for our dynamic body.
			b2PolygonShape segShape;
			segShape.SetAsBox(0.5f, 0.5f);//These are mid points for our 1m box
			
			// Define the dynamic body fixture.
			b2FixtureDef segFixtureDef;
			segFixtureDef.shape = &segShape;	
			segFixtureDef.density = 1.0f;
			segFixtureDef.friction = 0.3f;
			segBody->CreateFixture(&segFixtureDef);

			
			[arrCreatureVO addObject:[CreatureNodeVO initWithData:node_id nodeSprite:segSprite body:segBody shape:segShape pos:pos]];
			
			
			b2DistanceJointDef segDistJointDef;
			b2Joint *segDistJoint;
			
			
			
			b2PrismaticJointDef segPrisJointDef;
			b2Joint *segPrisJoint;
			
			
			
			
			// make connect w/ center
			if (j == 0) {
			
				segDistJointDef.Initialize(axisBody, segBody, b2Vec2(orgPt.x, orgPt.y), b2Vec2(pos.x, pos.y));
				segDistJointDef.collideConnected = false;
				//segDistJointDef.frequencyHz = 30.0f;
				segDistJointDef.dampingRatio = 1.1f;
				segDistJointDef.length = 0.1f;
				segDistJoint = world->CreateJoint(&segDistJointDef);
				
				/*segPrisJointDef.Initialize(axisBody, segBody, axisBody->GetWorldCenter(), b2Vec2(1.0f, 0.0f));
				segPrisJointDef.lowerTranslation = -1.0f;
				segPrisJointDef.upperTranslation = 2.5f;
				segPrisJointDef.enableLimit = true;
				segPrisJointDef.maxMotorForce = 1.0f;
				segPrisJointDef.motorSpeed = 0.0f;
				segPrisJointDef.enableMotor = true;
				segPrisJoint = world->CreateJoint(&segPrisJointDef);
				*/
								
				// make connect on outer/inner
			} /*else {
				cpBody *innerBody;
				
				innerBody = [self findInnerNode:node_id - (j * 1000)];
				
				rSpring = cpDampedSpringNew(segBody, innerBody, cpvzero, cpvzero, ((j * incRad) * 0.8), interSpringVals.x, interSpringVals.y);
				cpSpaceAddConstraint(space, rSpring);
				
				
				// bind outer/inner on diag
				if (i < (360 - degRad)) {
					innerBody = [self findInnerNode:(node_id - (j * 1000)) + 1];
					rSpring = cpDampedSpringNew(segBody, innerBody, cpvzero, cpvzero, 64, diagSpringVals.x, diagSpringVals.y);
					cpSpaceAddConstraint(space, rSpring);
					
				} else if (i == (360 - degRad)) {
					innerBody = [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:1] body];
					rSpring = cpDampedSpringNew(segBody, innerBody, cpvzero, cpvzero, 64, diagSpringVals.x, diagSpringVals.y);
					cpSpaceAddConstraint(space, rSpring);
					
					ccDrawLine(ccp(segBody->p.x, segBody->p.y), ccp(innerBody->p.x, innerBody->p.y));
				}
			}
			
			// make connect w/ current/prev
			if (i > 0) {
				//NSLog(@" --BINDING PREV->CURRENT");
				
				cpConstraint *dSpring = cpDampedSpringNew(segBody, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind - 1] body], cpvzero, cpvzero, 32 + (j * 16), perimSpringVals.x, perimSpringVals.y);
				cpSpaceAddConstraint(space, dSpring);
				
				//cpConstraint *dLimit = cpRotaryLimitJointNew(segBody, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind] body], CC_DEGREES_TO_RADIANS(0), CC_DEGREES_TO_RADIANS(30));
				//cpSpaceAddConstraint(space, dLimit);
				
				ccDrawLine(ccp(pos.x, pos.y), ccp([(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind - 1] body]->p.x, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind - 1] body]->p.y));
				
			} if (ind % segRad == 0 && ind > 0) {
				cpConstraint *dSpring = cpDampedSpringNew(segBody, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:(j * segRad) + 1] body], cpvzero, cpvzero, 32 + (j * 16), perimSpringVals.x, perimSpringVals.y);
				cpSpaceAddConstraint(space, dSpring);
			}
			*/
			ind++;
		}
	}
	
	[self schedule: @selector(wiggler:) interval:((CCRANDOM_0_1() * 0.5f) - 0.25f) + 0.25f];
	

}

/*
-(void) chipmunkSetup {
	
	CGSize wins = [[CCDirector sharedDirector] winSize];
	
	cpInitChipmunk();
	
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, 400.0f, 40);
	cpSpaceResizeActiveHash(space, 100, 600);
	
	space->gravity = ccp(0, -8);
	space->elasticIterations = 16;//space->iterations;
	
	cpBody *boundsBody = cpBodyNew(INFINITY, INFINITY);
	cpShape *boundsShape;
	
	// bottom
	boundsShape = cpSegmentShapeNew(boundsBody, cpvzero, ccp(wins.width, 0), 0.0f);
	boundsShape->e = 1.0f; boundsShape->u = 1.0f;
	cpSpaceAddStaticShape(space, boundsShape);
	
	// top
	boundsShape = cpSegmentShapeNew(boundsBody, ccp(0, wins.height), ccp(wins.width, wins.height), 0.0f);
	boundsShape->e = 1.0f; boundsShape->u = 1.0f;
	cpSpaceAddStaticShape(space, boundsShape);
	
	// left
	boundsShape = cpSegmentShapeNew(boundsBody, cpvzero, ccp(0, wins.height), 0.0f);
	boundsShape->e = 1.0f; boundsShape->u = 1.0f;
	cpSpaceAddStaticShape(space, boundsShape);
	
	// right
	boundsShape = cpSegmentShapeNew(boundsBody, ccp(wins.width, 0), ccp(wins.width, wins.height), 0.0f);
	boundsShape->e = 1.0f; boundsShape->u = 1.0f;
	cpSpaceAddStaticShape(space, boundsShape);
	
	
	//CGPoint spokeSpringVals = CGPointMake(512.0, 4.0); //280, 5.1
	//CGPoint interSpringVals = CGPointMake(128.0, 2.0); //64, 0.1
	//CGPoint perimSpringVals = CGPointMake(160.0, 0.33); //8.0, 0.1
	//CGPoint diagSpringVals = CGPointMake(16.0, 0.5); //8.0, 0.25
	
	CGPoint spokeSpringVals = CGPointMake(220.0, 0.2);
	CGPoint interSpringVals = CGPointMake(32.0, 0.15);
	CGPoint perimSpringVals = CGPointMake(192.0, 0.1);
	CGPoint diagSpringVals = CGPointMake(16.0, 0.1);
	
	arrCreatureVO = [[NSMutableArray alloc] init];
	CGPoint orgPt = CGPointMake(160, 180);
	CGPoint pos = orgPt;
	
	CCSprite *axisSprite = [CCSprite spriteWithFile:@"debug_node-00.png"];
	[axisSprite setPosition:orgPt];
	[axisSprite setScale:3.0f];
	[segHolderSprite addChild:axisSprite];
	
	cpBody *axisBody = cpBodyNew(160.0, INFINITY);
	axisBody->p = cpv(pos.x, pos.y);
	cpSpaceAddBody(space, axisBody);
	
	cpShape *axisShape = cpCircleShapeNew(axisBody, 24.0, cpvzero);
	axisShape->e = 0.2;
	axisShape->u = 0.9;
	axisShape->data = axisSprite;
	axisShape->collision_type = 1;
	cpSpaceAddShape(space, axisShape);
	
	[arrCreatureVO addObject:[CreatureNodeVO initWithData:-1 nodeSprite:axisSprite body:axisBody shape:axisShape pos:pos]];
	
	int lvlRad = 2;
	
	int segRad = 9;
	int degRad = 360 / segRad;
	
	int minRad = 48;
	int incRad = 32;
	
	
	float nodeMass = 128.0;
	float nodeRad = 24.0;
	float nodeRes = 0.33;
	float nodeFric = 0.1;
	
	int ind = 1;
	for (int j=0; j<lvlRad; j++) {
		for (int i=0; i<360; i+=degRad) {
			
			pos.x = orgPt.x + sinf(CC_DEGREES_TO_RADIANS(i)) * (minRad + (j * incRad));
			pos.y = orgPt.y + cosf(CC_DEGREES_TO_RADIANS(i)) * (minRad + (j * incRad));
			
			int node_id = i + (j * 1000);
			NSLog(@"j:[%d] i:[%d] ind:[%d] node_id:[%d] pos:[%f, %f]", j, i, ind, node_id, pos.x, pos.y);
			
			
			CCSprite *segSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"debug_node-0%d.png", j + 1]];
			[segSprite setPosition:pos];
			[segSprite setScale:3.33f];
			[segHolderSprite addChild:segSprite];
			
			cpBody *segBody = cpBodyNew(nodeMass, INFINITY);
			segBody->p = cpv(pos.x, pos.y);
			cpSpaceAddBody(space, segBody);
			
			cpShape *segShape = cpCircleShapeNew(segBody, nodeRad, cpvzero);
			segShape->e = nodeRes;
			segShape->u = nodeFric;
			segShape->data = segSprite;
			segShape->collision_type = 1;
			cpSpaceAddShape(space, segShape);
			
			
			
			[arrCreatureVO addObject:[CreatureNodeVO initWithData:node_id nodeSprite:segSprite body:segBody shape:segShape pos:pos]];
			cpConstraint *rSpring;
			
			
			// make connect w/ center
			if (j == 0) {
				rSpring = cpDampedSpringNew(segBody, axisBody, cpvzero, cpvzero, minRad * 1.2, spokeSpringVals.x, spokeSpringVals.y);
				cpSpaceAddConstraint(space, rSpring);
				
				// make connect on outer/inner
			} else {
				cpBody *innerBody;
				
				innerBody = [self findInnerNode:node_id - (j * 1000)];
				
				rSpring = cpDampedSpringNew(segBody, innerBody, cpvzero, cpvzero, ((j * incRad) * 0.8), interSpringVals.x, interSpringVals.y);
				cpSpaceAddConstraint(space, rSpring);
				
				
				// bind outer/inner on diag
				if (i < (360 - degRad)) {
					innerBody = [self findInnerNode:(node_id - (j * 1000)) + 1];
					rSpring = cpDampedSpringNew(segBody, innerBody, cpvzero, cpvzero, 64, diagSpringVals.x, diagSpringVals.y);
					cpSpaceAddConstraint(space, rSpring);
					
				} else if (i == (360 - degRad)) {
					innerBody = [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:1] body];
					rSpring = cpDampedSpringNew(segBody, innerBody, cpvzero, cpvzero, 64, diagSpringVals.x, diagSpringVals.y);
					cpSpaceAddConstraint(space, rSpring);
					
					ccDrawLine(ccp(segBody->p.x, segBody->p.y), ccp(innerBody->p.x, innerBody->p.y));
				}
			}
			
			// make connect w/ current/prev
			if (i > 0) {
				//NSLog(@" --BINDING PREV->CURRENT");
				
				cpConstraint *dSpring = cpDampedSpringNew(segBody, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind - 1] body], cpvzero, cpvzero, 32 + (j * 16), perimSpringVals.x, perimSpringVals.y);
				cpSpaceAddConstraint(space, dSpring);
				
				//cpConstraint *dLimit = cpRotaryLimitJointNew(segBody, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind] body], CC_DEGREES_TO_RADIANS(0), CC_DEGREES_TO_RADIANS(30));
				//cpSpaceAddConstraint(space, dLimit);
				
				ccDrawLine(ccp(pos.x, pos.y), ccp([(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind - 1] body]->p.x, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:ind - 1] body]->p.y));
				
			} if (ind % segRad == 0 && ind > 0) {
				cpConstraint *dSpring = cpDampedSpringNew(segBody, [(CreatureNodeVO *)[arrCreatureVO objectAtIndex:(j * segRad) + 1] body], cpvzero, cpvzero, 32 + (j * 16), perimSpringVals.x, perimSpringVals.y);
				cpSpaceAddConstraint(space, dSpring);
			}
			
			ind++;
		}
	}
	
	[self schedule: @selector(wiggler:) interval:((CCRANDOM_0_1() * 0.5f) - 0.25f) + 0.25f];
	// NSLog(@"::::::::]]]]]]]]]]] frame:[%@] boundingBox:[%.0f, %.0f]- )", [segHolderSprite displayedFrame], [segHolderSprite boundingBox].size.width, [segHolderSprite boundingBox].size.height);
}
*/

-(void) draw {
	//glEnable(GL_LINE_SMOOTH);
	//glColor4f(0.5, 0.33, 0.76, 1.0);
	//glLineWidth(10.0f);
	//ccDrawLine(ccp(0, 0), ccp(100, 100));
	
	
	//for (int i=0; i<[arrCreatureVO count]; i++) {
	//	CreatureNodeVO *vo = (CreatureNodeVO *)[arrCreatureVO objectAtIndex:i];
	//	cpBody *body = [vo body];
	//	
	//	
	//		NSLog(@"%@", body);
	//}
}


-(b2Body *) findInnerNode:(int)ind {
	//NSLog(@"%@.findInnerNode(%d)", [self class], ind);
	
	for (int i=0; i<[arrCreatureVO count]; i++) {
		CreatureNodeVO *vo = (CreatureNodeVO *)[arrCreatureVO objectAtIndex:i];
		
		if (vo.ind == ind)
			return (vo.body);
	}
	
	return (nil);
}


-(void) wiggler:(id)sender {
	
	b2Vec2 pos;
	
	//Iterate over the bodies in the physics world
	for (b2Body *b=world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
			
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			pos.Set((CCRANDOM_0_1() * 100.0f) - 50.0f, (CCRANDOM_0_1() * 100.0f) - 50.f);
				
			//sprite.position = CGPointMake(pos.x / PTM_RATIO, pos.y / PTM_RATIO);
			//nnnnbh q222222b->ApplyForce(b2Vec2(pos.x, pos.y), b->GetPosition());
			b->ApplyTorque((CCRANDOM_0_1() * 10.0f) - 5.0f);
		}	
	}	
}

-(void) derpSelector:(id)sender {
	//int ind = 1;
	
	//cpSpaceEachBody(space, &reposBody, nil);
}

-(void) onBackMenu:(id)sender {
    NSLog(@"PlayScreenLayer.onBackMenu()");
    
	[ScreenManager goLevelSelect];
}


-(void) onLevelComplete:(id)sender {
    NSLog(@"PlayScreenLayer.onLevelComplete()");
    
	[ScreenManager goLevelComplete];
}


-(void) onGameOver:(id)sender {
    NSLog(@"PlayScreenLayer.onGameOver()");
    
	[ScreenManager goGameOver];
}


-(void) onPlayPauseToggle:(id)sender {
    NSLog(@"PlayScreenLayer.onPlayPauseToggle(%d)", [sender selectedIndex]);
	
	
	if ([sender selectedIndex] == 1) {
		self.isTouchEnabled = NO;
		[self unschedule:@selector(physicsStepper:)];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GameplayPauseToggle" object:[NSNumber numberWithBool:YES]];
		
	} else {
		self.isTouchEnabled = YES;
		[self schedule:@selector(physicsStepper:) interval:(1.0f / 60.0f)];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"GameplayPauseToggle" object:[NSNumber numberWithBool:NO]];
	}
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc {
    //NSLog(@"PlayScreenLayer.()");
    
	// in case you have something to dealloc, do it in this method
	//cpSpaceFree(space);
	//space = NULL;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter {
    //NSLog(@"PlayScreenLayer.onEnter()");
    
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void) physicsStepper: (ccTime) dt {
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	
	//Iterate over the bodies in the physics world
	for (b2Body *b=world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *sprite = (CCSprite *)b->GetUserData();
			sprite.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}


- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// NSLog(@"PlayScreenLayer.ccTouchesMoved()");
    
    for (UITouch *touch in touches) {
        CGPoint touchPt = [touch locationInView: [touch view]];
        touchPt = [[CCDirector sharedDirector] convertToGL: touchPt];
		touchPt.x = (int)touchPt.x;
		touchPt.y = (int)touchPt.y;
		
		//NSLog(@"PlayScreenLayer.ccTouchesMoved( -rect:[%f, %f] touchPt:[%.0f, %.0f]- )", [segHolderSprite contentSizeInPixels].width, [segHolderSprite contentSizeInPixels].height, touchPt.x, touchPt.y);
		
		
		//Iterate over the bodies in the physics world
		for (b2Body *b=world->GetBodyList(); b; b=b->GetNext()) {
			if (b->GetUserData() != NULL) {
				
				//Synchronize the AtlasSprites position and rotation with the corresponding body
				CCSprite *sprite = (CCSprite *)b->GetUserData();
				
				if (CGRectContainsPoint([sprite boundingBox], touchPt)) {
					NSLog(@"PlayScreenLayer.ccTouchesMoved( -touchPt:[%.0f, %.0f]- )", touchPt.x, touchPt.y);
					
					sprite.position = CGPointMake(touchPt.x / PTM_RATIO, touchPt.y / PTM_RATIO);
					b->SetTransform(b2Vec2(sprite.position.x, sprite.position.y), 0.0f);
				}
			}	
		}
    }
}


- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"PlayScreenLayer.(ccTouchesEnded)");
    
	score_amt = (int)(CCRANDOM_0_1() * 32);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	//[[PlayStatsModel singleton] incScore:score_amt];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {	
    //NSLog(@"PlayScreenLayer.accelerometer()");
    
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float)(acceleration.x * kFilterFactor + (1 - kFilterFactor) * prevX);
	float accelY = (float)(acceleration.y * kFilterFactor + (1 - kFilterFactor) * prevY);
	
	prevX = accelX;
	prevY = accelY;
	
	//space->gravity = ccpMult(ccp(accelX, accelY), 32);
}


-(void) debuggingSetup {
	CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"back" target:self selector: @selector(onBackMenu:)];
	CCMenuItemFont *levelComplete = [CCMenuItemFont itemFromString:@"win" target:self selector: @selector(onLevelComplete:)];
	CCMenuItemFont *gameOver = [CCMenuItemFont itemFromString:@"end" target:self selector: @selector(onGameOver:)];
	CCMenu *mnuDebug = [CCMenu menuWithItems: back, levelComplete, gameOver, nil];
	
	mnuDebug.position = ccp(160, 150);
	[mnuDebug alignItemsVerticallyWithPadding: 20.0f];
	[self addChild: mnuDebug];
}
@end
