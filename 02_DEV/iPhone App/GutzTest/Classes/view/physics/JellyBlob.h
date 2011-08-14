#import <Foundation/Foundation.h>

#define NORMAL_LAYER 1
#define GRABABLE_LAYER 2

#define EDGE_BOUNCE 0.5f
#define EDGE_FRICTION 0.1f

#import "ObjectiveChipmunk.h"

@interface JellyBlob : NSObject <ChipmunkObject> {
	int _count;
	cpFloat _edgeRadius;
	
	ChipmunkBody *_centralBody;
	
	NSArray *_edgeBodies;
	CGPoint posPt;
	
	ChipmunkSimpleMotor *_motor;
	cpFloat _rate, _torque;
	cpFloat _control;
	
	NSSet *chipmunkObjects;
	
	BOOL isPopped;
}

@property (nonatomic, assign) cpFloat control;
@property (nonatomic, readonly) NSSet *chipmunkObjects;
@property (nonatomic) CGPoint posPt;

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count;
-(void)wiggleWithForce:(int)index force:(cpFloat)f;
-(void)pop;

-(void)draw;

@end
