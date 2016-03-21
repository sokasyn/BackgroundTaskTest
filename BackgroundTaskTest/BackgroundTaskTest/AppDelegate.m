//
//  AppDelegate.m
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/18.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (retain,nonatomic) NSTimer *timer;

@end

@implementation AppDelegate

@synthesize timer = timer_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *categoryErr = nil;
    NSError *activationErr  = nil;
    [audioSession setCategory: AVAudioSessionCategoryPlayback error: &categoryErr];
    [audioSession setActive: YES error: &activationErr];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"app 即将不活跃.");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"app 进入了后台.");
    [self configLongtimeBackgroundRunning];
}

// --------------------------------------------------------------
// 可在后台长时间运行任务的配置
- (void)configLongtimeBackgroundRunning{
    NSLog(@"可长时间后台运行的配置");
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [app endBackgroundTask:bgTaskId];
            if (bgTaskId != UIBackgroundTaskInvalid) {
                bgTaskId = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTaskId != UIBackgroundTaskInvalid){
//                bgTaskId = UIBackgroundTaskInvalid;
//            }
            [self startTimer];
        });
    });
}

- (void)initTimer{
    NSTimeInterval timeInterval = 1.0f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)handleTimer:(id)sender{
    NSTimeInterval timeRemain = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"application background time remaining:%.02f senconds",timeRemain);
}

- (void)startTimer{
    if (!self.timer) {
        [self initTimer];
    }else{
        if (![self.timer isValid]) {
            NSLog(@"timer is not valid..");
        }
        [self.timer setFireDate:[NSDate distantPast]];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

// --------------------------------------------------------------

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"app 进入了前台.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"app 已经激活.");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"app 已经关闭.");
}

@end
