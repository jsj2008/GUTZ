#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"

@interface HelloWorldLayer : CCLayer
{
	ChipmunkSpace *_space;
	ChipmunkMultiGrab *_multiGrab;
	JellyBlob *blob;
}

+(CCScene *) scene;

@end
