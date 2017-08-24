//
//  QWDatePicker.h
//  wenyao
//
//  Created by Yan Qingyang on 15/4/14.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QYDatePickerCallBack) (NSDate *date);

@interface QYDatePicker : UIView
//@property (nonatomic, weak) id delegate;
//@property (nonatomic, strong) NSString    *dateString;
@property (nonatomic, strong) NSDate    *date;
@property (nonatomic, copy, readwrite) QYDatePickerCallBack callBack ;//按钮点击事件的回调

//+ (QWDatePicker *)instanceWithDelegate:(id)delegate dateString:(NSString*)dateString;
+ (QYDatePicker *)instanceWithDate:(NSDate*)date callBack:(QYDatePickerCallBack)callBack;
//- (void)show;;
@end
