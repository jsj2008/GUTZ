#import <Foundation/Foundation.h>

#import "ObjectiveChipmunk.h"
#import "CreatureDataPlistParser.h"

#define NORMAL_LAYER 1
#define GRABABLE_LAYER 2

#define EDGE_BOUNCE 0.5f
#define EDGE_FRICTION 0.1f

#define CENTRAL_MASS 1.5f
#define CENTRAL_RADIUS 16.0f

#define SQUISH_COEFF 0.7f
#define SPRING_STR 40.0f
#define SPRING_DAMP 0.1f


@interface JellyBlob : NSObject <ChipmunkObject> {
	
	NSSet *chipmunkObjects;
	NSMutableSet *set;
	
	CreatureDataPlistParser *_plistCreatureData;
	CGPoint posPt;
	cpFloat _radius;
	cpFloat _edgeRadius;
	cpVect _ptSize;
	cpVect _ctrPt;
	
	
	BOOL isStretched;
	
	
	ChipmunkBody *_centralBody;
	NSArray *_arrParts;
	NSArray *_arrClamps;
	NSArray *_edgeBodies;

	NSMutableArray *bodies;
	NSMutableArray *_arrSupportBodies;
	NSMutableArray *_arrContourBodies;
	
	BOOL isPopped;
	
	float rFillColor;
	float gFillColor;
	float bFillColor;
	
	int totBodies;
	int totSBodies;
	int totCBodies;
	
}

@property (nonatomic, readonly) NSSet *chipmunkObjects;
@property (nonatomic) CGPoint posPt;
@property (nonatomic) float rFillColor;
@property (nonatomic) float gFillColor;
@property (nonatomic) float bFillColor;

-(id)initWithPos:(cpVect)pos radius:(cpFloat)radius count:(int)count;
-(id)initWithLvl:(int)lvl atPos:(cpVect)pos;

-(void)constructCenter;
-(void)constructEdges;

-(void)wiggleWithForce:(int)index force:(cpFloat)f;
-(void)pop;
-(void)pulsate:(CGPoint)pos;

-(ChipmunkBody *)touchedBodyAt:(CGPoint)pos;
-(int)bodyIndexAt:(CGPoint)pos;

-(void)draw;
-(void)resetStretch:(id)sender;

@end
