//
//  Countdown.m
//  APP
//
//  Created by Yan Qingyang on 15/9/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Countdown.h"
@interface Countdown()
{
    dispatch_source_t timerCD;
    
    int num;
    NSDate *stopTime;
}
@property (assign) int maxCD;
@end

@implementation Countdown
+ (instancetype)aInstance{
    return [[self alloc] init];
}

- (id)init{
    if (self = [super init]) {
        [self removeObserverGlobal];
        [self addObserverGlobal];
        num = 0;
    }
    return self;
}

- (void)setCD:(int)aCd block:(CDBlock)block{
    [self removeObserverGlobal];
    [self addObserverGlobal];
    num = 0;
    
    self.maxCD=aCd;
    if (block)
        self.cdBlock=block;
    
    [self begin];
}
- (void)begin{
    if (timerCD)
        timerCD=[TIMER timerClose:timerCD];
    
    timerCD=[TIMER timerLoop:timerCD timeInterval:1.0 blockLoop:^{
        num++;
//        
        self.curCD=self.maxCD-num;
        
        if (num>=self.maxCD) {
            DLog(@"关闭循环");
            if (timerCD)
                timerCD=[TIMER timerClose:timerCD];
            [self removeObserverGlobal];
            self.curCD=0;
        }
        
        if (self.cdBlock) {
            self.cdBlock(self.curCD);
        }
    } blockStop:^{
        //
    }];
}

- (void)stop{
    
    stopTime=[NSDate date];
}

- (void)start{
    NSTimeInterval tt=[stopTime timeIntervalSinceNow];
//    DebugLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %f",tt);
    int nn=(int)tt*-1;
    num+=nn;
    [self begin];
}
#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifAppDidEnterBackground){
        //进后台
        DLog(@"cd 轮询暂停");
        [self stop];
    }
    else if (type == NotifAppWillEnterForeground){
        //back
        DLog(@"cd 轮询继续");
        [self start];
    }
}



#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQGlobalNotification object:nil];
}

- (void)removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{
    
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([QGLOBAL object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}
@end
