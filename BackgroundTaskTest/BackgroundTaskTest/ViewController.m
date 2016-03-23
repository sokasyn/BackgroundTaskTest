//
//  ViewController.m
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/18.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timerCount;
@property (assign, nonatomic) NSInteger countWhenEnterBackground;
@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier bgTaskTimer;

@property (unsafe_unretained, nonatomic) UIBackgroundTaskIdentifier bgTaskFile;
@property (assign, nonatomic) NSInteger writtenCount;
@property (assign, nonatomic) NSInteger group;
@property (assign, nonatomic) NSInteger countPerGroup;
@property (assign,nonatomic,getter=isStop) BOOL stop;

@end

@implementation ViewController

@synthesize timer = timer_;
@synthesize timerCount = timerCount_;
@synthesize countWhenEnterBackground = countWhenEnterBackground_;
@synthesize bgTaskTimer = bgTaskTimer_;

@synthesize bgTaskFile = bgTaskFile_;
@synthesize writtenCount = writtenCount;
@synthesize group = group_;
@synthesize countPerGroup = countPerGroup_;

@synthesize stop = stop_;

#define kFileName @"test.txt"
#define kCountPerGroup  30

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
    self.timerCount = 1;
    self.countWhenEnterBackground = 1;
    
    self.group = 1;
    self.writtenCount = 1;
    self.countPerGroup = kCountPerGroup;
    self.stop = YES;
//    self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)self.count];
}

// 组件初始化
- (void)initCompenents{
    [self registerNotification];
    if ([UIDevice currentDevice].multitaskingSupported) {
        NSLog(@"设备支持多任务!");
    }else{
        NSLog(@"设备不支持多任务!");
    }
}

- (BOOL)isMultiaskingSupported{
    UIDevice *device = [UIDevice currentDevice];
    BOOL supported = [device isMultitaskingSupported];
    return supported;
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
    NSLog(@"handleTimer...%ld",(long)self.timerCount);
    self.timerCount ++;
    [self settingCount:self.timerCount];
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
    self.countWhenEnterBackground = self.timerCount;
    self.lblCountWhenEnterBackground.text = [NSString stringWithFormat:@"%ld",(long)self.countWhenEnterBackground];
    self.lblCountWhenEnterBackground.textColor = [UIColor redColor];
    
    // 进入后台，启动后台写文件任务
//    [self beginBackgroundTaskWritingFile];
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
    [self stopTask];
}

#pragma mark -User Actions
// 开始任务
- (void)startTask{
    NSLog(@"task start..");
    self.stop = NO;
    // -------------- 测试 ----------------
    // 启用子线程去执行Timer的任务,模拟器可以一直无限时执行后台任务,真机上一旦按下Home键或者进入其他的应用，后台任务立即暂停
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [self startTimer];
//    });
    
    // 开始后台任务，timer
//    [self beginBackgroundTaskTimer];
    
    // 开始后台任务,写文件
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [self saveInformationToFile];
//    });
    [self beginBackgroundTaskWritingFile];
}

// 暂停任务
- (void)pauseTask{
    self.stop = YES;
    [self pauseTimer];
}

// 停止任务
- (void)stopTask{
    self.stop = YES;
    [self stopTimer];
}

// ---------- iOS 的beginBackgroundTask ----------
// 默认是有一段后台的时间限制，超过该时间，则自动app线程会被挂起，任务停止,并执行expirationHandler清场
- (void)beginBackgroundTaskTimer{
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTaskTimer = [app beginBackgroundTaskWithName:@"timer bg task" expirationHandler:^{
        NSLog(@"timer bg task expirated..");
        [app endBackgroundTask:self.bgTaskTimer];
        self.bgTaskTimer = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self startTimer];
    });
}

