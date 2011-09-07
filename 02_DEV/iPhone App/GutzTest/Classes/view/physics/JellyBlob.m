#import "JellyBlob.h"

#import "ChipmunkDebugNode.h"

#import "CreatureDataPlistParser.h"

#import "GameConsts.h"
#import "GeomUtils.h"


#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

@implementation JellyBlob

@synthesize chipmunkObjects;
@synthesize posPt;
@synthesize rFillColor;
@synthesize gFillColor;
@synthesize bFillColor;


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
			
			int radius = [[dict objectForKey:@"radius"] intValue];
			cpVect vecPos = cpv([[dict objectForKey:@"x"] intValue], [[dict objectForKey:@"y"] intValue]);
			cpVect vecOffsetCenter = cpvsub(vecPos, _ctrPt);
			cpVect slope = cpvnormalize(vecOffsetCenter);
			
			cpVect vecOffsetPos = cpvadd(posPt, vecOffsetCenter);
			
			ChipmunkBody *body = [ChipmunkBody bodyWithMass:(1.0f / totBodies) andMoment:INFINITY];
			body.pos = vecOffsetPos;
			body.data = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"type"] intValue]];
			[bodies addObject:body];
			
			ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:radius offset:cpvzero];
			[set addObject:shape];
			shape.elasticity = EDGE_BOUNCE;
			shape.friction = EDGE_FRICTION;
			shape.group = self;
			shape.layers = GRABABLE_LAYER;
			shape.collisionType = [JellyBlob class];
			
			
			switch ([[dict objectForKey:@"type"] intValue]) {
				case 0:
					[_arrSupportBodies addObject:body];
					cpVect springOffset = cpvmult(slope, CENTRAL_RADIUS + radius * 2);
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

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count {
	NSLog(@"%@.initWithPos(%f, %d)", [self class], radius, count);
	
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
		_radius = radius;
		
		[self constructCenter];
		[self constructEdges];
	}
	
	return (self);
}



-(void)constructCenter {
	
	_centralBody = [ChipmunkBody bodyWithMass:CENTRAL_MASS andMoment:cpMomentForCircle(CENTRAL_MASS, 0, _radius, cpvzero)];
	[set addObject:_centralBody];
	_centralBody.pos = posPt;
	
	
	cpVect vt[totBodies];
	for(int i=0; i<totBodies; i++){
		cpVect slope = cpvforangle(((cpFloat)totBodies - i) / (cpFloat)totBodies * 2.0 * M_PI);
		cpVect posMult = cpvmult(slope, _radius);
		
		vt[i] = cpvadd(posMult, cpvzero);
		//NSLog(@"vt[%d]: (%f, %f)", i, vt[i].x, vt[i].y);
	}
	
	
	//ChipmunkShape *centralShape = [ChipmunkPolyShape polyWithBody:_centralBody count:count verts:vt offset:cpvzero];
	ChipmunkShape *centralShape = [ChipmunkCircleShape circleWithBody:_centralBody radius:_radius offset:cpvzero];
	[set addObject:centralShape];
	centralShape.group = self;
	centralShape.layers = GRABABLE_LAYER;
	centralShape.collisionType = [JellyBlob class];
	
	
}

-(void)constructEdges {
	
	cpFloat edgeMass = 1.0f / totBodies;
	cpFloat edgeDistance = 2.0f * _radius * cpfsin(M_PI / (cpFloat)totBodies);
	_edgeRadius = edgeDistance * 1.5f;
	
	//cpFloat squishCoef = 0.7;
	cpFloat springStiffness = 40.0f;
	cpFloat springDamping = 1.0f;
	
	bodies = [[NSMutableArray alloc] initWithCapacity:totBodies];
	_edgeBodies = bodies;
	
	for(int i=0; i<totBodies; i++){
		cpVect slope = cpvforangle((cpFloat)i / (cpFloat)totBodies * 2.0 * M_PI);
		cpVect posMult = cpvmult(slope, _radius);
		
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:edgeMass andMoment:INFINITY];
		body.pos = cpvadd(posPt, posMult);
		
		[bodies addObject:body];
		
		//ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius * ((CCRANDOM_0_1() * 1) + 0.5) offset:cpvzero];
		ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius offset:cpvzero];
		[set addObject:shape];
		shape.elasticity = EDGE_BOUNCE;
		shape.friction = EDGE_FRICTION;
		shape.group = self;
		shape.layers = GRABABLE_LAYER;
		shape.collisionType = [JellyBlob class];
		
		//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:_centralBody bodyB:body anchr1:cpvzero anchr2:cpvzero min:0 max:radius*squishCoef]];
		
		cpVect springOffset = cpvmult(slope, _radius + _edgeRadius);
		[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:springOffset anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
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
		if (cpvnear(body.pos, pos, 15)) {
			return (body);
		}
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
	
	NSMutableArray *arrVerts = [NSMutableArray arrayWithCapacity:totBodies];
	
	cpVect verts[totBodies];
	for (int i=0; i<[_edgeBodies count]; i++) {
		cpVect v = [[_edgeBodies objectAtIndex:i] pos];
		verts[i] = cpvadd(v, cpvmult(cpvnormalize(cpvsub(v, center)), _edgeRadius * 0.85));
		
		glColor4f(0.00f, 0.87, 1.00f, 1.00f);
		ccDrawCircle(v, _edgeRadius, 360, 16, NO);
		
		[arrVerts addObject:[_edgeBodies objectAtIndex:i]];
	}
	
	[arrVerts addObject:[_edgeBodies objectAtIndex:0]];
	float area = [[GeomUtils singleton] polygonArea:[NSArray arrayWithArray:_edgeBodies]];
	
	
	if ((int)area > 23000) {
		NSLog(@"--> AREA:[%f]", area);
		
		if (!isStretched) {
			isStretched = YES;
			
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.875f];
			[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_long_stetch.mp3"];
			
			//[self performSelector:@selector(resetStretch:) withObject:self afterDelay:0.33f];
		}
	}
	
	
	if ((int)area < 20000) {
		//NSLog(@"<-- AREA:[%f]", area);
		if (isStretched) {
			isStretched = NO;
		}
	}
	
	//ChipmunkDebugDrawPolygon(_count, verts, LAColor(0, 1), LAColor(0, 0));
	
	glEnable(GL_LINE_SMOOTH);
	
	glColor4f(0.00f, 0.87, 1.00f, 1.00f);
	ccDrawPoly(verts, totBodies, YES);
	
	glLineWidth(1.0f);
	glColor4f(0.00f, 0.00f, 0.00f, 1.00f);
	ccDrawPoly(verts, totBodies, NO);
}

-(void)resetStretch:(id)sender {
	NSLog(@"resetStretch");
	isStretched = NO;
}
	
-(void)wiggleWithForce:(int)index force:(cpFloat)f {
	
	ChipmunkBody *body = [_edgeBodies objectAtIndex:index];
	
	[_centralBody applyImpulse:cpvmult(cpv(f * CCRANDOM_MINUS1_1(), f * CCRANDOM_MINUS1_1()), 16) offset:cpvzero];
	[body applyImpulse:cpv(f, f) offset:_centralBody.pos];
	
	
	//posPt = cpvadd(_centralBody.pos, cpv((CCRANDOM_0_1() * 2) - 1, (CCRANDOM_0_1() * 2) - 1));
}

-(void)pop {
	
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
