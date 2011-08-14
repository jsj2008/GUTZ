//
//  DigitUtils.h
//  GutzTest
//
//  Created by Gullinbursti on 07/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DigitUtils : NSObject {
    
}

+(DigitUtils *) singleton;


-(int)ones:(int)value;
-(int)tens:(int)value;
-(int)hundreds:(int)value;
-(int)thousands:(int)value;

@end