- (void)beginBackgroundTaskWritingFile{
    NSLog(@"后台写文件任务启动");
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTaskFile = [app beginBackgroundTaskWithName:@"FileWritingTask" expirationHandler:^{
        NSLog(@"[后台写文件任务]已经终结!");
        [self printBackgroundTimeRemaining];
        [app endBackgroundTask:self.bgTaskFile];
        self.bgTaskFile = UIBackgroundTaskInvalid;
    }];
    // 多线程执行后台任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self saveInformationToFile];
    });
}

// 不一定要等到超出系统给与的时间,在规定时间内任务完成后也应当自行做完结任务清理,此时expirationHandler将不会执行
- (void)endBackgroundTaskWithTaskIdentifer:(UIBackgroundTaskIdentifier)taskIdentifier{
    [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
    taskIdentifier = UIBackgroundTaskInvalid;
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
    [self printBackgroundTimeRemaining];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblCount.text = [NSString stringWithFormat:@"%ld",(long)count];
    });
}

// 打印系统的给app后台的剩余时间,疑惑:本测试,后台的最长时间为180秒左右,怎么都说是10分钟，跟设备和iOS系统有关系吗？
- (void)printBackgroundTimeRemaining{
    NSTimeInterval backgroundTimeRemain = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemain == DBL_MAX) {
        NSLog(@"application background time remaining:DBL_MAX");
    }else{
        NSLog(@"application background time remaining:%.02f senconds",backgroundTimeRemain);
    }
}

/* 打印结果分析
 前台执行的backgroundTimeRemaining是一个很大的常量,可理解为无限时间
 后台执行开始:application background time remain:179.83
 后台执行停止:application background time remain:4.04
 即在测试设备iPhone4,iOS版本7.1上,默认的能向系统申请的后台执行时间是3分钟左右
 */


- (void)saveInformationToFile{
    NSString *tmpPath = [[AppManager defaultManager] getAppTempDirectoryPath];
    NSString *filePath = [tmpPath stringByAppendingPathComponent:kFileName];
    NSLog(@"filePath:%@",filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExist = [fileManager fileExistsAtPath:filePath];
    if (!fileExist) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }else{
        NSLog(@"file:%@ is exist.",filePath);
    }
    [self writeContentToFile:filePath];
}

- (void)writeContentToFile:(NSString *)filePath{

    NSString *dateTime = [NSString stringWithFormat:@"日期:%@\n",[DateUtil currentDateTime]];
    NSLog(@"write content:%@,bytes:%lu",dateTime,(unsigned long)[dateTime lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);

    // 一直要往文件中写入信息，以流的方式
    NSOutputStream *fileOutputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    [fileOutputStream open];
    NSStreamStatus status  = [fileOutputStream streamStatus];
    NSLog(@"file output stream status:%lu",(unsigned long)status);
    if ([fileOutputStream hasSpaceAvailable]) {
        [self outputStream:fileOutputStream write:dateTime];
    }else{
        NSLog(@"fileStream has no space available.");
    }
    // 最大的写入数量
    NSInteger maxCount = self.group * self.countPerGroup;
    while (!self.stop && 1) {
        if (self.writtenCount > maxCount) {
            // 写到最后加个换行,以便下一个写直接就是新行
            self.group++;
            break;
        }
        NSString *counter = [NSString stringWithFormat:@"%ld ",(unsigned long)self.writtenCount];
        [self outputStream:fileOutputStream write:counter];
        NSLog(@"Written count:%ld",(unsigned long)self.writtenCount);
        [self printBackgroundTimeRemaining];
        self.writtenCount ++;
        [NSThread sleepForTimeInterval:1.0f];
    }
    [self outputStream:fileOutputStream write:@"\n"];
    [fileOutputStream close];
//    [self endBackgroundTaskWithTaskIdentifer:self.bgTaskFile];
}

- (void)outputStream:(NSOutputStream *)outputStream write:(NSString *)content{
    [outputStream write:(const uint8_t *)[content cStringUsingEncoding:NSUTF8StringEncoding]
              maxLength:[content lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
}


@end
