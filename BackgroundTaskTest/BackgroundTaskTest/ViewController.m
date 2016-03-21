//
//  ViewController.m
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/18.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger countWhenEnterBackground;
@property (retain, nonatomic) NSTimer *timer;

@end

@implementation ViewController

@synthesize count = count_;
@synthesize countWhenEnterBackground = countWhenEnterBackground_;
@synthesize timer = timer_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self initCompenents];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"View did appear..");
}

// 进入后台不代表这个view就disappear了
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"view did disappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -inits
// 数据初始化
- (void)initData{
    self.count = 0;
    self.countWhenEnterBackground = 0;
    self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)self.count];
}

// 组件初始化
- (void)initCompenents{
    [self registerNotification];
    if (![UIDevice currentDevice].multitaskingSupported) {
        NSLog(@"设备不支持多任务.");
    }
}

- (BOOL)isMultiaskingSupported{
    
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultiaskingSupported)]) {
        return [device isMultitaskingSupported];
    }
    return NO;
}

#pragma mark -Timer测试
// Timer初始化
- (void)initTimer{
    NSTimeInterval timeInterval = 1.0f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

// timer循环事件处理
- (void)handleTimer:(id)sender{
    NSLog(@"handleTimer...%ld",(long)self.count);
    self.count ++;
    [self settingCount:self.count];
}

#pragma mark -进入前后台的系统通知处理
// 监听app进入后台和回到前台的系统通知
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppEnterBackgroudNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppEnterForegroudNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

// 移除对app进入后台和回到前台的系统通知的监听
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

// 处理app进入后台的通知
- (void)handleAppEnterBackgroudNotification:(id)object{
    NSString *dateTime = [DateUtil currentDateTime];
    NSLog(@"处理app进入后台的通知 dateTime:%@",dateTime);
    // 记录进入后台的时间
    self.lblEnterBackgroundTime.text = dateTime;
    self.lblEnterBackgroundTime.textColor = [UIColor redColor];
    // 进入后台时的读数
    self.countWhenEnterBackground = self.count;
    self.lblCountWhenEnterBackground.text = [NSString stringWithFormat:@"%ld",(long)self.countWhenEnterBackground];
    self.lblCountWhenEnterBackground.textColor = [UIColor redColor];
}

// 处理app将回到前台的通知
- (void)handleAppEnterForegroudNotification:(id)object{
    NSString *dateTime = [DateUtil currentDateTime];
    NSLog(@"处理app将进入前台的通知. dateTime:%@",dateTime);
    self.lblEnterForegroundTime.text = dateTime;
    self.lblEnterForegroundTime.textColor = [UIColor blueColor];
}

#pragma mark -IBActions
-(IBAction)btnStartClicked:(id)sender{
    [self startTask];
}

- (IBAction)btnPauseClicked:(id)sender{
    [self pauseTask];
}

- (IBAction)btnStopClicked:(id)sender{
    NSLog(@"stop task");
    [self stopTask];
}

#pragma mark -User Actions
// 开始任务
- (void)startTask{
    NSLog(@"task start..");
    
    /* 启用子线程去执行Timer的任务,模拟器可以一直无限时执行后台任务,真机上一旦按下Home键或者进入其他的应用，后台任务立即暂停
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self startTimer];
    });*/
    
    // 开始后台任务
    [self beginBackgroundTask];
}

// 暂停任务
- (void)pauseTask{
    [self pauseTimer];
}

// 停止任务
- (void)stopTask{
    [self stopTimer];
}

// ---------- iOS 的beginBackgroundTask ----------
// 默认是有一段后台的时间限制，超过该时间，则自动app线程会被挂起，任务停止
- (void)beginBackgroundTask{
    
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier __block backgroundTaskId = [app beginBackgroundTaskWithName:@"timer task" expirationHandler:^{
        [app endBackgroundTask:backgroundTaskId];
        backgroundTaskId = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self startTimer];
    });
}

// ---------- Timer ----------
// 开始Timer
- (void)startTimer{
    if (!self.timer) {
        [self initTimer];
    }else{
        if (![self.timer isValid]) {
            NSLog(@"timer is not valid..");
        }
        [self.timer setFireDate:[NSDate distantPast]];
    }
    // scheduledTimerWithTimeInterval是基于runLoop的,主线程的runLoop默认是开启的,子线程的runloop是关闭的
    // 所以在采用子线程去执行timer的任务的时候,要把该线程的runloop开起来,否则只执行一次，而不会循环执行.
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

// 暂停Timer
- (void)pauseTimer{
    NSLog(@"timer paused..");
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }else{
        NSLog(@"timer is nil.");
    }
}

// 停止Timer
- (void)stopTimer{
    [self pauseTimer];
    if ([self.timer isValid]) {
        [self.timer invalidate]; // 自动将Timer从RunLoop移除
    }
    self.timer = nil;
}

// 具体的任务
- (void)settingCount:(NSInteger)count{
    NSTimeInterval timeRemain = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"application background time remaining:%.02f senconds",timeRemain);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)count];
    });
}

/* 打印结果分析
 前台执行的backgroundTimeRemaining是一个很大的常量,可理解为无限时间
 后台执行开始:application background time remain:179.83
 后台执行停止:application background time remain:4.04
 即在测试设备iPhone4,iOS版本7.1上,默认的能向系统申请的后台执行时间是3分钟左右
 */

@end
