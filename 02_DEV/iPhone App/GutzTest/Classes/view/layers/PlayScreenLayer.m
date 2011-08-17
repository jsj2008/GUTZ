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

@synthesize splatExploAction;
@synthesize splatDripsAction;


-(id)initWithLevel:(int)lvl {
	NSLog(@"%@.initWithLevel(%d)", [self class], lvl);
	
	indLvl = lvl;
	return ([self init]);
}



-(id) init {
	NSLog(@"%@.init()", [self class]);
	
	//if ((self = [super initWithBackround:@"background_play.jpg"])) {
	if ((self = [super initWithColor:ccc4(233, 86, 86, 255)])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		_cnt = 32;
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"debug_finger.wav"];
		
		isCleared = NO;
		
		arrTouchedEdge = [[NSMutableArray alloc] init];
		
		[self chipmunkSetup];
		[self scaffoldHUD];
		[self performSelector:@selector(physProvoker:) withObject:self afterDelay:0.33f];
	}
	
	return (self);
}



- (void)physProvoker:(id)sender {
	[self schedule:@selector(physicsStepper:)];
	[self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.125f)];
}


-(void) scaffoldHUD {
	
	CCMenuItemImage *btnPause = [CCMenuItemImage itemFromNormalImage:@"HUD_pauseButton_nonActive.png" selectedImage:@"HUD_pauseButton_Active.png" target:nil selector:nil];
	CCMenuItemImage *btnPlay = [CCMenuItemImage itemFromNormalImage:@"HUD_pauseButton_nonActive.png" selectedImage:@"HUD_pauseButton_Active.png" target:nil selector:nil];
	btnPlayPauseToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(onPlayPauseToggle:) items:btnPause, btnPlay, nil];
	CCMenu *mnuPlayPause = [CCMenu menuWithItems: btnPlayPauseToggle, nil];
	
	mnuPlayPause.position = ccp(280, 440);
	[mnuPlayPause alignItemsVerticallyWithPadding: 20.0f];
	[self addChild: mnuPlayPause];
	
	//hudStarsSprite = [[LvlStarSprite alloc] init];
	//[hudStarsSprite setPosition:ccp(130, 50)];
	//[self addChild:hudStarsSprite];
	
	//scoreDisplaySprite = [[ScoreSprite alloc] init];
	//[scoreDisplaySprite setPosition:ccp(55, 450)];
	//[self addChild:scoreDisplaySprite];
	
	//timeDisplaySprite = [[ElapsedTimeSprite alloc] init];
	//[timeDisplaySprite setPosition:ccp(250, 32)];
	//[self addChild:timeDisplaySprite];
	
	
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
	
	[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space] z:0 tag:666];
	
	arrGibsShape = [[NSMutableArray alloc] init];
	arrGibsSprite = [[NSMutableArray alloc] init];
	
	arrTargets = [[NSMutableArray alloc] initWithCapacity:2];
	[arrTargets addObject:@"NO"];
	[arrTargets addObject:@"NO"];
	
	CGPoint goal1Pos;
	CGPoint goal2Pos;
	
	switch (indLvl) {
			
		case 1:
			goal1Pos = CGPointMake(32, 420);
			goal2Pos = CGPointMake(280, 50);
			break;
			
		case 2:
			goal1Pos = CGPointMake(32, 400);
			goal2Pos = CGPointMake(32, 50);
			break;
			
		case 3:
			goal1Pos = CGPointMake(160, 420);
			goal2Pos = CGPointMake(160, 50);
			break;
			
		default:
			goal1Pos = CGPointMake(32, 420);
			goal2Pos = CGPointMake(280, 50);
			indLvl = 1;
			break;
	}
	
	
	goalTarget1 = [[GoalTarget alloc] initAtPos:goal1Pos];
	goalTarget1.ind = 0;
	[_space add:goalTarget1];
	[self addChild:goalTarget1._sprite];
	
	goalTarget2 = [[GoalTarget alloc] initAtPos:goal2Pos];
	goalTarget2.ind = 1;
	[_space add:goalTarget2];
	[self addChild:goalTarget2._sprite];
	
	
	cpFloat width = 194;
	cpFloat height = 39;
	
	
	if (indLvl == 2) {
		width = 194;
		height = 39;
		
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		body.pos = cpv(100, 280);
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"blocker.png"];
		[sprite setPosition:body.pos];
		[self addChild:sprite];
		
		ChipmunkStaticPolyShape *shape = [_space add:[ChipmunkStaticPolyShape boxWithBody:body width:width height:height]];
		shape.friction = 0.9;
		shape.elasticity = 0.1;
		shape.data = sprite;
		
	} else if (indLvl == 3) {
		width = 108;
		height = 39;
		
		ChipmunkBody *body1 = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		body1.pos = cpv(160, 320);
		
		CCSprite *sprite1 = [CCSprite spriteWithFile:@"blocker_B_.png"];
		[sprite1 setPosition:body1.pos];
		[self addChild:sprite1];
		
		ChipmunkStaticPolyShape *shape1 = [_space add:[ChipmunkStaticPolyShape boxWithBody:body1 width:width height:height]];
		shape1.friction = 0.9;
		shape1.elasticity = 0.1;
		shape1.data = sprite1;
		
		
		ChipmunkBody *body2 = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		body2.pos = cpv(160, 140);
		
		CCSprite *sprite2 = [CCSprite spriteWithFile:@"blocker_B_.png"];
		[sprite2 setPosition:body2.pos];
		[self addChild:sprite2];
		
		ChipmunkStaticPolyShape *shape2 = [_space add:[ChipmunkStaticPolyShape boxWithBody:body2 width:width height:height]];
		shape2.friction = 0.9;
		shape2.elasticity = 0.1;
		shape2.data = sprite2;
	}
	
	_blob = [[JellyBlob alloc] initWithPos:cpv(BLOB_X, BLOB_Y) radius:BLOB_RADIUS count:BLOB_SEGS];
	[_space add:_blob];
	
	creatureSprite = [CCSprite spriteWithFile:@"test.png"];
	[creatureSprite setPosition:ccp(BLOB_X, BLOB_Y)];
	[creatureSprite setScale:0.33f];
	//[self addChild:creatureSprite];
	
	eyeSprite = [CCSprite spriteWithFile:@"eye.png"];
	[eyeSprite setPosition:cpv(BLOB_X, BLOB_Y - 24)];
	[eyeSprite setScale:0.33f];
	[self addChild:eyeSprite];
	
	
	mouthSprite = [CCSprite spriteWithFile:@"mouth.png"];
	[mouthSprite setPosition:cpv(BLOB_X, BLOB_Y + 24)];
	[mouthSprite setScale:0.33f];
	[self addChild:mouthSprite];
	
	
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:[GoalTarget class] begin:@selector(beginGoalCollision:space:) preSolve:@selector(preSolveGoalCollision:space:) postSolve:@selector(postSolveGoalCollision:space:) separate:@selector(separateGoalCollision:space:)];
	[_space addCollisionHandler:self typeA:[JellyBlob class] typeB:borderType begin:@selector(beginWallCollision:space:) preSolve:@selector(preSolveWallCollision:space:) postSolve:@selector(postSolveWallCollision:space:) separate:@selector(separateWallCollision:space:)];
}


