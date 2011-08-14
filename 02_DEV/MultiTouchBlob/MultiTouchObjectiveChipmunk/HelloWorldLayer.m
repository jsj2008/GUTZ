#import "HelloWorldLayer.h"

#import "ChipmunkDebugNode.h"
#import "JellyBlob.h"

@implementation HelloWorldLayer

+(CCScene *)scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if((self=[super init])){
		self.isTouchEnabled = YES;
		
		
		CGSize wins = [[CCDirector sharedDirector] winSize];
		//CGPoint winsMidPt = CGPointMake(wins.width * 0.5f, wins.height * 0.5f);
		
		_space = [[ChipmunkSpace alloc] init];
		_space.gravity = cpv(0, -200);
		
		
		
		
		CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
		[_space addBounds:rect thickness:5 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:nil];
		
		_multiGrab = [[ChipmunkMultiGrab alloc] initForSpace:_space withSmoothing:cpfpow(0.8, 60.0) withGrabForce:30000];
		_multiGrab.layers = GRABABLE_LAYER;
		
		ChipmunkDebugNode *debugNode = [ChipmunkDebugNode debugNodeForSpace:_space];
		[self addChild:debugNode];
		
		
		{ // Add the blob
			blob = [[JellyBlob alloc] initWithPos:cpv(64, 260) radius:64 count:32];
			[_space add:blob];
		}
		
		
		{ // Add a box
			cpFloat mass = 5;
			cpFloat width = 16;
			cpFloat height = 128;
			
			ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:mass andMoment:cpMomentForBox(mass, width, height)]];
			body.pos = cpv(192, 260);
			
			ChipmunkShape *shape = [_space add:[ChipmunkPolyShape boxWithBody:body width:width height:height]];
			shape.friction = 0.7;
		}
		
		{ // Add a circle
			cpFloat mass = 1;
			cpFloat radius = 50;
			
			ChipmunkBody *body = [_space add:[ChipmunkBody bodyWithMass:mass andMoment:cpMomentForCircle(mass, 0, radius, cpvzero)]];
			body.pos = cpv(400, 160);
			
			ChipmunkShape *shape = [_space add:[ChipmunkCircleShape circleWithBody:body radius:radius offset:cpvzero]];
			shape.friction = 0.7;
		}
		
		
		[self scheduleUpdate];
	}
	
	return self;
}

-(void)dealloc
{	
	[_space release];
	[_multiGrab release];
	
	[super dealloc];
}

-(void)update:(cpFloat)dt
{
	[_space step:1.0/60.0];
	[blob draw];
}

static cpVect
TouchLocation(UITouch *touch)
{
	return [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
	for(UITouch *touch in touches) [_multiGrab beginLocation:TouchLocation(touch)];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	for(UITouch *touch in touches) [_multiGrab updateLocation:TouchLocation(touch)];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	for(UITouch *touch in touches) [_multiGrab endLocation:TouchLocation(touch)];
}

@end
