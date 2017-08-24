//
//  QYInput.m
//  Test
//
//  Created by Qingyang on 17/3/6.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "QYInput.h"
#import "MBProgressHUD.h"
static NSUInteger kMaxNum = 200;
@interface QYInput()<UITextViewDelegate>
{
    IBOutlet UIButton *btnShadow;
    
    IBOutlet UIView *vMain;
    
    IBOutlet UIButton *btnClose,*btnOK;
    IBOutlet UILabel *lblTtl;
    IBOutlet UITextView *txtvInput;
    
    
}
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy, readwrite) QYInputCallBack callBack ;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeholder;//
@property (nonatomic, strong) NSString *hint;//提示文字
@property (nonatomic, strong) NSString *history;//历史文字
@property (assign) NSUInteger maxNum;
@property (assign) BOOL isHidden;
@end

@implementation QYInput
+ (QYInput *)showInputWithDeleget:(id)delegate callBack:(QYInputCallBack)callBack{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QYInput" owner:nil options:nil];
    QYInput *vv=[nibView objectAtIndex:0];
    vv.delegate=delegate;
    vv.callBack=callBack;
    vv.history=nil;
    vv.isHidden=YES;
//    vv.placeholder=@"限制字数200";
    [vv show];
    return vv;
}

+ (QYInput *)showInputWithDeleget:(id)delegate maxNum:(NSUInteger)maxNum title:(NSString*)title placeholder:(NSString*)placeholder hint:(NSString*)hint history:(NSString*)history callBack:(QYInputCallBack)callBack{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"QYInput" owner:nil options:nil];
    QYInput *vv=[nibView objectAtIndex:0];
    vv.delegate=delegate;
    vv.callBack=callBack;
    vv.maxNum=maxNum;
    vv.hint=hint;
    vv.placeholder=placeholder;
    vv.title=title;
    vv.history=history;
    vv.isHidden=YES;
    [vv show];
    return vv;
}

- (void)UIGlobal{
    [self dataInit];
    
    vMain.backgroundColor=RGBAHex(kColorGray207, 1);
    self.backgroundColor=RGBAHex(kColorW, 0);
    btnShadow.backgroundColor=RGBAHex(kColorB, 0);
    
    
    lblTtl.textColor=RGBHex(kColorGray204);
    lblTtl.font=fontSystem(kFontS32);

    [btnOK setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [btnClose setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
//    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
//    CGFloat mg=(win.width-btnProj.width*2)/3;

    txtvInput.layer.borderColor=RGBHex(kColorGray211).CGColor;
    txtvInput.layer.borderWidth=0.5;
    txtvInput.textColor=RGBHex(kColorGray210);
    txtvInput.tintColor=RGBHex(kColorGray210);
    txtvInput.delegate=self;
}

- (void)dataInit{
    if (self.maxNum==0) {
        self.maxNum=kMaxNum;
    }
    
    if (StrIsEmpty(self.hint)) {
        self.hint=[NSString stringWithFormat:@"输入长度超过%li字限制",(long)self.maxNum];
    }
    
    lblTtl.text=self.title;
    txtvInput.placeholder=self.placeholder;
    
    txtvInput.text=nil;
    if (StrIsEmpty(self.history)) {
        txtvInput.text=self.history;
    }
    
    
}

- (void)show{
    [self UIGlobal];
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate]
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    CGRect frm=win.bounds;
    self.frame=frm;
    [win addSubview:self];
    [win bringSubviewToFront:self];
    
    
    
    
    vMain.y=win.height;
   
    
    //监听键盘
    [self addObserverKeyboardEvent];
    //唤起键盘
    [txtvInput becomeFirstResponder];
    
    
    btnShadow.hidden=NO;
    btnShadow.backgroundColor=RGBAHex(kColorB, 0);
    [UIView animateWithDuration:.25 animations:^{
        btnShadow.backgroundColor=RGBAHex(kColorB, kAlphaShadow);

        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancel{
    btnShadow.hidden=YES;
    [self removeObserverKeyboardEvent];
    [self removeFromSuperview];
}
#pragma mark - action
- (IBAction)closeAction:(id)sender{
    [txtvInput resignFirstResponder];
    
    [UIView animateWithDuration:.35 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];

    } completion:^(BOOL finished) {
        [self cancel];
    }];
}

- (IBAction)okAction:(id)sender{
    
    [txtvInput resignFirstResponder];
    
    [UIView animateWithDuration:.35 animations:^{
        btnShadow.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        if (self.callBack) {
            if ([[txtvInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                self.callBack(nil);
            }
            else
                self.callBack(txtvInput.text);
        }
        [self performSelector:@selector(cancel) withObject:nil afterDelay:0.05];
    }];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = self.maxNum - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }
    else{
        [self showText:self.hint];
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.maxNum)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:self.maxNum];
        [textView setText:s];
        
        [self showText:self.hint];
    }
    
    //不让显示负数
//    self.lbNums.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}
#pragma mark -
- (void)showText:(NSString*)txt{
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = txt;
    hud.detailsLabelText = txt;
    //    hud.margin = 10.f;
    //    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=1.2;//(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

#pragma mark - Keyboard
-(void)keyboardWillChangeFrame:(NSNotification*)notif{
    CGRect frmKeyboard = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat durtion = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (frmKeyboard.origin.y == self.height){ //收起
        [UIView animateWithDuration:durtion animations:^{
            //在这里进行弹键盘收起时对界面移动的处理
            vMain.y=self.height;
        } completion:^(BOOL finished) {
            if (self.isHidden==NO) {
                [self cancel];
            }
            
        }];
    }
    else {           //弹出
        [UIView animateWithDuration:durtion animations:^{
            //在这里进行弹出时对界面移动的处理
            vMain.y=self.height-vMain.height-frmKeyboard.size.height;
            self.isHidden=NO;
        }];
    }
}

-(void)addObserverKeyboardEvent{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)removeObserverKeyboardEvent{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
@end