- (BOOL)beginGoalCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, target);
	
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
	
	
	//NSLog(@"separateCollision: [%d]", _cntTargets);
	
	if ([[arrTargets objectAtIndex:0] isEqualToString:@"YES"] && [[arrTargets objectAtIndex:1] isEqualToString:@"YES"]) {
		NSLog(@"GOAL!!!! [%d]", [arrTouchedEdge count]);
		
		//for (int i=0; i<[arrTouchedEdge count]; i++) 
		//[_blob pop];
		isCleared = YES;
		self.isTouchEnabled = NO;
		[_space removeCollisionHandlerForTypeA:[JellyBlob class] andB:[GoalTarget class]];
		[_space addPostStepCallback:self selector:@selector(clearArena:) key:_blob];
		//[self performSelector:@selector(clearArena:) withObject:self afterDelay:0.33];
	}
	
	
	
	GoalTarget *trg = target.data;
	[trg updateCovered:NO];
	[arrTargets replaceObjectAtIndex:trg.ind withObject:@"NO"];
}


- (void)clearArena:(id)sender {
	NSLog(@"///////[clearArena]////////");
	
	//[self removeChild:lEyeSprite cleanup:NO];
	//[self removeChild:rEyeSprite cleanup:NO];
	
	//[self unschedule:@selector(physicsStepper:)];
	//[_space remove:_blob];
	//[_space remove:goalTarget1];
	//[_space remove:goalTarget2];
	
	//[_space addPostStepRemoval:goalTarget1];
	//[_space addPostStepRemoval:goalTarget2];
	//[_space addPostStepRemoval:_blob];
	
	[self removeChildByTag:666 cleanup:NO];
	
	
	for (int i=0; i<((int)CCRANDOM_0_1()*16)+32; i++) {
		[self addGib:nil];
	}
	
	
	id eyeAction = [CCMoveTo actionWithDuration:0.33f position:ccp((CCRANDOM_0_1() * 200) + 64, (CCRANDOM_0_1() * 360) + 64)];
	id mouthActon = [CCMoveTo actionWithDuration:0.33f position:ccp((CCRANDOM_0_1() * 200) + 64, -((CCRANDOM_0_1() * 300) + 64))];
	[eyeSprite runAction:[CCEaseIn actionWithAction:[eyeAction copy] rate:0.9f]];
	[mouthSprite runAction:[CCEaseIn actionWithAction:[mouthActon copy] rate:0.2f]];
	
	[self removeChild:goalTarget1._sprite cleanup:NO];
	[self removeChild:goalTarget2._sprite cleanup:NO];
	
	
	
	
	id dieAction = [CCScaleTo actionWithDuration:0.01f scale:0.0f];
	
	CCSprite *derpSprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
	[derpSprite setScale:0.25f];
	[derpSprite setPosition:gibPos];
	[self addChild:derpSprite];
	
	id scaleAction = [CCScaleTo actionWithDuration:0.33f scale:17.0f];
	id centerAction = [CCMoveTo actionWithDuration:0.5f position:ccp((CCRANDOM_0_1() * 64) + 128, (CCRANDOM_0_1() * 200) + 160)];
	id moveAction = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -((CCRANDOM_0_1() * 32) + 160))];
	[derpSprite runAction:[CCEaseIn actionWithAction:[scaleAction copy] rate:0.2f]];
	[derpSprite runAction:[CCSequence actions:[CCEaseIn actionWithAction:[centerAction copy] rate:0.2f], [CCEaseOut actionWithAction:[moveAction copy] rate:0.33f], [dieAction copy], nil]];
	
	
	CCSprite *derp2Sprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
	[derp2Sprite setScale:0.25f];
	[derp2Sprite setPosition:gibPos];
	[self addChild:derp2Sprite];
	
	id scale2Action = [CCScaleTo actionWithDuration:0.33f scale:14.0f];
	id center2Action = [CCMoveTo actionWithDuration:0.5f position:ccp((CCRANDOM_0_1() * 64) + 128, 260)];
	id move2Action = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -((CCRANDOM_0_1() * 32) + 128))];
	[derp2Sprite runAction:[CCEaseElasticInOut actionWithAction:[scale2Action copy] period:0.5f]];
	[derp2Sprite runAction:[CCSequence actions:[CCEaseIn actionWithAction:[center2Action copy] rate:0.5f], [CCEaseOut actionWithAction:[move2Action copy] rate:0.25f], [dieAction copy], nil]];
	
	CCSprite *derp3Sprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
	[derp3Sprite setScale:0.25f];
	[derp3Sprite setPosition:gibPos];
	[self addChild:derp3Sprite];
	
	id scale3Action = [CCScaleTo actionWithDuration:0.25f scale:13.5f];
	id center3Action = [CCMoveTo actionWithDuration:0.5f position:ccp((CCRANDOM_0_1() * 64) + 64, (CCRANDOM_0_1() * 64) + 300)];
	id move3Action = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -((CCRANDOM_0_1() * 32) + 160))];
	[derp3Sprite runAction:[CCEaseIn actionWithAction:[scale3Action copy] rate:0.9f]];
	[derp3Sprite runAction:[CCSequence actions:[CCEaseIn actionWithAction:[center3Action copy] rate:0.25f], [CCEaseOut actionWithAction:[move3Action copy] rate:0.2f], [dieAction copy], nil]];
	
	
	CCSprite *derp4Sprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
	[derp4Sprite setScale:0.25f];
	[derp4Sprite setPosition:gibPos];
	[self addChild:derp4Sprite];
	
	id scale4Action = [CCScaleTo actionWithDuration:0.3f scale:13.0f];
	id center4Action = [CCMoveTo actionWithDuration:0.5f position:ccp(220, (CCRANDOM_0_1() * 64) + 300)];
	id move4Action = [CCMoveBy actionWithDuration:0.5f position:ccp(0, -((CCRANDOM_0_1() * 32) + 128))];
	[derp4Sprite runAction:[CCEaseElasticInOut actionWithAction:[scale4Action copy] period:0.7f]];
	[derp4Sprite runAction:[CCSequence actions:[CCEaseIn actionWithAction:[center4Action copy] rate:0.33f], [CCEaseOut actionWithAction:[move4Action copy] rate:0.25f], [dieAction copy], nil]];
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95];
	[[SimpleAudioEngine sharedEngine] playEffect:@"debug_redmag.wav"];
	
	[self schedule:@selector(flashBG) interval:0.1];
	
	[self performSelector:@selector(onLevelComplete:) withObject:self afterDelay:1];
	//[self onLevelComplete:self];
	
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
	//cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
	
	//NSLog(@"postSolveWallCollision:[%f] (%@)", impulse, blobShape.collisionType);
}


