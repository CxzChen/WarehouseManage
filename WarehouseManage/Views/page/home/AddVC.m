//
//  AddVC.m
//  WarehouseManage
//
//  Created by zhchen on 2017/8/22.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "AddVC.h"

@interface AddVC ()
{
    IBOutlet UIView *vScrollContent;
}
@end

@implementation AddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatLabel:CGRectMake(0, 64, APP_W, 45) size:@"商品名:" tag:0 placeholder:@"商品名"];
    [self creatLabel:CGRectMake(0, 109, APP_W, 45) size:@"30:" tag:1 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 154, APP_W, 45) size:@"31:" tag:2 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 199, APP_W, 45) size:@"32:" tag:3 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 244, APP_W, 45) size:@"33:" tag:4 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 289, APP_W, 45) size:@"34:" tag:5 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 334, APP_W, 45) size:@"35:" tag:6 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 379, APP_W, 45) size:@"36:" tag:7 placeholder:@"数量"];
    [self creatLabel:CGRectMake(0, 424, APP_W, 45) size:@"37:" tag:8 placeholder:@"数量"];
    UIView *vSp = [[UIView alloc] initWithFrame:CGRectMake(0, 469, APP_W, 0.5)];
    vSp.backgroundColor = RGBHex(kColorGray206);
    [vScrollContent addSubview:vSp];
    // Do any additional setup after loading the view from its nib.
}
-(void)UIGlobal
{
    [super UIGlobal];
    
    [self naviTitle:@"新增"];
    
    
    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk setTitle:@"保存" forState:UIControlStateNormal];
    btnOk.frame = CGRectMake(15, 519, APP_W-30, 40);
    [btnOk addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOk.titleLabel.font=fontSystem(kFontS34);
    [btnOk setTitleColor:RGBHex(kColorGray213) forState:UIControlStateNormal];
    [btnOk setBackgroundColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    btnOk.layer.cornerRadius=kCornerRadius;
    btnOk.clipsToBounds=YES;
    [vScrollContent addSubview:btnOk];
}

- (void)creatLabel:(CGRect)rect size:(NSString *)size tag:(int)tag placeholder:(NSString *)placeholder
{
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [vScrollContent addSubview:v];
    UIView *vSp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    vSp.backgroundColor = RGBHex(kColorGray206);
    [v addSubview:vSp];
    
    UILabel *lblS = [[UILabel alloc] initWithFrame:CGRectMake(15, 2.5, 50, 40)];
    lblS.text = size;
    lblS.font = fontSystem(kFontS28);
    lblS.textColor = RGBHex(kColorGray204);
    [v addSubview:lblS];
    
    
    UITextField *txt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblS.frame)+15, CGRectGetMinY(lblS.frame), APP_W - 100, 40)];
    txt.textAlignment = NSTextAlignmentLeft;
//    txt.layer.borderWidth = 0.5;
//    txt.layer.cornerRadius = 3;
//    txt.clipsToBounds = YES;
    txt.tag = 100+tag;
    txt.font=fontSystem(kFontS28);
    txt.textColor=RGBHex(kColorGray204);
    txt.delegate=self;
    txt.returnKeyType=UIReturnKeyDone;
    txt.keyboardType = UIKeyboardTypeNumberPad;
    txt.placeholder = placeholder;
    [v addSubview:txt];
    
}

- (void)okAction:(UIButton *)sender
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
