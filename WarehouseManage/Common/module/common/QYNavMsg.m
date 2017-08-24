//
//  QYNavMsg.m
//  Test
//
//  Created by Qingyang on 17/3/8.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "QYNavMsg.h"
@interface QYNavMsg()
{
    //public
    IBOutlet UIView *vMain;
    IBOutlet UIButton *btnClick;
    
    //info
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgvIcon;
  
}
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy, readwrite) QYNavMsgBlock aBlock ;

//@property (nonatomic, strong) id data;
@end

@implementation QYNavMsg
//显示一个提示
+ (QYNavMsg *)showInfoWithDeleget:(id)delegate title:(NSString*)title faluire:(BOOL)faluire{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QYNavMsg" owner:nil options:nil];
    QYNavMsg *vv = [nibView objectAtIndex:0];//注意对应xib
    vv.delegate = delegate;

    [vv showInfoTitle:title faluire:faluire];
    return vv;
}

//显示消息，带点击回调
+ (QYNavMsg *)showMsgWithDeleget:(id)delegate block:(QYNavMsgBlock)block{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QYNavMsg" owner:nil options:nil];
    QYNavMsg *vv = [nibView objectAtIndex:1];
    vv.delegate = delegate;
    vv.aBlock = block;
//    [vv show];
    return vv;
}

- (void)cancel{
    [self removeFromSuperview];
}

#pragma mark - 提示语
- (void)UIInfo{
    vMain.backgroundColor=RGBAHex(kColorMain001, 0);
    self.backgroundColor=RGBAHex(kColorMain001, 1);
    
    lblTitle.textColor=RGBHex(kColorGray213);
    lblTitle.font=fontSystem(kFontS34);
}

- (void)dataInfoTitle:(NSString*)title faluire:(BOOL)faluire{
    [self UIInfo];
    
    lblTitle.text=title;
    [lblTitle sizeToFit];
    lblTitle.width += 1;
    
    lblTitle.y=0;
    lblTitle.height=vMain.height;
    if (faluire) {
        imgvIcon.image=[UIImage imageNamed:@"guanzcg2"];
    }
    else {
        imgvIcon.image=[UIImage imageNamed:@"guanzcg"];
    }
    
    CGFloat mg=5;
    CGFloat xx=(APP_W - imgvIcon.width - mg - lblTitle.width)/2;
    imgvIcon.x=xx;
    lblTitle.x=CGRectGetMaxX(imgvIcon.frame)+mg;
}

- (void)showInfoTitle:(NSString*)title faluire:(BOOL)faluire{
    [self dataInfoTitle:title faluire:faluire];
    
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    self.y=0-self.height;
    self.width=APP_W;
    [win addSubview:self];
    [win bringSubviewToFront:self];
    
    self.alpha=1;
    self.hidden=NO;

    [UIView animateWithDuration:.25 animations:^{
        self.y=0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeInfo) withObject:nil afterDelay:1.2];
    }];
}

- (void)removeInfo{
    [UIView animateWithDuration:.25 animations:^{
        self.y=0-self.height;
    } completion:^(BOOL finished) {
        [self cancel];
    }];
}
#pragma mark - 消息推送
@end
