//
//  PlayScreenLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "ChipmunkDebugNode.h"
#import "PlayScreenLayer.h"

#import "LvlStarSprite.h"
#import "ScoreSprite.h"
#import "ElapsedTimeSprite.h"
#import "SegNodeSprite.h"


#import "CreatureNodeVO.h"
#import "VisceraVO.h"

//#import "CreatureConsts.h"
#import "RandUtils.h"
#import "GoalTarget.h"

#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

void eachShape (void *ptr, void *unused) {
	
	cpShape *shape = (cpShape *)ptr;
	CCSprite *sprite = shape->data;
	
	if (sprite) {
		cpBody *body = shape->body;
		
		[sprite setPosition: body->p];
		body->p = [sprite position];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES(-body->a)];
		cpBodySetAngle(body, -CC_DEGREES_TO_RADIANS([sprite rotation]));
		
	}
}


static NSString *borderType = @"borderType";

@implementation PlayScreenLayer


@synthesize score_amt;


@synthesize ctrl = _ctrl;



-(id) init {
    NSLog(@"%@.init()", [self class]);
    
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
    
		 self.isTouchEnabled = YES;
		 self.isAccelerometerEnabled = YES;
		 
		 _cnt = 32;
		 
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"debug_finger.wav"];
		
//		particles = [[CCParticleExplosion alloc] init];
//		particles = [[CCParticleFire alloc] init];
//		particles = [[CCParticleFireworks alloc] init];
//		particles = [[CCParticleFlower alloc] init];
//		particles = [[CCParticleGalaxy alloc] init];
//
//		 particles = [[CCParticleMeteor alloc] init];
//		particles = [[CCParticleRain alloc] init];
//		particles = [[CCParticleSmoke alloc] init];
//		particles = [[CCParticleSnow alloc] init];
//		particles = [[CCParticleSpiral alloc] init];
//		particles = [[CCParticleSun alloc] init];
//		
//		particles.texture = [[CCTextureCache sharedTextureCache] addImage:@"debug_node-02.png"];
//		particles.position = ccp(160, 240);
//		[self addChild:particles];
	
	
		 [self chipmunkSetup];
		 [self scaffoldHUD];
		 [self performSelector:@selector(physProvoker:) withObject:self afterDelay:0.33f];
	 }
	
	return (self);
}



- (void)physProvoker:(id)sender {
	[self schedule:@selector(physicsStepper:) interval:(1.0f / 60.0f)];
	[self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.5f)];
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

