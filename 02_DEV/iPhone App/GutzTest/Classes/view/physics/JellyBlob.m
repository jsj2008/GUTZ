#import "JellyBlob.h"

#import "ChipmunkDebugNode.h"

#import "CreatureDataPlistParser.h"

#import "GameConsts.h"
#import "GameConfig.h"
#import "GeomUtils.h"


#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

@implementation JellyBlob

@synthesize chipmunkObjects;
@synthesize posPt;
@synthesize radius;
@synthesize rFillColor;
@synthesize gFillColor;
@synthesize bFillColor;
@synthesize ccLayer;


-(id)initWithLvl:(int)lvl atPos:(cpVect)pos {
	
	if ((self = [super init])) {
		
		set = [NSMutableSet set];
		chipmunkObjects = set;
		
		posPt = CGPointMake(pos.x, pos.y);
		
		isStretched = NO;
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_long_stetch.mp3"];
		
		_plistCreatureData = [[CreatureDataPlistParser alloc] initWithLevel:lvl];
		_arrParts = [[NSArray alloc] initWithArray:_plistCreatureData.arrParts];
		_arrClamps = [[NSArray alloc] initWithArray:_plistCreatureData.arrClamps];
		
		totBodies = [_arrParts count];
		cpVect vt[totBodies];
		
		int xTot = 0;
		int yTot = 0;
		
		NSLog(@"%@.initWithLvl(%d) [%f, %f] // {%d}", [self class], lvl, pos.x, pos.y, totBodies);
		
		for(int q=0; q<totBodies; q++) {
			NSDictionary *dict = [_arrParts objectAtIndex:q];
			vt[q] = cpv([[dict objectForKey:@"x"] intValue], [[dict objectForKey:@"y"] intValue]);
			
			
			xTot += [[dict objectForKey:@"x"] intValue];
			yTot += [[dict objectForKey:@"y"] intValue];
			
			if ([[NSNumber alloc] initWithInt:[[dict objectForKey:@"type"] intValue]] == [NSNumber numberWithInt:0]) {
				[_arrSupportBodies addObject:dict];
				totSBodies++;
				
			} else {
				[_arrContourBodies addObject:dict];
				totCBodies++;
			}
		}
		
		_ctrPt = cpv(xTot / totBodies, yTot / totBodies);
		NSLog(@"CENTER:[%f, %f]", _ctrPt.x, _ctrPt.y);
		
		totSBodies = [_arrSupportBodies count];
		totCBodies = [_arrContourBodies count];
		

		_centralBody = [ChipmunkBody bodyWithMass:CENTRAL_MASS andMoment:cpMomentForCircle(CENTRAL_MASS, 0, CENTRAL_RADIUS, cpvzero)];
		[set addObject:_centralBody];
		_centralBody.pos = posPt;
		
		ChipmunkShape *centralShape = [ChipmunkCircleShape circleWithBody:_centralBody radius:CENTRAL_RADIUS offset:cpvzero];
		[set addObject:centralShape];
		centralShape.group = self;
		centralShape.layers = GRABABLE_LAYER;
		centralShape.collisionType = [JellyBlob class];
		
	
		bodies = [[NSMutableArray alloc] initWithCapacity:totBodies];
		_edgeBodies = bodies;
		
		
		for(int i=0; i<[_arrParts count]; i++) {
			NSDictionary *dict = [_arrParts objectAtIndex:i];
			
			int radPart = [[dict objectForKey:@"radius"] intValue];
			cpVect vecPos = cpv([[dict objectForKey:@"x"] intValue], [[dict objectForKey:@"y"] intValue]);
			cpVect vecOffsetCenter = cpvsub(vecPos, _ctrPt);
			cpVect slope = cpvnormalize(vecOffsetCenter);
			
			cpVect vecOffsetPos = cpvadd(posPt, vecOffsetCenter);
			
			ChipmunkBody *body = [ChipmunkBody bodyWithMass:(1.0f / totBodies) andMoment:INFINITY];
			body.pos = vecOffsetPos;
			body.data = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"type"] intValue]];
			[bodies addObject:body];
			
			ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:radPart offset:cpvzero];
			[set addObject:shape];
			shape.elasticity = EDGE_BOUNCE;
			shape.friction = EDGE_FRICTION;
			shape.group = self;
			shape.layers = GRABABLE_LAYER;
			shape.collisionType = [JellyBlob class];
			
			
			switch ([[dict objectForKey:@"type"] intValue]) {
				case 0:
					[_arrSupportBodies addObject:body];
					cpVect springOffset = cpvmult(slope, CENTRAL_RADIUS + radPart * 2);
					[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:springOffset anchr2:cpvzero restLength:0 stiffness:SPRING_STR damping:SPRING_DAMP]];
					//[set addObject:[ChipmunkPinJoint pinJointWithBodyA:_centralBody bodyB:body anchr1:_centralBody.pos anchr2:body.pos]];
					break;
					
				case 1:
					break;
					
				case 3:
					[_arrContourBodies addObject:body];
					break;
			}
			
			
			if ([[dict objectForKey:@"type"] intValue] == 0) {
				NSLog(@"PART[%d] /> TYPE:[%d] @ [%f, %f] // SLOPE{%f, %f}", i, [[dict objectForKey:@"type"] intValue], body.pos.x, body.pos.y, slope.x, slope.y);
				
			}
			
			
			//NSLog(@"PART[%d] /> RAD:[%d] @ [%f, %f] // SLOPE{%f, %f}", i, radius, body.pos.x, body.pos.y, slope.x, slope.y);
		}
		
		[set addObjectsFromArray:bodies];
			
		
		for (int i=0; i<[_arrClamps count]; i++) {
			NSDictionary *dict = [_arrClamps objectAtIndex:i];
			
			float stiff = (float)[[dict objectForKey:@"str"] floatValue];
			float dampn = (float)[[dict objectForKey:@"damp"] floatValue];
			
			//NSLog(@"CLAMP:[%d] BODIES[%d]<>[%d] // STR:[%f] DAMP:[%f]", i, [[dict objectForKey:@"body1"] intValue], [[dict objectForKey:@"body2"] intValue], stiff, dampn);
			
			ChipmunkBody *a = [bodies objectAtIndex:[[dict objectForKey:@"body1"] intValue]];
			ChipmunkBody *b = [bodies objectAtIndex:[[dict objectForKey:@"body2"] intValue]];
			
			if (a && b) {
				[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:cpvdist(a.pos, b.pos) stiffness:stiff damping:dampn]];
				//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:cpvdist(a.pos, b.pos)]];
										 
			}
		}
	}
	
	return (self);
}

