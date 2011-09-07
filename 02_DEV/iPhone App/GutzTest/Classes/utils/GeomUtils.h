//
//  GeomUtils.h
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectiveChipmunk.h"

@interface GeomUtils : NSObject {
    
}

+(GeomUtils *) singleton;


-(float)polygonArea:(NSArray *)arrVerts;

@end
