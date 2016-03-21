//
//  TimerManager.m
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/21.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager

+(id)defaultManager{
    static dispatch_once_t onceToken;
    static TimerManager *timerManager = nil;
    dispatch_once(&onceToken, ^{
        timerManager = [[[self class] alloc] init];
        
    });
    return timerManager;
}

- (NSTimer *)createTimerWithTimeInterval:(NSTimeInterval)ti
                                  target:(id)aTarget
                                selector:(SEL)aSelector
                                repeates:(BOOL)yesOrNo{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti
                                                      target:aTarget
                                                    selector:aSelector
                                                    userInfo:nil
                                                     repeats:yesOrNo];
    return timer;
}

- (void)scheduleWithGCDTimer{
    
}

@end