-(id)initWithPos:(cpVect)pos radius:(cpFloat)rad count:(int)count {
	NSLog(@"%@.initWithPos(%f, %d)", [self class], rad, count);
	
	if ((self = [super init])) {
		set = [NSMutableSet set];
		chipmunkObjects = set;
		
		isStretched = NO;
		totCBodies = 0;
		totSBodies = 0;
		totBodies = 0;
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_long_stetch.mp3"];
		
		posPt = CGPointMake(pos.x, pos.y);
		totBodies = count;
		radius = rad;
		
		
		_eyeSprite = [CCSprite spriteWithFile:@"eye.png"];
		[_eyeSprite setPosition:cpv(posPt.x, posPt.y - 8)];
		[_eyeSprite setScale:0.2f];
		
		
		_mouthSprite = [CCSprite spriteWithFile:@"smile.png"];
		[_mouthSprite setPosition:cpv(posPt.x, posPt.y + 5)];
		[_mouthSprite setScale:0.5f];
		
		[self constructCenter];
		[self constructEdges];
	}
	
	return (self);
}



-(void)constructCenter {
	
	_centralBody = [ChipmunkBody bodyWithMass:CENTRAL_MASS andMoment:cpMomentForCircle(CENTRAL_MASS, 0, radius, cpvzero)];
	[set addObject:_centralBody];
	_centralBody.pos = posPt;
	
	_centerSprite = [CCSprite spriteWithFile:@"jellyCenter.png"];
	[_centerSprite setScale:radius / 23.0f];
	[_centerSprite setPosition:posPt];
	
	cpVect vt[totBodies];
	for(int i=0; i<totBodies; i++){
		cpVect slope = cpvforangle(((cpFloat)totBodies - i) / (cpFloat)totBodies * 2.0 * M_PI);
		cpVect posMult = cpvmult(slope, radius);
		
		vt[i] = cpvadd(posMult, cpvzero);
		//NSLog(@"vt[%d]: (%f, %f)", i, vt[i].x, vt[i].y);
	}
	
	
	//ChipmunkShape *centralShape = [ChipmunkPolyShape polyWithBody:_centralBody count:count verts:vt offset:cpvzero];
	ChipmunkShape *centralShape = [ChipmunkCircleShape circleWithBody:_centralBody radius:radius offset:cpvzero];
	[set addObject:centralShape];
	centralShape.group = self;
	centralShape.layers = GRABABLE_LAYER;
	centralShape.collisionType = [JellyBlob class];
	
	
}

