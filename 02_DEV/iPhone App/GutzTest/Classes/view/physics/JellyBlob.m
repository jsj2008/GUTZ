#import "JellyBlob.h"

#import "ChipmunkDebugNode.h"

//@interface JellyBlob()
//@property(nonatomic, readwrite) NSSet *chipmunkObjects;
//@end


@implementation JellyBlob

@synthesize control = _control;//, chipmunkObjects = _chipmunkObjects;
@synthesize chipmunkObjects;

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count; {
	
	if ((self = [super init])) {
		NSMutableSet *set = [NSMutableSet set];
		chipmunkObjects = set;
		
		_count = count;
		
		_rate = 5.0;
		_torque = 50000.0;
		
		cpFloat centralMass = 0.5;
		
		_centralBody = [ChipmunkBody bodyWithMass:centralMass andMoment:cpMomentForCircle(centralMass, 0, radius, cpvzero)];
		[set addObject:_centralBody];
		_centralBody.pos = pos;
				
		cpVect vt[count];
		for(int i=0; i<count; i++){
			cpVect slope = cpvforangle(((cpFloat)count - i) / (cpFloat)count * 2.0 * M_PI);
			cpVect posMult = cpvmult(slope, radius);
			
			vt[i] = cpvadd(posMult, cpvzero);
			NSLog(@"vt[%d]: (%f, %f)", i, vt[i].x, vt[i].y);
		}
		
		//[_polyVerts initWithArray: vt];
		
		//ChipmunkShape *centralShape = [ChipmunkPolyShape polyWithBody:_centralBody count:count verts:vt offset:cpvzero];		
		ChipmunkShape *centralShape = [ChipmunkCircleShape circleWithBody:_centralBody radius:radius offset:cpvzero];
		[set addObject:centralShape];
		centralShape.group = self;
		centralShape.layers = GRABABLE_LAYER;
		centralShape.collisionType = [JellyBlob class];
		
		
		cpFloat edgeMass = 1.0 / count;
		cpFloat edgeDistance = 2.0 * radius * cpfsin(M_PI / (cpFloat)count);
		_edgeRadius = edgeDistance * 1.5;
		
		//cpFloat squishCoef = 0.7;
		cpFloat springStiffness = 40;
		cpFloat springDamping = 1;
		
		NSMutableArray *bodies = [[NSMutableArray alloc] initWithCapacity:count];
		_edgeBodies = bodies;
		
		for(int i=0; i<count; i++){
			cpVect slope = cpvforangle((cpFloat)i / (cpFloat)count * 2.0 * M_PI);
			cpVect posMult = cpvmult(slope, radius);
			
			ChipmunkBody *body = [ChipmunkBody bodyWithMass:edgeMass andMoment:INFINITY];
			body.pos = cpvadd(pos, posMult);
			
			[bodies addObject:body];
			
			ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius offset:cpvzero];
			[set addObject:shape];
			shape.elasticity = EDGE_BOUNCE;
			shape.friction = EDGE_FRICTION;
			shape.group = self;
			shape.layers = GRABABLE_LAYER;
			shape.collisionType = [JellyBlob class];
			
			//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:_centralBody bodyB:body anchr1:offset anchr2:cpvzero min:0 max:radius*squishCoef]];
			
			cpVect springOffset = cpvmult(slope, radius + _edgeRadius);
			[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:springOffset anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
		}
		
		[set addObjectsFromArray:bodies];
		
		
		
		
		for(int i=0; i<count; i++){
			ChipmunkBody *a = [bodies objectAtIndex:i];
			ChipmunkBody *b = [bodies objectAtIndex:(i + 1) % count];
			//[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:edgeDistance * 1.1]];
			
			// add'l
			[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
		}
		
		_motor = [ChipmunkSimpleMotor simpleMotorWithBodyA:_centralBody bodyB:[ChipmunkBody staticBody] rate:0];
		[set addObject:_motor];
		_motor.maxForce = 0;
		
		
		
	}
	
	return (self);
}

-(void)setControl:(cpFloat)value {
	_motor.maxForce = (value == 0.0 ? 0.0 : _torque);
	_motor.rate = _rate*value;
	
	_control = value;
}

-(void)draw {
	cpVect center = _centralBody.pos;
	
	cpVect verts[_count];
	//for (int j=0; j<3; j++) {
	
		for (int i=0; i<_count; i++) {
			//cpVect v = cpvadd([[_edgeBodies objectAtIndex:i] pos], cpv(0, -64 + (j * 64)));
			cpVect v = [[_edgeBodies objectAtIndex:i] pos];
			verts[i] = cpvadd(v, cpvmult(cpvnormalize(cpvsub(v, center)), _edgeRadius));
		}
	//}
	
		
	
	//NSLog(@"DERP");
	//glColor4f(1.0f, 0.5f, 0.0f, 1.0f);
	//ccDrawPoly(verts, _count, YES);
		
	//ChipmunkDebugDrawPolygon(_count, verts, LAColor(0, 1), LAColor(0, 0));
	
	glEnable(GL_POINT_SMOOTH);
	glEnable(GL_LINE_SMOOTH);
	
	glColor4f(0.40f, 0.80f, 0.87f, 1.00f);
	ccDrawPoly(verts, _count, YES);
	
	glLineWidth(3.0f);
	glColor4f(0.00f, 0.00f, 0.00f, 1.00f);
	ccDrawPoly(verts, _count, NO);
	
	//ccDrawCircle(_centralBody.pos, 64, _centralBody.angle, 64, NO);
}


-(void)wiggleWithForce:(int)index force:(cpFloat)f {
	
	ChipmunkBody *body = [_edgeBodies objectAtIndex:index];
	
	[_centralBody applyImpulse:cpvmult(cpv(f, f), 3) offset:cpvzero];
	[body applyImpulse:cpv(f, f) offset:body.pos];
}

-(void)pop {
	
	if (!isPopped) {
		
		isPopped = YES;
	
		for (int i=0; i<_count; i++) {
			ChipmunkBody *body = [_edgeBodies objectAtIndex:i];
			[body applyImpulse:cpv(64, 64) offset:_centralBody.pos];
		}
	}
	
}

- (void)dealloc {
	[_centralBody release];
	
	[_motor release];
	[_edgeBodies release];
	
	chipmunkObjects = nil;
	
	[super dealloc];
}

@end