-(void)addGib:(id)sender {
	
	float fx = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	float fy = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	
	float rad = (CCRANDOM_0_1() * 4) + 1;
	
	CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"gut_bits0%d.png", (int)rad]];
	[sprite setScale:0.2f];
	[sprite setPosition:gibPos];
	[self addChild:sprite];
	
	if (gibPos.x < 100)
		fx *= -1;
	
	ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:rad * 0.33f andMoment:INFINITY]];
	body.pos = cpv(gibPos.x, gibPos.y);
	[body setTorque:CCRANDOM_0_1() * 16.0f];
	[body applyImpulse:cpvmult(cpv(fx, fy), 3) offset:cpvzero];
	
	
	
	ChipmunkShape *shape = [_space add:[ChipmunkCircleShape circleWithBody:body radius:rad offset:cpvzero]];
	shape.friction = 0.25;
	shape.elasticity = 0.875;
	
	[arrGibsShape addObject:shape];
	[arrGibsSprite addObject:sprite];
}


-(void)addGib2 {
	
	cpFloat mass = CCRANDOM_0_1() * 2;
	float fx = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	float fy = (CCRANDOM_0_1() * 32.0f) + 64.0f;
	
	CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"gut_bits0%d.png", ((int)(CCRANDOM_0_1() * 4) + 1)]];
	[sprite setScale:0.2f];
	[sprite setPosition:gibPos];
	[self addChild:sprite];
	
	ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:mass andMoment:INFINITY]];
	body.pos = cpv(gibPos.x, gibPos.y);
	[body setTorque:CCRANDOM_0_1() * 16.0f];
	[body applyImpulse:cpvmult(cpv(fx, fy), 3) offset:cpvzero];
	
	
	ChipmunkShape *shape = [_space add:[ChipmunkCircleShape circleWithBody:body radius:(CCRANDOM_0_1() * 10) + 5 offset:cpvzero]];
	shape.friction = 0.25;
	shape.elasticity = 0.875;
	
	[arrGibsShape addObject:shape];
	[arrGibsSprite addObject:sprite];
}

