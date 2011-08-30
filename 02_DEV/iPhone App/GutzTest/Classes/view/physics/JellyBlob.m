#import "JellyBlob.h"

#import "ChipmunkDebugNode.h"

#import "CreatureDataPlistParser.h"

#import "GameConsts.h"


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
		
		_plistViscera = [[CreatureDataPlistParser alloc] initWithLevel:lvl];
		_ptSize = cpv(_plistViscera.width, _plistViscera.height);
		_count = [_plistViscera.arrCircles count];
		
		NSLog(@"%@.initWithLvl(%d) [%f, %f] // [%f, %f]{%d}", [self class], lvl, pos.x, pos.y, _ptSize.x, _ptSize.y, _count);
		
		
		_arrViscera = [[NSArray alloc] initWithArray:_plistViscera.arrCircles];
		
		
		bodies = [[NSMutableArray alloc] initWithCapacity:_count];
		_edgeBodies = bodies;
		
		
		cpFloat mass = 1.0f / _count;
		
		
		for(int i=0; i<_count; i++){
			NSDictionary *dict = [_arrViscera objectAtIndex:i];
			
			cpVect vecPos = cpv([[dict objectForKey:@"x"] intValue], [[dict objectForKey:@"y"] intValue]);
			int radius = [[dict objectForKey:@"radius"] intValue];
			
			//NSLog(@"%d) [%f, %f] // (%d)", i, vecPos.x, vecPos.y, radius);
			
			ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:INFINITY];
			body.pos = cpvadd(posPt, vecPos);
			
			[bodies addObject:body];
			
			
			ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:radius offset:cpvzero];
			shape.elasticity = EDGE_BOUNCE;
			shape.friction = EDGE_FRICTION;
			shape.group = self;
			shape.layers = GRABABLE_LAYER;
			shape.collisionType = [JellyBlob class];
			
			[set addObject:shape];
			
			//	[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:[bodies objectAtIndex:0] bodyB:body anchr1:vecPos anchr2:cpvzero restLength:0 stiffness:SPRING_STR damping:SPRING_DAMP]];
		}
		
		[set addObjectsFromArray:bodies];
		
		
		
		
		for (int i=0; i<_count; i++) {
			ChipmunkBody *a = [bodies objectAtIndex:i];
			ChipmunkBody *b = [bodies objectAtIndex:(i + 1) % _count];
			
			cpFloat dist = cpvdist(a.pos, b.pos);
			
			NSLog(@"DIST:[%f]", dist);
			
			// add'l
			[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:dist * 0.8f stiffness:SPRING_STR damping:SPRING_DAMP]];
			//[set addObject:[ChipmunkPinJoint pinJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero]];
			[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:dist]];
		}
		
	}
	
	return (self);
}

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count {
	
	if ((self = [super init])) {
		set = [NSMutableSet set];
		chipmunkObjects = set;
		
		_count = count;
		posPt = CGPointMake(pos.x, pos.y);
		
	
		
		[self constructCenter];
		[self constructEdges];
	}
	
	return (self);
}


-(void)constructCenter {
	
	int radius = 128;
	
	_centralBody = [ChipmunkBody bodyWithMass:CENTRAL_MASS andMoment:cpMomentForCircle(CENTRAL_MASS, 0, radius, cpvzero)];
	[set addObject:_centralBody];
	_centralBody.pos = posPt;
	
	
	cpVect vt[_count];
	for(int i=0; i<_count; i++){
		cpVect slope = cpvforangle(((cpFloat)_count - i) / (cpFloat)_count * 2.0 * M_PI);
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
	
	int radius = 128;
	
	cpFloat edgeMass = 1.0f / _count;
	cpFloat edgeDistance = 2.0f * radius * cpfsin(M_PI / (cpFloat)_count);
	_edgeRadius = edgeDistance * 1.5f;
	
	//cpFloat squishCoef = 0.7;
	cpFloat springStiffness = 40.0f;
	cpFloat springDamping = 1.0f;
	
	bodies = [[NSMutableArray alloc] initWithCapacity:_count];
	_edgeBodies = bodies;
	
	for(int i=0; i<_count; i++){
		cpVect slope = cpvforangle((cpFloat)i / (cpFloat)_count * 2.0 * M_PI);
		cpVect posMult = cpvmult(slope, radius);
		
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
		
		cpVect springOffset = cpvmult(slope, radius + _edgeRadius);
		[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:springOffset anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
	}
	
	[set addObjectsFromArray:bodies];
	
	
	
	
	for (int i=0; i<_count; i++) {
		ChipmunkBody *a = [bodies objectAtIndex:i];
		ChipmunkBody *b = [bodies objectAtIndex:(i + 1) % _count];
		//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:edgeDistance * 1.1]];
		
		// add'l
		[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
	}
	
}




-(ChipmunkBody *)touchedBodyAt:(CGPoint)pos {
	
	ChipmunkBody *body;
	
	
	for (int i=0; i<[bodies count]; i++) {
		body = [bodies objectAtIndex:i];
		if (cpvnear(body.pos, pos, 15)) {
			
			//NSLog(@"JellyBlob.body[%d]", i);
			
			return (body);
		}
	}
	
	
	return (body);
}


-(int)bodyIndexAt:(CGPoint)pos {
	
	for (int i=0; i<[bodies count]; i++) {
		ChipmunkBody *body = [bodies objectAtIndex:i];
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
	
	cpVect verts[_count];
	
	for (int i=0; i<_count; i++) {
		cpVect v = [[_edgeBodies objectAtIndex:i] pos];
		verts[i] = cpvadd(v, cpvmult(cpvnormalize(cpvsub(v, center)), _edgeRadius * 0.85));
		
		glColor4f(0.00f, 0.87, 1.00f, 1.00f);
		ccDrawCircle(v, _edgeRadius, 360, 16, NO);
	}
	
	//NSLog(@"DERP");
	//ChipmunkDebugDrawPolygon(_count, verts, LAColor(0, 1), LAColor(0, 0));
	
	glEnable(GL_LINE_SMOOTH);
	
	glColor4f(0.00f, 0.87, 1.00f, 1.00f);
	ccDrawPoly(verts, _count, YES);
	
	glLineWidth(1.0f);
	glColor4f(0.00f, 0.00f, 0.00f, 1.00f);
	ccDrawPoly(verts, _count, NO);
	
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
	
		for (int i=0; i<_count; i++) {
			ChipmunkBody *body = [_edgeBodies objectAtIndex:i];
			[body applyImpulse:cpv(64, 64) offset:cpvzero];
		}
	//}
	
}


-(void)pulsate:(CGPoint)pos {
	
	//cpVect offset = cpvsub(pos, _centralBody.pos);
	NSLog(@"pulsate.(%f, %f)", pos.x, pos.y);
	
	
	for (int i=0; i<_count; i++) {
		cpVect slope = cpvforangle(((cpFloat)_count - i) / (cpFloat)_count * 2.0 * M_PI);
		
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
