//
//  TimeUtils.h
//  GutzTest
//
//  Created by Gullinbursti on 07/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeUtils : NSObject {
    
}

+(TimeUtils *) singleton;



-(int) minutesFromSeconds:(int)seconds;
-(int) secondsRemain:(int)time;

@end
