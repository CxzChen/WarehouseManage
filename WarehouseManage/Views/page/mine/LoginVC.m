//
//  LoginVC.m
//  WarehouseManage
//
//  Created by zhchen on 2017/8/23.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
{
    IBOutlet UITextField *txtUser,*txtPwd;
    IBOutlet UIButton *btnOk;
    IBOutlet UILabel *lblUser,*lblPwd;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *vSp = [[UIView alloc] initWithFrame:CGRectMake(15, 119, APP_W-30, 0.5)];
    vSp.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:vSp];
    UIView *vSp2 = [[UIView alloc] initWithFrame:CGRectMake(15, 164, APP_W-30, 0.5)];
    vSp2.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:vSp2];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"登录"];
    txtUser.textColor = RGBHex(kColorGray204);
    txtPwd.textColor = RGBHex(kColorGray204);
    lblUser.textColor = RGBHex(kColorGray204);
    lblPwd.textColor = RGBHex(kColorGray204);
    
    btnOk.titleLabel.font=fontSystem(kFontS34);
    [btnOk setTitleColor:RGBHex(kColorGray213) forState:UIControlStateNormal];
    [btnOk setBackgroundColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    btnOk.layer.cornerRadius=kCornerRadius;
    btnOk.clipsToBounds=YES;
    
}
- (IBAction)btnOkAction:(id)sender {
    [self.view endEditing:YES];
    
    if (![QGLOBAL isUsername:txtUser.text]){
        [self showText:@"用户名格式不正确!"];
        return;
    }
    
    if (![QGLOBAL isPassword:txtPwd.text]){
        [self showText:@"密码格式不正确!"];
        return;
    }
    if ([QGLOBAL isUsername:txtUser.text] && [QGLOBAL isPassword:txtPwd.text]){
        [self showLoading];
    }else{
        [self showText:@"用户名或密码格式不正确!"];
    }
    [APPDelegate mainInit];
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