-(void) chipmunkSetup {
	
	CGSize wins = [[CCDirector sharedDirector] winSize];
	//CGPoint winsMidPt = CGPointMake(wins.width * 0.5f, wins.height * 0.5f);
	
	NSLog(@"SCREEN SIZE:[%f, %f]", wins.width, wins.height);
	cpInitChipmunk();
	
	_space = [[ChipmunkSpace alloc] init];
	_space.gravity = cpv(0, -16);
	
	
	CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
	[_space addBounds:rect thickness:532 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	
	_multiGrab = [[ChipmunkMultiGrab alloc] initForSpace:_space withSmoothing:cpfpow(0.8, 60.0) withGrabForce:30000];
	_multiGrab.layers = GRABABLE_LAYER;
	
	ChipmunkDebugNode *debugNode = [ChipmunkDebugNode debugNodeForSpace:_space];
	//[self addChild:debugNode];
	
	arrGibs = [[NSMutableArray alloc] init];
	
	arrTargets = [[NSMutableArray alloc] initWithCapacity:2];
	[arrTargets addObject:@"NO"];
	[arrTargets addObject:@"NO"];
	//[arrTargets addObject:@"NO"];
	
	goalTarget1 = [[GoalTarget alloc] initAtPos:ccp(150, 420)];
	goalTarget1.ind = 0;
	[_space add:goalTarget1];
	[self addChild:goalTarget1._sprite];
	
	goalTarget2 = [[GoalTarget alloc] initAtPos:ccp(150, 128)];
	goalTarget2.ind = 1;
	[_space add:goalTarget2];
	[self addChild:goalTarget2._sprite];
	
	//goalTarget3 = [[GoalTarget alloc] initAtPos:ccp(240, 160)];
	//goalTarget3.ind = 2;
	//[_space add:goalTarget3];
	//[self addChild:goalTarget3._sprite];
		
	_blob = [[JellyBlob alloc] initWithPos:cpv(192, 160) radius:BLOB_RADIUS count:BLOB_SEGS];
	[_space add:_blob];
	
//	ChipmunkBody *derpBody = [ChipmunkBody bodyWithMass:1 andMoment:INFINITY];
//	cpVect vt[BLOB_SEGS];
//	
//	for(int i=0; i<BLOB_SEGS; i++){
//		cpVect slope = cpvforangle(((cpFloat)BLOB_SEGS - i) / (cpFloat)BLOB_SEGS * 2.0 * M_PI);
//		cpVect posMult = cpvmult(slope, BLOB_RADIUS * 0.5);
//		
//		vt[i] = cpvadd(posMult, cpv(100, 300));
//		NSLog(@"vt[%d]: (%f, %f)", i, vt[i].x, vt[i].y);
//	}
//		
//	ChipmunkShape *derp = [_space add:[ChipmunkPolyShape polyWithBody:derpBody count:BLOB_SEGS verts:vt offset:cpvzero]];
	
	
	 
	
//	cpShapePointQuery(<#cpShape *shape#>, <#cpVect p#>)
	
	/*{ // box
	 cpFloat width = 128;
	 cpFloat height = 32;
	 
	 ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
	 body.pos = cpv(192, 280);
	 body.angle = CC_DEGREES_TO_RADIANS(55);
	 
	 CCSprite *sprite = [CCSprite spriteWithFile:@"debug_staticBody-128x32.jpg"];
	 [sprite setPosition:body.pos];
	 [sprite setRotation:-55];
	 [sprite setScaleX:1.0f];
	 [sprite setScaleY:1.0f];
	 [self addChild:sprite];
	 
	 ChipmunkStaticPolyShape *shape = [_space add:[ChipmunkStaticPolyShape boxWithBody:body width:width height:height]];
	 shape.friction = 0.9;
	 shape.elasticity = 0.1;
	 shape.data = sprite;
	 }*/
	
	
	/*{ // Add a box
	 cpFloat mass = 5;
	 cpFloat width = 16;
	 cpFloat height = 128;
	 
	 ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:mass andMoment:cpMomentForBox(mass, width, height)]];
	 body.pos = cpv(192, 260);
	 
	 ChipmunkShape *shape = [_space add:[ChipmunkPolyShape boxWithBody:body width:width height:height]];
	 shape.friction = 0.7;
	 shape.collisionType = goalType;
	 }*/
	
	
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[GoalTarget class] begin:@selector(beginGoalCollision:space:) preSolve:@selector(preSolveGoalCollision:space:) postSolve:@selector(postSolveGoalCollision:space:) separate:@selector(separateGoalCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:borderType begin:@selector(beginWallCollision:space:) preSolve:@selector(preSolveWallCollision:space:) postSolve:@selector(postSolveWallCollision:space:) separate:@selector(separateWallCollision:space:)];
	
	//[self scheduleUpdate];
}


- (BOOL)beginGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	
	_cntTargets++;
	//NSLog(@"beginCollision: [%d]", _cntTargets);
	
	
	GoalTarget *trg = target.data;
	[arrTargets replaceObjectAtIndex:trg.ind withObject:@"YES"];
	[trg updateCovered:YES];
	
	int cnt = 0;
	for (int i=0; i<2; i++) {
		if([[arrTargets objectAtIndex:i] isEqualToString:@"YES"] && ![trg isCleared])
			cnt++;
	}
	
	trg.isCleared = YES;
	
	
	score_amt = (int)(cnt * 32);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ScoreChanged" object:[[NSNumber alloc] initWithInt:score_amt]];
	[[PlayStatsModel singleton] incScore:score_amt];
	
	//NSLog(@"0:[%@] 1:[%@] 2:[%@]", [arrTargets objectAtIndex:0], [arrTargets objectAtIndex:1], [arrTargets objectAtIndex:2]);
	
//	if ([[arrTargets objectAtIndex:0] isEqualToString:@"YES"] && [[arrTargets objectAtIndex:1] isEqualToString:@"YES"] && [[arrTargets objectAtIndex:2] isEqualToString:@"YES"]) {
//		NSLog(@"GOAL!!!!");
//		[_blob pop];
//		
//		//return (YES);
//	}
	
	//if (_cntTargets == 3)
	//	NSLog(@"GOAL!!!!");
	
	
	// When we created the collision shape for the FallingButton,
	// we set the data pointer to point at the FallingButton it was associated with.
	//FallingButton *fb = buttonShape.data;
	
	// Increment the touchedShapes counter on the FallingButton object.
	// We'll decrement this in the separate callback.
	// If the counter is 0, then you know you aren't touching anything.
	// You can use this technique in platformer games to track if the player is in the air on not.
	//fb.touchedShapes++;
	
	
	// begin and pre-solve callbacks MUST return a boolean.
	// Returning false from a begin callback ignores a collision permanently.
	// Returning false from a pre-solve callback ignores the collision for just one frame.
	// See the documentation on collision handlers for more information.
	return (NO);
}






