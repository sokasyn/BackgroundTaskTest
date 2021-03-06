//
//  ViewController.h
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/18.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DateUtil.h"
#import "AppManager.h"

@interface ViewController : UIViewController<AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblCount;

@property (strong, nonatomic) IBOutlet UILabel *lblCountWhenEnterBackground;

@property (strong, nonatomic) IBOutlet UILabel *lblEnterBackgroundTime;

@property (strong, nonatomic) IBOutlet UILabel *lblEnterForegroundTime;

@end