-(void)constructEdges {
	
	cpFloat edgeMass = 2.0f / totBodies;
	cpFloat edgeDistance = 2.0f * radius * cpfsin(M_PI / (cpFloat)totBodies);
	_edgeRadius = edgeDistance * 1.33f;
	
	//cpFloat squishCoef = 0.7;
	cpFloat springStiffness = 80.0f;
	cpFloat springDamping = 1.0f;
	
	_edgeSprites = [[NSMutableArray alloc] initWithCapacity:totBodies];
	bodies = [[NSMutableArray alloc] initWithCapacity:totBodies];
	_edgeBodies = bodies;
	
	for(int i=0; i<totBodies; i++){
		cpVect slope = cpvforangle((cpFloat)i / (cpFloat)totBodies * 2.0 * M_PI);
		cpVect posMult = cpvmult(slope, radius);
		
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:edgeMass andMoment:INFINITY];
		body.pos = cpvadd(posPt, posMult);
		[bodies addObject:body];
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"jellyEdge.png"];
		[sprite setPosition:body.pos];
		[sprite setScale:_edgeRadius / 9.0f];
		[_edgeSprites addObject:sprite];
		
		//ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius * ((CCRANDOM_0_1() * 1) + 0.5) offset:cpvzero];
		ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius offset:cpvzero];
		[set addObject:shape];
		shape.elasticity = EDGE_BOUNCE;
		shape.friction = EDGE_FRICTION;
		shape.group = self;
		shape.layers = NORMAL_LAYER;
		shape.collisionType = [JellyBlob class];
		
		//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:_centralBody bodyB:body anchr1:cpvzero anchr2:cpvzero min:0 max:radius*squishCoef]];
		
		cpVect springOffset = cpvmult(slope, radius + _edgeRadius);
		[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:springOffset anchr2:cpvzero restLength:0 stiffness:SPRING_STR damping:SPRING_DAMP]];
	}
	
	[set addObjectsFromArray:bodies];
	
	
	
	
	for (int i=0; i<totBodies; i++) {
		ChipmunkBody *a = [bodies objectAtIndex:i];
		ChipmunkBody *b = [bodies objectAtIndex:(i + 1) % totBodies];
		//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:edgeDistance * 1.1]];
		
		// add'l
		[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
	}
	
}


-(void)adoptSprites:(CCLayer *)layer {
		
	for (CCSprite *sprite in _edgeSprites)
		[layer addChild:sprite];
	
	[layer addChild:_centerSprite];
	[layer addChild:_eyeSprite];
	[layer addChild:_mouthSprite];
}

-(void)updSprites {
	int cnt = 0;
	
	[_centerSprite setPosition:posPt];
	[_eyeSprite setPosition:cpv([self posPt].x, [self posPt].y + 12)];
	[_mouthSprite setPosition:cpv([self posPt].x, [self posPt].y - 12)];
	
	for (ChipmunkBody *body in bodies) {
		CCSprite *sprite = [_edgeSprites objectAtIndex:cnt];
		[sprite setPosition:body.pos];
		cnt++;
	}
}

-(void)flushSprites:(CCLayer *)layer {
	
	[layer removeChild:_centerSprite cleanup:NO];
	[layer removeChild:_eyeSprite cleanup:NO];
	[layer removeChild:_mouthSprite cleanup:NO];
	
	for (CCSprite *sprite in _edgeSprites)
		[layer removeChild:sprite cleanup:NO];
}

-(ChipmunkBody *)findByID:(int)val {
	//NSLog(@"%@.findInnerNode(%d)", [self class], ind);
	
	for (int i=0; i<[_arrParts count]; i++) {
		NSDictionary *dict = [_arrParts objectAtIndex:i];
		
		if ((int)[dict objectForKey:@"id"] == val)
			return ([_edgeBodies objectAtIndex:i]);
	}
	
	return (nil);
}




-(ChipmunkBody *)touchedBodyAt:(CGPoint)pos {
	ChipmunkBody *body;
	
	
	for (int i=0; i<[_arrParts count]; i++) {
		body = [_arrParts objectAtIndex:i];
		
		if (cpvnear(body.pos, pos, 15))
			return (body);
	}
	
	
	return (body);
}