- (BOOL)preSolveGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	
	NSLog(@"preSolveCollision");
	
	return (YES);
}

- (void)postSolveGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	
	// skip the later collisions
	//if (!cpArbiterIsFirstContact(arbiter)) 
	//	return;
	
	// force of the colliding bodies
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	
	NSLog(@"postSolveCollision:[%d] [%f]", _cntTargets, impulse);
}


- (void)separateGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	_cntTargets--;
	//NSLog(@"separateCollision: [%d]", _cntTargets);
	
	if ([[arrTargets objectAtIndex:0] isEqualToString:@"YES"] && [[arrTargets objectAtIndex:1] isEqualToString:@"YES"]) {
		NSLog(@"GOAL!!!!");
		[_blob pop];
		self.isTouchEnabled = NO;
		[self unschedule:@selector(physicsStepper:)];
		[self performSelector:@selector(clearArena:) withObject:self afterDelay:0.33];
	}

	
	
	GoalTarget *trg = target.data;
	[trg updateCovered:NO];
	[arrTargets replaceObjectAtIndex:trg.ind withObject:@"NO"];
}




- (BOOL)beginWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//NSLog(@"beginWallCollision");
	return (YES);
}

- (BOOL)preSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	
	//NSLog(@"preSolveWallCollision");
	
	return (YES);
}

- (void)postSolveWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	
	// skip the later collisions
	if (!cpArbiterIsFirstContact(arbiter))
		return;
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, wall);
	
	// force of the colliding bodies
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	
	//NSLog(@"postSolveWallCollision:[%f] (%@)", impulse, blobShape.collisionType);
}


-(void)addGib:(id)sender {
	
	cpFloat mass = CCRANDOM_0_1() * 2;
	float f = (CCRANDOM_0_1() * 32.0f) - 64.0f;
	
	ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:mass andMoment:INFINITY]];
	body.pos = cpv(gibPos.x, gibPos.y);
	[body applyImpulse:cpvmult(cpv(f, f), 3) offset:cpvzero];
	
	ChipmunkShape *shape = [_space add:[ChipmunkCircleShape circleWithBody:body radius:CCRANDOM_0_1() * 5 offset:cpvzero]];
	shape.friction = 0.125;
	shape.elasticity = 0.5;
	
	[arrGibs addObject:shape];
}

