//
//  main.m
//  GutzTest
//
//  Created by Gullinbursti on 06/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
	
	NSString *logPath = @"/path/to/log/file.log"; freopen([logPath fileSystemRepresentation], "a", stderr); 
	
	[pool release];
	
	return retVal;
}
