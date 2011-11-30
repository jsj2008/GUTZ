//
//  BaseGibs.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseGibs.h"

#import "GeomUtils.h"
#import "RandUtils.h"



@implementation BaseGibs


-(id)initAtPos:(cpVect)pos {
	
	if ((self = [super initAtPos:pos])) {
		
		_ptPos = pos;
		_rad = ORTHODOX_RADIUS;
		_totEdges = ORTHODOX_EDGES;
		
		[self assemble];
	}
	
	return (self);
}


-(id)initAtPos:(cpVect)pos withRadius:(int)rad {
	
	if ((self = [self initAtPos:pos])) {
		
		_ptPos = pos;
		_rad = rad;
		_totEdges = ORTHODOX_EDGES;
		
		[self assemble];
	}
	
	return (self);
}


-(id)initAtPos:(cpVect)pos withEdges:(int)amt {
	
	if ((self = [self initAtPos:pos])) {
		
		_ptPos = pos;
		_rad = ORTHODOX_RADIUS;
		_totEdges = amt;
		
		[self assemble];
	}
	
	return (self);
}

-(id)initAtPos:(cpVect)pos withRadius:(int)rad withEdges:(int)amt {
	
	if ((self = [self initAtPos:pos])) {
		
		_ptPos = pos;
		_rad = rad;
		_totEdges = amt;
		
		[self assemble];
	}
	
	return (self);
}


-(void)assemble {
	//NSLog(@"%@.assemble()", [self class]);
	
	set = [NSMutableSet set];
	chipmunkObjects = set;
	
	_life = [[RandUtils singleton] rndInt:32 max:96];
	_isBroken = NO;
	
	_arrBodies = [[NSMutableArray alloc] initWithCapacity:_totBodies];
	_arrShapes = [[NSMutableArray alloc] initWithCapacity:_totBodies];
	_arrConstraints = [[NSMutableArray alloc] init];
	
	[self constructCenter];
	[self constructPerimeter];
}

-(void)constructCenter {
	//NSLog(@"%@.constructCenter(%d, %d)", [self class], _rad, _totEdges);
	
	_centralBody = [ChipmunkBody bodyWithMass:ORTHODOX_GIBS_MASS andMoment:cpMomentForCircle(ORTHODOX_GIBS_MASS, 0, _rad, cpvzero)];
	[set addObject:_centralBody];
	[_arrBodies addObject:_centralBody];
	
	_centralBody.pos = _ptPos;
	[_centralBody setVelLimit:32.0f];
	
	
	//ChipmunkShape *_centralShape = [ChipmunkPolyShape polyWithBody:_centralBody count:count verts:vt offset:cpvzero];
	_centralShape = [ChipmunkCircleShape circleWithBody:_centralBody radius:_rad offset:cpvzero];
	[set addObject:_centralShape];
	[_arrShapes addObject:_centralShape];
	
	_centralShape.group = self;
	_centralShape.layers = GRABABLE_LAYER;
	_centralShape.collisionType = [BaseGibs class];
	_centralShape.friction = ORTHODOX_FRICTION;
	_centralShape.elasticity = ORTHODOX_BOUNCE;
	
	
	_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"gut_bits0%d.png", [[RandUtils singleton] diceRoller:4]]];
	[_sprite setScale:0.2f];
	[_sprite setPosition:_ptPos];
	
	_totBodies = _totEdges + 1;
}


