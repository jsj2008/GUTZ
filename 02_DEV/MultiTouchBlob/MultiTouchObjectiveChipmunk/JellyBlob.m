#import "JellyBlob.h"

#import "ChipmunkDebugNode.h"

@interface JellyBlob()
@property(nonatomic, readwrite) NSSet *chipmunkObjects;
@end


@implementation JellyBlob

@synthesize control = _control, chipmunkObjects = _chipmunkObjects;

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count;
{
	if((self = [super init])){
		NSMutableSet *set = [NSMutableSet set];
		self.chipmunkObjects = set;
		
		_count = count;
		
		_rate = 5.0;
		_torque = 50000.0;
		
		cpFloat centralMass = 0.5;
		
		_centralBody = [ChipmunkBody bodyWithMass:centralMass andMoment:cpMomentForCircle(centralMass, 0, radius, cpvzero)];
		[set addObject:_centralBody];
		_centralBody.pos = pos;
		 
		ChipmunkShape *centralShape = [ChipmunkCircleShape circleWithBody:_centralBody radius:radius offset:cpvzero];
		[set addObject:centralShape];
		centralShape.group = self;
		centralShape.layers = GRABABLE_LAYER;
		
		cpFloat edgeMass = 1.0 / count;
		cpFloat edgeDistance = 2.0 * radius * cpfsin(M_PI/(cpFloat)count);
		_edgeRadius = edgeDistance * 0.5;
		
		cpFloat squishCoef = 0.7;
		cpFloat springStiffness = 3;
		cpFloat springDamping = 1;
		
		NSMutableArray *bodies = [[NSMutableArray alloc] initWithCapacity:count];
		_edgeBodies = bodies;
		
		for(int i=0; i<count; i++){
			cpVect dir = cpvforangle((cpFloat)i/(cpFloat)count*2.0*M_PI);
			cpVect offset = cpvmult(dir, radius);
			
			ChipmunkBody *body = [ChipmunkBody bodyWithMass:edgeMass andMoment:INFINITY];
			body.pos = cpvadd(pos, offset);
			[bodies addObject:body];
			
			ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:_edgeRadius offset:cpvzero];
			[set addObject:shape];
			shape.elasticity = 0;
			shape.friction = 0.7;
			shape.group = self;
			shape.layers = GRABABLE_LAYER;
			
			[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:_centralBody bodyB:body anchr1:offset anchr2:cpvzero min:0 max:radius*squishCoef]];
			
			cpVect springOffset = cpvmult(dir, radius + _edgeRadius);
			[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:_centralBody bodyB:body anchr1:springOffset anchr2:cpvzero restLength:0 stiffness:springStiffness damping:springDamping]];
		}
		
		[set addObjectsFromArray:bodies];
		
		for(int i=0; i<count; i++){
			ChipmunkBody *a = [bodies objectAtIndex:i];
			ChipmunkBody *b = [bodies objectAtIndex:(i+1)%count];
			[set addObject:[ChipmunkSlideJoint slideJointWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero min:0 max:edgeDistance * 1.5]];
			
			// add'l
			[set addObject:[ChipmunkDampedSpring dampedSpringWithBodyA:a bodyB:b anchr1:cpvzero anchr2:cpvzero restLength:0 stiffness:springStiffness * 0.1 damping:springDamping]];
		}
		
		_motor = [ChipmunkSimpleMotor simpleMotorWithBodyA:_centralBody bodyB:[ChipmunkBody staticBody] rate:0];
		[set addObject:_motor];
		_motor.maxForce = 0;
	}
	
	return self;
}

-(void)setControl:(cpFloat)value
{
	_motor.maxForce = (value == 0.0 ? 0.0 : _torque);
	_motor.rate = _rate*value;
	
	_control = value;
}

-(void)draw
{
	cpVect center = _centralBody.pos;
	
	cpVect verts[_count];
	for(int i=0; i<_count; i++){
		cpVect v = [[_edgeBodies objectAtIndex:i] pos];
		verts[i] = cpvadd(v, cpvmult(cpvnormalize(cpvsub(v, center)), _edgeRadius));
	}
	
	//NSLog(@"DERP");
	//glColor4f(1.0f, 0.5f, 0.0f, 1.0f);
	//ccDrawPoly(verts, _count, YES);
		
	//ChipmunkDebugDrawPolygon(_count, verts, LAColor(0, 1), LAColor(0, 0));
}

- (void)dealloc
{
	[_centralBody release];
	[_motor release];
	[_edgeBodies release];
	
	self.chipmunkObjects = nil;
	
	[super dealloc];
}

@end
