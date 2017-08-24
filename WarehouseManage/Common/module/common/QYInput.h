//
//  QYInput.h
//  Test
//
//  Created by Qingyang on 17/3/6.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QYInputCallBack) (NSString *text);

@interface QYInput : UIView
+ (QYInput *)showInputWithDeleget:(id)delegate callBack:(QYInputCallBack)callBack;
@end
