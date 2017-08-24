//
//  Countdown.h
//  APP
//
//  Created by Yan Qingyang on 15/9/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerUtils.h"

#define  CD [Countdown aInstance]

typedef void (^CDBlock)(int numCD);

@interface Countdown : NSObject
@property(nonatomic, copy, readwrite) CDBlock cdBlock;
@property (assign) int curCD;
+ (instancetype)aInstance;
- (void)setCD:(int)aCd block:(CDBlock)block;

@end
