//
//  MBCKylinLauncher.h
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/9/6.
//  Copyright © 2021 xyl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - configuration

/// launch stage
#define MBCLaunchStagePreMain "mbc_pre" // pre-main
#define MBCLaunchStageFinishLaunch "mbc_lau" // app finish launching
#define MBCLaunchStageBecomeActive "mbc_act" // app become active

/// launch priority
#define MBCLaunchPriorityInit 9 // 一般不需要用到
#define MBCLaunchPriorityHigh 2
#define MBCLaunchPriorityDefault 1
#define MBCLaunchPriorityLow 0

/// launch thread
#define MBCLaunchQueueMain "s"
#define MBCLaunchQueueAsync "a"

#pragma mark - convenience

#define mbcLaunchRegisterPreMain(TASK_NAME) \
        mbcLaunchRegister(MBCLaunchStagePreMain, MBCLaunchQueueMain, MBCLaunchPriorityDefault, TASK_NAME)
#define mbcLaunchRegisterPreMainAsync() \
        mbcLaunchRegister(MBCLaunchStagePreMain, MBCLaunchQueueAsync, MBCLaunchPriorityDefault, nil)

#define mbcLaunchRegisterWillFinishLaunch(TASK_NAME) \
        mbcLaunchRegister(MBCLaunchStageFinishLaunch, MBCLaunchQueueMain, MBCLaunchPriorityHigh, TASK_NAME)
#define mbcLaunchRegisterWillFinishLaunchAsync() \
        mbcLaunchRegister(MBCLaunchStageFinishLaunch, MBCLaunchQueueAsync, MBCLaunchPriorityHigh, nil)

#define mbcLaunchRegisterDidFinishLaunch(TASK_NAME) \
        mbcLaunchRegister(MBCLaunchStageFinishLaunch, MBCLaunchQueueMain, MBCLaunchPriorityDefault, TASK_NAME)
#define mbcLaunchRegisterDidFinishLaunchAsync() \
        mbcLaunchRegister(MBCLaunchStageFinishLaunch, MBCLaunchQueueAsync, MBCLaunchPriorityDefault, nil)

#define mbcLaunchRegisterBecomeActive(TASK_NAME) \
        mbcLaunchRegister(MBCLaunchStageBecomeActive, MBCLaunchQueueMain, MBCLaunchPriorityDefault, TASK_NAME)
#define mbcLaunchRegisterBecomeActiveAsync() \
        mbcLaunchRegister(MBCLaunchStageBecomeActive, MBCLaunchQueueAsync, MBCLaunchPriorityDefault, nil)

#pragma mark - register

#define mbcLaunchRegister(STAGE_KEY, ASYNC, PRIORITY, TASK_NAME) \
        register_launch_task(block_name(), launch_item_name(), STAGE_KEY, ASYNC, PRIORITY, TASK_NAME)

struct __DATA_Launch {
    char * _Nullable task_name;
    void (*func_imp)(void);
};

#define register_launch_task(FUNC_IMP, LAUNCH_ITEM, STAGE_KEY, ASYNC, PRIORITY, TASK_NAME) \
static void FUNC_IMP(void); \
__attribute__((used, section("__DATA," stage_name(STAGE_KEY, ASYNC, PRIORITY)))) \
static const struct __DATA_Launch LAUNCH_ITEM = (struct __DATA_Launch) { \
    (char *)TASK_NAME, \
    (void *)(&FUNC_IMP) \
}; \
static void FUNC_IMP(void)

#define stage_name(STAGE_KEY, ASYNC, PRIORITY) \
        "__" STAGE_KEY "." #PRIORITY "." ASYNC

#define block_name() \
        metamacro_concat(_mbc_kylin_block_, __COUNTER__)
#define launch_item_name() \
        metamacro_concat(_mbc_kylin_launch_item_, __COUNTER__)

#define metamacro_concat(A, B) \
        metamacro_concat_(A, B)
#define metamacro_concat_(A, B) A ## B

typedef void(^MBCLaunchBlock)(char * _Nullable name, bool async);
@interface MBCKylinLauncher : NSObject
@property (class, nonatomic, copy, nullable) MBCLaunchBlock beforeFunc;
@property (class, nonatomic, copy, nullable) MBCLaunchBlock afterFunc;
@end

NS_ASSUME_NONNULL_END
