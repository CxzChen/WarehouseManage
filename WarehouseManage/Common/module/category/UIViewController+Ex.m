//
//  UIViewController+Ex.m
//  Test
//
//  Created by Qingyang on 17/2/23.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "UIViewController+Ex.h"

@implementation UIViewController (Ex)
+ (id)initFromXib
{
    UIViewController * vc = nil;
    NSString *clazz = NSStringFromClass([self class]);
    vc = [[NSClassFromString(clazz) alloc] initWithNibName:clazz bundle:nil];
    return vc;
}

+ (id)initFromStoryboard:(NSString*)sbName{
    UIViewController *vc=nil;
    NSString *vcName = NSStringFromClass([self class]);
    if (sbName && vcName) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:vcName];
    }
    return vc;
}
@end
