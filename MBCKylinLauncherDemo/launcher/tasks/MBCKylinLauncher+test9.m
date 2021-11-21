//
//  MBCKylinLauncher+test9.m
//  MBCKylinLauncherDemo
//
//  Created by xyl on 2021/11/12.
//  Copyright © 2021 xyl. All rights reserved.
//

#import "MBCKylinLauncher+test9.h"

@implementation MBCKylinLauncher (test9)

+ (void)test9 {
    NSLog(@"execute test9");
}

@end

mbcLaunchRegisterBecomeActive("test9") {
    [MBCKylinLauncher test9];
}
