//
//  CreatureConsts.h
//  GutzTest
//
//  Created by Gullinbursti on 07/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#ifndef __CREATURE_CONSTS_H
#define __CREATURE_CONSTS_H


//
// Wiggler Settings:
#define kWiggleMinInterval 0.2f
#define kWiggleMaxInterval 0.5f

#define kWiggleMaxLinVelocity 16.0f
#define kWiggleMaxForce 32.0f
#define kWiggleMaxTorq 64.0f


//
// Node Settings:
#define kExoSkinPwr 16.0f
#define kExoSkinDam 0.1f

#define kEndoSkinPwr 16.0f
#define kEndoSkinDam 0.1f

#define kTransSkinPwr 16.0f
#define kTransSkinDam 0.1f

#define kPriRadialPwr 16.0f
#define kPriRadialDam 0.1f

#define kSecRadialPwr 16.0f
#define kSecRadialDam 0.1f


//
// Define here the type of autorotation that you want for your game
//<<~#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
//<<~#define GAME_AUTOROTATION kGameAutorotationCCDirector

//
// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
//<<~#elif __arm__
//<<~#define GAME_AUTOROTATION kGameAutorotationNone

//
// Ignore this value on Mac
//<<~#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)


//<<~#else
//<<~#error(unknown architecture)
//<<~#endif

#endif // __CREATURE_CONSTS_H

