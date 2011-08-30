#import <Foundation/Foundation.h>

#import "ObjectiveChipmunk.h"
#import "CreatureDataPlistParser.h"

#define NORMAL_LAYER 1
#define GRABABLE_LAYER 2

#define EDGE_BOUNCE 0.5f
#define EDGE_FRICTION 0.1f

#define CENTRAL_MASS 1.5f



@interface JellyBlob : NSObject <ChipmunkObject> {
	int _count;
	cpFloat _edgeRadius;
	
	cpVect _ptSize;
	
	ChipmunkBody *_centralBody;
	
	NSArray *_edgeBodies;
	CGPoint posPt;
	
	NSMutableArray *bodies;
	
	
	CreatureDataPlistParser *_plistViscera;
	NSArray *_arrViscera;
	
	ChipmunkSimpleMotor *_motor;
	cpFloat _rate, _torque;
	cpFloat _control;
	
	NSSet *chipmunkObjects;
	
	BOOL isPopped;
	
	float rFillColor;
	float gFillColor;
	float bFillColor;
	
}

@property (nonatomic, assign) cpFloat control;
@property (nonatomic, readonly) NSSet *chipmunkObjects;
@property (nonatomic) CGPoint posPt;
@property (nonatomic) float rFillColor;
@property (nonatomic) float gFillColor;
@property (nonatomic) float bFillColor;

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count;
-(id)initWithLvl:(int)lvl atPos:(cpVect)pos;


-(void)wiggleWithForce:(int)index force:(cpFloat)f;
-(void)pop;
-(void)pulsate:(CGPoint)pos;
-(ChipmunkBody *)touchedBodyAt:(CGPoint)pos;
-(int)bodyIndexAt:(CGPoint)pos;

-(void)draw;

@end
