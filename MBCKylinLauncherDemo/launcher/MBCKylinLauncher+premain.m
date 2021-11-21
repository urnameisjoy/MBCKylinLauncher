//
//  MBCKylinLauncher+premain.m
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/11/9.
//  Copyright © 2021 xyl. All rights reserved.
//

#import "MBCKylinLauncher+premain.h"

@implementation MBCKylinLauncher (premain)

@end

#pragma mark - launcher timer

static NSMutableDictionary<NSString *, NSNumber *> *timeLog;
mbcLaunchRegister(MBCLaunchStagePreMain, MBCLaunchQueueMain, MBCLaunchPriorityInit, "launcherTimer") {
    timeLog = [NSMutableDictionary dictionary];
    MBCKylinLauncher.beforeFunc = ^(char * _Nullable name, bool async) {
        if (!async && name) {
            NSString *taskName = [[NSString alloc] initWithUTF8String:name];
            if (taskName) {
                CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
                [timeLog setValue:@(startTime) forKey:taskName];
            }
        }
    };
    MBCKylinLauncher.afterFunc = ^(char * _Nullable name, bool async) {
        if (!async && name) {
            NSString *taskName = [[NSString alloc] initWithUTF8String:name];
            if (taskName) {
                NSNumber *startTime = [timeLog valueForKey:taskName];
                if (startTime) {
                    CFTimeInterval endTime = CFAbsoluteTimeGetCurrent();
                    CFTimeInterval consumingTime = (endTime - startTime.doubleValue) * 1000;
#if DEBUG
                    NSLog(@"Launcher: %@ consuming time：%fms", taskName, consumingTime);
#endif
                }
            }
        }
    };
}

#pragma mark - test1

mbcLaunchRegisterPreMain("test1") {
    NSLog(@"execute test1");
}

#pragma mark - test2

mbcLaunchRegisterPreMainAsync() {
    NSLog(@"async execute test2");
}
