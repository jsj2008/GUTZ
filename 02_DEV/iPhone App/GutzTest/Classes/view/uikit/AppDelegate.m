//
//  AppDelegate.m
//  GutzTest
//
//  Created by Gullinbursti on 06/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//



//
//  AppDelegate.m
//  MultiTouchObjectiveChipmunk
//
//  Created by Scott Lembcke on 7/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "ScreenManager.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window;

-(void)removeStartupFlicker {
	
}

-(void)applicationDidFinishLaunching:(UIApplication*)application {
	
	/**
	 * 
	 * CC_DIRECTOR_INIT()
	 *
	 * 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	 * 2. EAGLView multiple touches: disabled
	 * 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	 * 4. Parents EAGLView to the newly created window
	 * 5. Creates Display Link Director
	 * 5a. If it fails, it will use an NSTimer director
	 * 6. It will try to run at 60 FPS
	 * 7. Display FPS: NO
	 * 8. Device orientation: Portrait
	 * 9. Connects the director to the EAGLView
	 * 
	**/
	 	
	// init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	if ((int)[window bounds].size.height == 1024 && (int)[window bounds].size.width == 768) {
		NSLog(@"iPad detected.");
		//[director setContentScaleFactor:2.0f];
	}
	
	// create the EAGLView manually
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds] pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	[glView setMultipleTouchEnabled:TRUE];
	
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	
	[director setAnimationInterval:(1.0 / 60)];
	[director setDisplayFPS:YES];
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	[self removeStartupFlicker];
	
	if (![director enableRetinaDisplay:YES])
		CCLOG(@"Retina Display Not supported");
	
	
	
	// sho main menu
	[ScreenManager goMenu];
}


-(void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void)applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void)applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

-(void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	[window release];
	[director end];	
}

-(void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