-(void)constructPerimeter {
	//NSLog(@"%@.constructPerimeter(%d)", [self class], _totEdges);
	
	cpFloat edgeMass = 1.0f / _totBodies;
	cpFloat edgeDistance = 2.0f * _rad * cpfsin(M_PI / (cpFloat)_totBodies);
	_radEdge = edgeDistance * 1.5f;
	
	//cpFloat squishy = ORTHODOX_SQUISH;
	cpFloat stiffness = ORTHODOX_STIFFNESS;
	cpFloat damping = ORTHODOX_DAMPING;
	
	
	_arrEdgeBodies = _arrBodies;
	
	for(int i=0; i<_totBodies; i++) {
		cpVect slope = cpvforangle((cpFloat)i / (cpFloat)_totBodies * 2.0 * M_PI);
		cpVect posMult = cpvmult(slope, _rad);
		
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:edgeMass andMoment:INFINITY];
		body.pos = cpvadd(_ptPos, posMult);
		[body setVelLimit:48.0f];
		[body setAngVelLimit:[[GeomUtils singleton] toRadians:45.0f]];
		[_arrBodies addObject: body];
		
		//ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius * ((CCRANDOM_0_1() * 1) + 0.5) offset:cpvzero];
		ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_radEdge offset:cpvzero];
		shape.elasticity = BOUNCE;
		shape.friction = FRICTION;
		shape.group = self;
		shape.layers = GRABABLE_LAYER;
		shape.collisionType = [BaseGibs class];
		
		[set addObject:shape];
		[_arrShapes addObject:shape];
		
		
		//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:_centralBody bodyB:body anchr1:cpvzero anchr2:cpvzero min:0 max:radius*squishCoef]];
		
		cpVect vOffset = cpvmult(slope, _rad + _radEdge);
		ChipmunkDampedSpring *spring = [ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:vOffset anchr2:cpvzero restLength:0 stiffness:stiffness damping:damping];
		[set addObject:spring];
		
		[_arrConstraints addObject:spring];
	}
	
	_arrEdgeBodies = [_arrBodies subarrayWithRange:NSMakeRange(1, _totEdges)];
	[set addObjectsFromArray:_arrBodies];
	
	// chain perimeters together
	for (int i=0; i<_totEdges; i++) {
		ChipmunkBody *a = [_arrEdgeBodies objectAtIndex:i];
		ChipmunkBody *b = [_arrEdgeBodies objectAtIndex:(i + 1) % _totEdges];
		//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:edgeDistance * 1.1]];
		//[_arrConstraints addObject:spring];
		
		// add'l
		ChipmunkDampedSpring *spring = [ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:0 stiffness:stiffness damping:damping];
		[set addObject:spring];
		[_arrConstraints addObject:spring];
	}
}


-(void)applyThrust:(cpVect)force from:(cpVect)offset edgesToo:(BOOL)isAll {
	[_centralBody setVel:force];
	[_centralBody applyForce:cpvmult(force, 1.0f) offset:cpvmult(offset, 0.5f)];
	
	if (isAll) {
		for (int i=0; i<_totEdges; i++) {
			ChipmunkBody *body = [_arrEdgeBodies objectAtIndex:i];
			[body applyImpulse:cpvmult(force, 1.0f) offset:offset];
		}
	}
}


-(void)step {
	//NSLog(@"%@.step(%d)", [self class], _life);
	
	[self step:1];
}

-(void)step:(int)inc {
	//NSLog(@"%@.step(%d)", [self class], _life);
	
	_life -= inc;
	_life = MIN(MAX(_life, 0.0f), 100.0f);
	
	if (_life > 1) {
		
		[_sprite setScale:(_life * 0.01f)];
		
		[_sprite setPosition:_centralShape.body.pos];
		[_sprite setRotation:-[[GeomUtils singleton] toDegrees:_centralShape.body.angle]];
		
		//float str = (ORTHODOX_STIFFNESS - ((_life * ORTHODOX_STIFFNESS) * 0.001f));
		//NSLog(@"\t --> STR[%f]", str);
		
		
		for (int i=0; i<[_arrConstraints count]; i++)
			[[_arrConstraints objectAtIndex:i] setStiffness:(ORTHODOX_STIFFNESS - ((_life * ORTHODOX_STIFFNESS) * 0.0001f))];
		
		
	} else if (_life <= 8 && !_isBroken) {
		_isBroken = YES;
		
		for (int i=0; i<[_arrConstraints count]; i++)
			[[_arrConstraints objectAtIndex:i] removeFromSpace:_space];
		
	} else if (_life <= 0) {
		for (int i=0; i<_totBodies; i++) {
			ChipmunkShape *shape = [_arrShapes objectAtIndex:i];
			
			[shape.body resetForces];
			[shape.body sleep];
			
			shape.group = @"DERP!";
			shape.collisionType = @"DERP!";
			shape.layers = INACTIVE_LAYER;
			
			[_space removeBody:shape.body];
			[shape.body release];
			
			[_space removeShape:shape];
			[shape release];
		}
	}
}