- (void)separateWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
	//NSLog(@"separateWallCollision: [%d]", _cntTargets);
	
	if (CCRANDOM_0_1() > 0.75) {
		gibPos = CGPointMake(blobShape.body.pos.x, blobShape.body.pos.y);
		[self performSelector:@selector(addGib:) withObject:nil afterDelay:0.05];
	}
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.25];
	[[SimpleAudioEngine sharedEngine] playEffect:@"debug_finger.wav"];
}


-(void) draw {
	//NSLog(@"///////[DRAW]////////");
	
	[super draw];
	[_blob draw];
	
	
	
	for (int i=0; i<[arrGibs count]; i++) {
		ChipmunkShape *shape = (ChipmunkShape *)[arrGibs objectAtIndex:i];
		ccDrawCircle(shape.body.pos, 3, 360, 4, NO);
	}
	
}

- (void)clearArena:(id)sender {
	NSLog(@"///////[clearArena]////////");
	
	[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[GoalTarget class]];
	
	//[_space remove:_blob];
	//[_space remove:goalTarget1];
	
	
	[self onLevelComplete:self];
	
}

-(void) mobWiggler:(id)sender {
	
	cpFloat maxForce = 4.0f;
	
	cpFloat rndForce = CCRANDOM_0_1() * maxForce;
	[_blob wiggleWithForce:[[RandUtils singleton]randIndex:BLOB_SEGS] force:rndForce];
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
	[_space release];
	[_multiGrab release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter {
    //NSLog(@"PlayScreenLayer.onEnter()");
    
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void) physicsStepper: (ccTime) dt {
	//NSLog(@"PlayScreenLayer.physicsStepper(%0.000000f)", [[CCDirector sharedDirector] getFPS]);
    
	[_space step:1.0 / 60.0];
	[_blob draw];
	
	
	for (int i=0; i<[arrGibs count]; i++) {
		ChipmunkShape *shape = (ChipmunkShape *)[arrGibs objectAtIndex:i];
		
		if (shape.body.pos.y <= 16){
			[arrGibs removeObjectAtIndex:i];
			[_space remove:shape.body];
			[_space remove:shape];
		}
	}
	
}


static cpVect
TouchLocation(UITouch *touch) {
	return ([[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]]);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event; {
	for(UITouch *touch in touches) 
		[_multiGrab beginLocation:TouchLocation(touch)];
	
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event; {
	for(UITouch *touch in touches) 
		[_multiGrab updateLocation:TouchLocation(touch)];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; {
	for(UITouch *touch in touches) 
		[_multiGrab endLocation:TouchLocation(touch)];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {	
    //NSLog(@"PlayScreenLayer.accelerometer()");
    
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float)(acceleration.x * kFilterFactor + (1 - kFilterFactor) * prevX);
	float accelY = (float)(acceleration.y * kFilterFactor + (1 - kFilterFactor) * prevY);
	
	prevX = accelX;
	prevY = accelY;
	
	_space.gravity = ccpMult(ccp(accelX, accelY), 32);
}


-(void) debuggingSetup {
	CCMenuItemFont *reset = [CCMenuItemFont itemFromString:@"reset" target:self selector: @selector(onResetArea:)];
	CCMenuItemFont *levelComplete = [CCMenuItemFont itemFromString:@"win" target:self selector: @selector(onLevelComplete:)];
	CCMenuItemFont *gameOver = [CCMenuItemFont itemFromString:@"end" target:self selector: @selector(onGameOver:)];
	CCMenu *mnuDebug = [CCMenu menuWithItems: reset, levelComplete, gameOver, nil];
	
	mnuDebug.position = ccp(160, 150);
	[mnuDebug alignItemsVerticallyWithPadding: 20.0f];
	[self addChild: mnuDebug];
}



-(void) onResetArea:(id)sender {
	
	
}


@end