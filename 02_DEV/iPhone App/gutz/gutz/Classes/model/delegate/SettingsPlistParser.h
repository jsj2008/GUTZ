//
//  SettingsPlistParser.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasePlistParser.h"

//#define RESRC_NAME @"Settings"

@interface SettingsPlistParser : BasePlistParser {
    
	NSString *urlMoreInfo;
	NSString *urlArtistPage;
	NSString *urlStudioPage;
	
	BOOL *isPushes;
	BOOL *isSound;
	
	NSNumber *lastPlayed;
	
}

-(id) init;
-(id) initWithFile;



@property (nonatomic, retain) NSString *urlMoreInfo;
@property (nonatomic, retain) NSString *urlArtistPage;
@property (nonatomic, retain) NSString *urlStudioPage;
@property (nonatomic, readwrite) BOOL *isPushes;
@property (nonatomic, readwrite) BOOL *isSounds;
@property (nonatomic, retain) NSNumber *lastPlayed;

@end
