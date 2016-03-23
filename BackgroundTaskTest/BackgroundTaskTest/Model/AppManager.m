//
//  AppManager.m
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/23.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+ (id)defaultManager{
    static dispatch_once_t onceToken;
    static AppManager *appManager = nil;
    dispatch_once(&onceToken, ^{
        if (!appManager) {
            appManager = [[[self class] alloc] init];
        }
    });
    return appManager;
}

- (NSString *)getAppHomeDirectoryPath{
    NSString *userDir  = NSHomeDirectory();
    return userDir;
}

- (NSString *)getAppTempDirectoryPath{
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

- (NSString *)getAppUserDocumentsDirectoryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

@end
