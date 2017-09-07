//
//  AppDelegate.h
//  WarehouseManage
//
//  Created by zhchen on 2017/8/18.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
- (void)mainInit;
- (void)loginInit;
@end

