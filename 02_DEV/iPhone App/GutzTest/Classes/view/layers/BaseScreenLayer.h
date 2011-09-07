//
//  BaseScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#define RESRC_TYPE @"plist"

@interface BaseScreenLayer : CCLayerColor {
    
}

-(id)initWithBackround:(NSString *)asset;
-(id)initWithBackround:(NSString *)asset position:(CGPoint)pos;
@end