- (void)separateWallCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, blobShape, wall);
	
	//NSLog(@"separateWallCollision: [%d]", _cntTargets);
	
	if (CCRANDOM_0_1() > 0.875) {
		gibPos = CGPointMake(blobShape.body.pos.x, blobShape.body.pos.y);
		[self performSelector:@selector(addGib:) withObject:nil afterDelay:0.05];
	}
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.25];
	[[SimpleAudioEngine sharedEngine] playEffect:@"debug_finger.wav"];
}


-(void) draw {
	//NSLog(@"///////[DRAW]////////");
	
	[super draw];
	
	if (!isCleared) {
		[_blob draw];
		
		
	} else {
		
	}
	
	
	
	//for (int i=0; i<[arrGibs count]; i++) {
	//	ChipmunkShape *shape = (ChipmunkShape *)[arrGibs objectAtIndex:i];
	//	ccDrawCircle(shape.body.pos, 3, 360, 4, NO);
	//}
	
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
	
	[ScreenManager goLevelComplete:indLvl];
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
	
	self.splatDripsAction = nil;
	self.splatExploAction = nil;
	
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
	
	
	for (int i=0; i<[arrGibsShape count]; i++) {
		ChipmunkShape *shape = (ChipmunkShape *)[arrGibsShape objectAtIndex:i];
		CCSprite *sprite = (CCSprite *)[arrGibsSprite objectAtIndex:i];
		
		
		[sprite setPosition:shape.body.pos];
		[sprite setRotation:-shape.body.angle];
		
		if (shape.body.pos.y <= 16){
			[arrGibsShape removeObjectAtIndex:i];
			[arrGibsSprite removeObjectAtIndex:i];
			
			[_space remove:shape.body];
			[_space remove:shape];
			[self removeChild:sprite cleanup:NO];
		}
	}
	
	//[creatureSprite setPosition:[_blob posPt]];
	
	if (!isCleared) {
		[eyeSprite setPosition:cpv([_blob posPt].x, [_blob posPt].y + 24)];
		[mouthSprite setPosition:cpv([_blob posPt].x, [_blob posPt].y - 24)];
	}
}


