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

#pragma mark -User Actions
// 开始
- (void)startTask{
    NSLog(@"task start..");
    if (!self.timer) {
        [self initTimer];
    }else{
        NSLog(@"timer has been exits.");
    }
    [self.timer fire];
}

// 暂停
- (void)pauseTask{
    NSLog(@"task pause..");
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 具体的任务
- (void)settingCount:(NSInteger)count{
    self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)count];
}

@end
