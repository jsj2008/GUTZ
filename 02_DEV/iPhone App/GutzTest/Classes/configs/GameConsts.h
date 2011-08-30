//
//  UIConsts.h
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#ifndef __GAME_CONSTS_H
#define __GAME_CONSTS_H

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define MENU_BG_ASSET @"bg_menu.png"

static const cpVect LVL_MENU_DIM = {3, 4};
static const ccColor3B ARENA_BG = {233, 86, 86};


#define MENU_INTRO_DELAY 0.33f


#endif

/*
typedef struct derpStruct {
	NSUInteger num, max;
	id *arr;
} derpStruct;

typedef enum {
	kDerp1, 
	kDerp2
} derpEnum;


enum {
	kDERP_1 = 1,
	kDERP_2 = 2,
};


*/



/*
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
//#define GAME_AUTOROTATION kGameAutorotationUIViewController

#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone

#endif
*/
