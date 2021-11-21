//
//  MBCKylinLauncher+didFinishLaunching.m
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/11/9.
//  Copyright © 2021 xyl. All rights reserved.
//

#import "MBCKylinLauncher+didFinishLaunching.h"

@implementation MBCKylinLauncher (didFinishLaunching)
@end

#pragma mark - test5

mbcLaunchRegisterDidFinishLaunch("test5") {
    NSLog(@"execute test5");
}

#pragma mark - test6

mbcLaunchRegisterDidFinishLaunchAsync() {
    NSLog(@"async execute test6");
}
