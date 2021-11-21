//
//  MBCKylinLauncher+didBecomeActive.m
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/11/9.
//  Copyright © 2021 xyl. All rights reserved.
//

#import "MBCKylinLauncher+didBecomeActive.h"

@implementation MBCKylinLauncher (didBecomeActive)
@end

#pragma mark - test7

mbcLaunchRegisterBecomeActive("test7") {
    NSLog(@"execute test7");
}

#pragma mark - test8

mbcLaunchRegisterBecomeActiveAsync() {
    NSLog(@"async execute test8");
}
