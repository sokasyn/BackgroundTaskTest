//
//  AppManager.h
//  BackgroundTaskTest
//
//  Created by 李星月 on 16/3/23.
//  Copyright © 2016年 com.emin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

+ (id)defaultManager;
- (NSString *)getAppHomeDirectoryPath;
- (NSString *)getAppTempDirectoryPath;
- (NSString *)getAppUserDocumentsDirectoryPath;


@end
