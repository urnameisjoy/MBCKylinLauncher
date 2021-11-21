//
//  MBCKylinLauncher+willFinishLaunching.m
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/11/9.
//  Copyright © 2021 xyl. All rights reserved.
//

#import "MBCKylinLauncher+willFinishLaunching.h"

@implementation MBCKylinLauncher (willFinishLaunching)
@end

#pragma mark - test3

mbcLaunchRegisterWillFinishLaunch("test3") {
    NSLog(@"execute test3");
}

#pragma mark - test4

mbcLaunchRegisterWillFinishLaunchAsync() {
    NSLog(@"async execute test4");
}
