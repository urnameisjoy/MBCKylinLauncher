//
//  MBCKylinLauncher.m
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/9/6.
//  Copyright © 2021 xyl. All rights reserved.
//

#import "MBCKylinLauncher.h"
#import <mach-o/getsect.h>
#import <dlfcn.h>

#ifdef __LP64__
typedef struct section_64 sectionByCPU;
typedef uint64_t uint_tByCPU;
#define getsectbynamefromheaderByCPU getsectbynamefromheader_64
#else
typedef struct section sectionByCPU;
typedef uint32_t uint_tByCPU;
#define getsectbynamefromheaderByCPU getsectbynamefromheader
#endif

typedef struct __DATA_Launch DataLaunch;

void realExecuteStageTask(const char *key, bool async) {
    Dl_info info;
    if (dladdr((const void*)&realExecuteStageTask, &info) == 0) {
        return;
    }
    
    const sectionByCPU *section = getsectbynamefromheaderByCPU(info.dli_fbase, "__DATA", key);
    if (section == NULL) {
        return;
    }
    const uint_tByCPU mach_header = (uint_tByCPU)info.dli_fbase;
    size_t launchsize = sizeof(DataLaunch);
    for (uint_tByCPU addr = section->offset; addr < section->offset + section->size; addr += launchsize) {
        DataLaunch launch = *(DataLaunch *)(mach_header + addr);
        MBCLaunchBlock call = ^(char *launch_name, bool async) {
            if (MBCKylinLauncher.beforeFunc) {
                MBCKylinLauncher.beforeFunc(launch_name, async);
            }
            launch.func_imp();
            if (MBCKylinLauncher.afterFunc) {
                MBCKylinLauncher.afterFunc(launch_name, async);
            }
        };
        if (async) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                call(launch.task_name, true);
            });
        } else {
            call(launch.task_name, false);
        }
    }
}

@implementation MBCKylinLauncher

static MBCLaunchBlock _beforeFunc;
static MBCLaunchBlock _afterFunc;

+ (MBCLaunchBlock)beforeFunc {
    return _beforeFunc;
}

+ (void)setBeforeFunc:(MBCLaunchBlock)beforeFunc {
    _beforeFunc = beforeFunc;
}

+ (MBCLaunchBlock)afterFunc {
    return _afterFunc;
}

+ (void)setAfterFunc:(MBCLaunchBlock)afterFunc {
    _afterFunc = afterFunc;
}

+ (void)setupTaskInStage {
    NSNotificationCenter * __weak center = [NSNotificationCenter defaultCenter];
    id __block token1 = [center addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [center removeObserver:token1];
        [self MBCKylinExecuteStageTask:MBCLaunchStageFinishLaunch];
    }];
    id __block token2 = [center addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [center removeObserver:token2];
        [self MBCKylinExecuteStageTask:MBCLaunchStageBecomeActive];
    }];
    [self MBCKylinExecuteStageTask:MBCLaunchStagePreMain];
}

+ (void)MBCKylinExecuteStageTask:(char *)stage {
    NSArray<NSNumber *> * priorityArray = @[@MBCLaunchPriorityInit,
                                            @MBCLaunchPriorityHigh,
                                            @MBCLaunchPriorityDefault,
                                            @MBCLaunchPriorityLow];
    for (NSNumber *priority in priorityArray) {
        NSString *stage_main = [NSString stringWithFormat:@"__%s.%d.%s", stage, priority.intValue, MBCLaunchQueueMain];
        realExecuteStageTask([stage_main UTF8String], false);
        NSString *stage_async = [NSString stringWithFormat:@"__%s.%d.%s", stage, priority.intValue, MBCLaunchQueueAsync];
        realExecuteStageTask([stage_async UTF8String], true);
    }
}

__attribute__((constructor)) static void mbc_launch_premain(void) {
    [MBCKylinLauncher setupTaskInStage];
}

@end
