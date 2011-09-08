//
//  StorySlideSprite.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StorySlideSprite.h"

@implementation StorySlideSprite

-(id)initWithFile:(NSString *)filename {
	
	if ((self = [super initWithFile:filename])) {
		NSLog(@"-/> %@.initWithFile(%@) </-", [self class], filename);
		
		_strAssetFile = filename;
		//self.isTouchEnabled = YES;
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
	
	[_strAssetFile release];
}

@end