static cpVect
TouchLocation(UITouch *touch) {
	return ([[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]]);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event; {
	for(UITouch *touch in touches) {
		[_multiGrab beginLocation:TouchLocation(touch)];
		
		int ind = [_blob bodyIndexAt:TouchLocation(touch)];
		
		if (ind >= 0) {
			//NSLog(@"PlayScreenLayer.ccTouchesBegan(%d)", ind);
			[arrTouchedEdge addObject:[NSString stringWithFormat:@"E_%d", ind]];
		}
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event; {
	for(UITouch *touch in touches) {
		[_multiGrab updateLocation:TouchLocation(touch)];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; {
	for(UITouch *touch in touches) {
		[_multiGrab endLocation:TouchLocation(touch)];
		
		
		int ind = [_blob bodyIndexAt:TouchLocation(touch)];
		
		//if (ind >= 0) {
		//NSLog(@"PlayScreenLayer.ccTouchesEnded(%d)", ind);
			
			for (int i=0; i<[arrTouchedEdge count]; i++) {
				if ([[arrTouchedEdge objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"E_%d", ind]]) {
					[arrTouchedEdge removeObjectAtIndex:i];
				}
			}
		//}
	}
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


-(void)flashBG {
	
	if (bg_cnt % 2 == 0)
		[self setColor:ccc3(229, 220, 7)];
	
	else
		[self setColor:ccc3(233, 86, 86)];
	
	
	bg_cnt++;
	
	
	if (bg_cnt >= 9)
		[self unschedule:@selector(flashBG)];
}


@end