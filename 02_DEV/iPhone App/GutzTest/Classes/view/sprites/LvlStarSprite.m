//
//  LvlStarSprite.m
//  GutzTest
//
//  Created by Gullinbursti on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LvlStarSprite.h"

#import "AlgebraUtils.h"
@implementation LvlStarSprite


@synthesize totFilled;

-(id) init {
	
	if ((self = [super init])) {
		
		totFilled = 0;
		arrStarsVO = [[NSMutableArray alloc] init];
		arrStarsSprite = [[NSMutableArray alloc] init];
		
		starsBatchSprite = [CCSpriteBatchNode batchNodeWithFile:@"hudStars_spritemap.png" capacity:4];
		[starsBatchSprite setPosition:ccp(0, 0)];
		
		
		
		CGPoint starSize = CGPointMake(31, 30);
		
		int zPos = 0;
		
		for (int i=0; i<4; i++) {
			NSNumber *ind = [[NSNumber alloc] initWithInt:i];
			NSNumber *isFilled = [[NSNumber alloc] initWithInt:0];;
			CGPoint ptPos = CGPointMake(i * starSize.x, 0);
			
			star01Sprite = [CCSprite spriteWithBatchNode:starsBatchSprite rect:CGRectMake(0, 0, starSize.x, starSize.y)];
			[star01Sprite setPosition:ptPos];
			[star01Sprite setScale:0.9f];
			
			star02Sprite = [CCSprite spriteWithBatchNode:starsBatchSprite rect:CGRectMake(starSize.x, 0, starSize.x, starSize.y)];
			[star02Sprite setPosition:ptPos];
			[star02Sprite setScale:0.9f];
			[star02Sprite setVisible:NO];
			
			NSMutableArray *starVO = [[NSArray alloc] initWithObjects:ind, 0, isFilled, [[NSArray alloc] initWithObjects:star01Sprite, star02Sprite, nil], nil];
			[arrStarsVO insertObject:starVO atIndex:i];
			
			NSArray *arrFramesStar = [[NSArray alloc] initWithObjects:star01Sprite, star02Sprite, nil];
			[arrStarsSprite addObject:arrFramesStar];
			
			[starsBatchSprite addChild:star01Sprite];
			[starsBatchSprite addChild:star02Sprite];
			
			[star01Sprite runAction:[CCSequence actions: [CCEaseInOut actionWithDuration:0.1f], [CCScaleTo actionWithDuration:0.2f scale:1.0f], nil]];
			[star02Sprite runAction:[CCSequence actions: [CCEaseInOut actionWithDuration:0.1f], [CCScaleTo actionWithDuration:0.2f scale:1.0f], nil]];
			
			zPos++;
		}
		
		[self addChild:starsBatchSprite z:0 tag:666];
		[self schedule: @selector(frameAnimator:) interval:((CCRANDOM_0_1() * 0.5f) - 0.25f) + 0.25f];
		
	}
	
	return (self);
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScoreChange:) name:@"ScoreChanged" object:nil];
}



-(void) frameAnimator:(ccTime)dt {
	//NSLog(@"frameAnimator(%5.05f)", dt);
	
	
	//CGPoint yAxisRotationRange = CGPointMake(3.0f, -3.0f);
	//CGPoint xAxisRotationRange = CGPointMake(0.0f, 0.0f);
	//float scaleMultiplier = 0.1f;
	//float derp = 0.0f;
	
	//glPopMatrix();
	//glRotatef((CCRANDOM_0_1() * yAxisRotationRange.x) + yAxisRotationRange.y, (CCRANDOM_0_1() * xAxisRotationRange.x) + xAxisRotationRange.y, scaleMultiplier, derp);
	//glPushMatrix();
	
	int rndGrp = (arc4random() % 8) + 0;
	
	CCSprite *botSprite = [[arrStarsSprite objectAtIndex:rndGrp] objectAtIndex:0];
	CCSprite *topSprite = [[arrStarsSprite objectAtIndex:rndGrp] objectAtIndex:1];
	
	[botSprite setVisible:![botSprite visible]];
	[topSprite setVisible:![topSprite visible]];
}


-(void) tare {
	
}


-(void) fillByIndex:(int)ind {
	
}


-(void) fillAll {
	
}


-(void) clearByIndex:(int *)ind {
	
}


-(void) clearInBatch:(NSArray *)arrClear {
	
}


@end










//NSInteger *derp = 0;
//NSNumber *upVal = [NSNumber numberWithInt: 1];
//NSNumber *dnVal = [NSNumber numberWithInt: 1];
//
//NSExpression *exp = [NSExpression expressionForFunction:@"bitwiseXor:with:" arguments: [NSArray arrayWithObjects: [NSExpression expressionForConstantValue: dnVal], [NSExpression expressionForConstantValue: upVal], nil]];
//id result = [exp expressionValueWithObject: nil context: nil];
//int *ok0 = [result isEqualToNumber:[NSNumber numberWithInt:0]];
//int *ok1 = [result isEqualToNumber:[NSNumber numberWithInt:1]];
//
//int one = 1;
//int zero = 0;
//
//NSLog(@"&&- %d %d", ok0, ok1);//, [exp leftExpression], [exp rightExpression]);
//NSLog(@"(%@)", exp);//, [exp leftExpression], [exp rightExpression]);

//[(NSNumber*)[vo objectAtIndex:1]

