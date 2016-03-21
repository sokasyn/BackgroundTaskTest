//
//  TimerManager.h
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/21.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerManager : NSObject

+(id)defaultManager;
- (NSTimer *)createTimerWithTimeInterval:(NSTimeInterval)ti
                                  target:(id)aTarget
                                selector:(SEL)aSelector
                                repeates:(BOOL)yesOrNo;
- (void)scheduleWithGCDTimer;

@end