-(int)bodyIndexAt:(CGPoint)pos {
	
	for (int i=0; i<[_edgeBodies count]; i++) {
		ChipmunkBody *body = [_edgeBodies objectAtIndex:i];
		
		if (cpvnear(body.pos, pos, 15)) {
			//NSLog(@"JellyBlob.bodyIndexAt[%d]", i);
			
			return (i);
		}
	}
	
	
	return (-1);
}

-(void)draw {
	cpVect center = _centralBody.pos;
	posPt = _centralBody.pos;
	
	
	glColor4f(0.00f, 0.87, 1.00f, 1.00f);
	
	cpVect verts[[bodies count]];
	for (int i=0; i<[_edgeBodies count]; i++) {
		cpVect v = [[_edgeBodies objectAtIndex:i] pos];
		ccDrawCircle(v, _edgeRadius, 360, 16, !kDrawChipmunkObjs);
		
		verts[i] = cpvadd(v, cpvmult(cpvnormalize(cpvsub(v, center)), _edgeRadius * 0.85));
	}
	verts[[bodies count]] = verts[0];
	
	
	//float area = [[GeomUtils singleton] polygonArea:verts];
	//NSLog(@"--> AREA:[%f]", area);
	
	/*if ((int)area > 24000) {
		//NSLog(@"--> AREA:[%f]", area);
		
		if (!isStretched) {
			isStretched = YES;
			
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.875f];
			[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_long_stretch.mp3"];
		}
	}
	
	
	if ((int)area < 17500) {
		//NSLog(@"<-- AREA:[%f]", area);
		if (isStretched) {
			isStretched = NO;
		}
	}*/
	
	//ChipmunkDebugDrawPolygon(_count, verts, LAColor(0, 1), LAColor(0, 0));
	
	glEnable(GL_LINE_SMOOTH);
	
	glColor4f(0.00f, 0.87, 1.00f, 1.00f);
	ccDrawPoly(verts, [_edgeBodies count], !kDrawChipmunkObjs);
	
	glLineWidth(1.0f);
	glColor4f(0.00f, 0.00f, 0.00f, 1.00f);
	ccDrawPoly(verts, [_edgeBodies count], NO);
}

-(void)resetStretch:(id)sender {
	NSLog(@"resetStretch");
	isStretched = NO;
}
	
-(void)wiggleWithForce:(int)index force:(cpFloat)f {
	
	ChipmunkBody *body = [_edgeBodies objectAtIndex:index];
	
	[_centralBody applyImpulse:cpvmult(cpv(f * CCRANDOM_MINUS1_1(), f * CCRANDOM_MINUS1_1()), 16) offset:cpvzero];
	[body applyImpulse:cpv(f, f) offset:_centralBody.pos];
}

-(void)pop {
	
	/*
	 id eyeAction = [CCMoveTo actionWithDuration:0.33f position:ccp((CCRANDOM_0_1() * 200) + 64, (CCRANDOM_0_1() * 360) + 64)];
	 id mouthActon = [CCMoveTo actionWithDuration:0.33f position:ccp((CCRANDOM_0_1() * 200) + 64, -((CCRANDOM_0_1() * 300) + 64))];
	 [eyeSprite runAction:[CCEaseIn actionWithAction:[eyeAction copy] rate:0.9f]];
	 [mouthSprite runAction:[CCEaseIn actionWithAction:[mouthActon copy] rate:0.2f]];
	 */
	
	//if (!isPopped) {
		
		isPopped = YES;
	
		for (int i=0; i<totBodies; i++) {
			ChipmunkBody *body = [_edgeBodies objectAtIndex:i];
			[body applyImpulse:cpv(64, 64) offset:cpvzero];
		}
	//}
	
}


-(void)pulsate:(CGPoint)pos {
	
	//cpVect offset = cpvsub(pos, _centralBody.pos);
	NSLog(@"pulsate.(%f, %f)", pos.x, pos.y);
	
	
	for (int i=0; i<totBodies; i++) {
		cpVect slope = cpvforangle(((cpFloat)totBodies - i) / (cpFloat)totBodies * 2.0 * M_PI);
		
		ChipmunkBody *body = [_edgeBodies objectAtIndex:i];
		[body applyImpulse:cpvmult(slope, 20) offset:cpvzero];
	}
}
		
	
-(void)destroy {
											  
}
	

- (void)dealloc {
	[_centralBody release];
	[_edgeBodies release];
	
	chipmunkObjects = nil;
	
	[super dealloc];
}

@end
