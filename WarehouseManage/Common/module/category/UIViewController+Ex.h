//
//  UIViewController+Ex.h
//  Test
//
//  Created by Qingyang on 17/2/23.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ex)
+ (id)initFromXib;
+ (id)initFromStoryboard:(NSString*)sbName;
@end