-(void)regHit:(id)obj {
	NSLog(@"%@.regHit()", [self class]);
}


-(int)lifeRemains {
	return (_life);
}


-(NSArray *)arrAllBodies {
	return ([_arrBodies subarrayWithRange:NSMakeRange(0, _totEdges)]);
}


-(NSArray *)arrEdgeBodies {
	return (_arrEdgeBodies);
}

-(NSArray *)arrFixtrues {
	return (_arrConstraints);
}

-(NSDictionary *)dictAllPhysicsPairs {
	
	NSMutableArray *arrKey = [NSMutableArray arrayWithObject:@"00"];
	NSMutableArray *arrPair = [NSMutableArray arrayWithObjects:_centralBody, _centralShape, nil];
	
	for (int i=1; i<_totBodies; i++) {
		[arrKey addObject:[NSString stringWithFormat:@"%02d", i]];
		[arrPair addObjectsFromArray:[NSArray arrayWithObjects:[_arrShapes objectAtIndex:i], [_arrBodies objectAtIndex:i], nil]];
	}
	
	return ([NSDictionary dictionaryWithObjects:arrPair forKeys:arrKey]);
}


-(NSDictionary *)dictEdgePhysicsPairs {
	
	NSMutableArray *arrKey = [[NSMutableArray alloc] init];
	NSMutableArray *arrPair = [[NSMutableArray alloc] init];
	
	for (int i=0; i<_totEdges; i++) {
		[arrKey addObject:[NSString stringWithFormat:@"%02d", i]];
		[arrPair addObjectsFromArray:[NSArray arrayWithObjects:[_arrShapes objectAtIndex:i+1], [_arrBodies objectAtIndex:i+1], nil]];
	}
	
	return ([NSDictionary dictionaryWithObjects:arrPair forKeys:arrKey]);
}

-(void)draw {
	//NSLog(@"%@.draw()", [self class]);
	
	cpVect verts[_totEdges];
	for (int i=0; i<[_arrEdgeBodies count]; i++) {
		cpVect v = [[_arrEdgeBodies objectAtIndex:i] pos];
		verts[i] = cpvadd(v, cpvmult(cpvnormalize(cpvsub(v, _centralBody.pos)), _radEdge * 0.85));
		
		//glColor4f(0.00f, 0.87, 1.00f, 1.00f);
		//ccDrawCircle(v, _radEdge, 360, 16, NO);
	}
	
	/*
	 glEnable(GL_LINE_SMOOTH);
	
	glLineWidth(1.0f);
	glColor4f(0.00f, 0.00f, 0.00f, 1.00f);
	ccDrawPoly(verts, _totEdges, NO);
	
	glColor4f(0.00f, 0.87, 1.00f, 1.00f);
	ccDrawPoly(verts, _totEdges, YES);
	*/
	
}



-(void)dealloc {
	
	[_centralBody release];
	[_centralShape release];
	_centralBody = nil;
	_centralShape = nil;
	
	[_arrConstraints release];
	[_arrEdgeBodies release];
	[_arrBodies release];
	[_arrShapes release];
	_arrConstraints = nil;
	_arrEdgeBodies = nil;
	_arrBodies = nil;
	_arrShapes = nil;
	
	[_arrClamps release];
	[_arrParts release];
	_arrClamps = nil;
	_arrParts = nil;
	
	[_space removeBaseObjects:chipmunkObjects];
	[set removeAllObjects];
	
	[chipmunkObjects release];
	[set release];
	
	chipmunkObjects = nil;
	set = nil;
	
	
	[super dealloc];
}



/*
 cpVect vt[_totEdges];
 for(int i=0; i<_totEdges; i++){
 cpVect slope = cpvforangle(((cpFloat)_totEdges - i) / (cpFloat)_totEdges * 2.0 * M_PI);
 cpVect posMult = cpvmult(slope, _rad);
 
 vt[i] = cpvadd(posMult, cpvzero);
 //NSLog(@"vt[%d]: (%f, %f)", i, vt[i].x, vt[i].y);
 }
 */

@end
