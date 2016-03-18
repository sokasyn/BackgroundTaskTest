//
//  DateUtil.m
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/18.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)currentDateTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateTimeTemplate = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setDateFormat:dateTimeTemplate];
    NSString *dateTime = [dateFormatter stringFromDate:date];
    return dateTime;
}

@end
