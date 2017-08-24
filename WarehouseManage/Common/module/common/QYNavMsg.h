//
//  QYNavMsg.h
//  Test
//
//  Created by Qingyang on 17/3/8.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^QYNavMsgBlock) (id obj);

@interface QYNavMsg : UIView
//显示一个提示
+ (QYNavMsg *)showInfoWithDeleget:(id)delegate title:(NSString*)title faluire:(BOOL)faluire;
@end
