//
//  AccessRecordVC.m
//  Test
//
//  Created by zhchen on 2017/8/18.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "AccessRecordVC.h"
#import "LoginAPI.h"
@interface AccessRecordVC ()<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *vScrollContent;
    IBOutlet NSLayoutConstraint *scrollHeight;
    IBOutlet UILabel *lblName;
    NSString *strAction;
}
@end

@implementation AccessRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatLabel:CGRectMake(0, 144, APP_W, 45) size:@"30" tag:0];
    [self creatLabel:CGRectMake(0, 189, APP_W, 45) size:@"31" tag:1];
    [self creatLabel:CGRectMake(0, 234, APP_W, 45) size:@"32" tag:2];
    [self creatLabel:CGRectMake(0, 279, APP_W, 45) size:@"33" tag:3];
    [self creatLabel:CGRectMake(0, 324, APP_W, 45) size:@"34" tag:4];
    [self creatLabel:CGRectMake(0, 369, APP_W, 45) size:@"35" tag:5];
    [self creatLabel:CGRectMake(0, 414, APP_W, 45) size:@"36" tag:6];
    [self creatLabel:CGRectMake(0, 459, APP_W, 45) size:@"37" tag:7];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshList];
    
    
    UIView *vSp = [[UIView alloc] initWithFrame:CGRectMake(0, 99, APP_W, 0.5)];
    vSp.backgroundColor = RGBHex(kColorGray206);
    [vScrollContent addSubview:vSp];
    UIView *vSp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 504, APP_W, 0.5)];
    vSp2.backgroundColor = RGBHex(kColorGray206);
    [vScrollContent addSubview:vSp];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(55, 104, (APP_W - 100)/3, 30)];
    lbl.text = @"原库存";
    lbl.font = fontSystem(kFontS28);
    lbl.textAlignment = NSTextAlignmentCenter;
    [vScrollContent addSubview:lbl];
    
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
-(void)UIGlobal
{
    [super UIGlobal];
    
    if (QGLOBAL.warehouseType == WarehouseTypeShipments) {
        [self naviTitle:@"出库"];
        strAction = @"out";
    }else if (QGLOBAL.warehouseType == WarehouseTypeWarehousing){
        [self naviTitle:@"入库"];
        strAction = @"in";
    }else if (QGLOBAL.warehouseType == WarehouseTypeReturn){
        [self naviTitle:@"退货"];
        strAction = @"back";
    }
    
    lblName.text = self.name;
    lblName.textColor = RGBHex(kColorGray204);
        
    
}
- (void)creatLabel:(CGRect)rect size:(NSString *)size tag:(int)tag
{
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [vScrollContent addSubview:v];
    UIView *vSp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    vSp.backgroundColor = RGBHex(kColorGray206);
    [v addSubview:vSp];
    
    UILabel *lblS = [[UILabel alloc] initWithFrame:CGRectMake(15, 2.5, 30, 40)];
    lblS.text = size;
    lblS.textAlignment = NSTextAlignmentCenter;
    lblS.font = fontSystem(kFontS28);
    lblS.textColor = RGBHex(kColorGray204);
    [v addSubview:lblS];
    
    UILabel *lblOld = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblS.frame)+10, CGRectGetMinY(lblS.frame), (APP_W - 100)/3, 40)];
    lblOld.font = fontSystem(kFontS28);
    lblOld.textColor = RGBHex(kColorGray204);
    lblOld.textAlignment = NSTextAlignmentCenter;
    lblOld.tag = 10+tag;
    [v addSubview:lblOld];
    
    UITextField *txt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblOld.frame)+15, CGRectGetMinY(lblS.frame), CGRectGetWidth(lblOld.frame), 40)];
    txt.textAlignment = NSTextAlignmentCenter;
    txt.layer.borderWidth = 0.5;
    txt.layer.cornerRadius = 3;
    txt.layer.borderColor = RGBHex(kColorGray204).CGColor;
    txt.clipsToBounds = YES;
    txt.tag = 100+tag;
    txt.font=fontSystem(kFontS28);
    txt.textColor=RGBHex(kColorGray204);
    txt.delegate=self;
    txt.keyboardType = UIKeyboardTypeNumberPad;
    txt.returnKeyType=UIReturnKeyDone;
    if (QGLOBAL.warehouseType == WarehouseTypeWarehousing) {
        txt.placeholder = @"入";
    }else if (QGLOBAL.warehouseType == WarehouseTypeShipments){
        txt.placeholder = @"出";
    }else if (QGLOBAL.warehouseType == WarehouseTypeReturn){
        txt.placeholder = @"退";
    }
    
    [v addSubview:txt];
    
    UILabel *lblNew = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(txt.frame)+15, CGRectGetMinY(lblS.frame), CGRectGetWidth(lblOld.frame), 40)];
    lblNew.text = @"现库存";
    lblNew.textAlignment = NSTextAlignmentCenter;
    lblNew.font = fontSystem(kFontS28);
    lblNew.textColor = RGBHex(kColorGray204);
    lblNew.layer.borderWidth = 0.5;
    lblNew.layer.cornerRadius = 3;
    lblNew.clipsToBounds = YES;
    lblNew.layer.borderColor = RGBHex(kColorGray204).CGColor;
    lblNew.tag = 1000+tag;
    [v addSubview:lblNew];
}
#pragma mark - 获取数据
- (void)refreshList
{
//    [self showLoading];
    [LoginAPI SizeCount:self.uid success:^(NSMutableDictionary *dict) {
        self.dataArry = [NSArray arrayWithObjects:dict[@"30"],dict[@"31"],dict[@"32"],dict[@"33"],dict[@"34"],dict[@"35"],dict[@"36"],dict[@"37"], nil];
//        DLog(@"%@",_dataArry);
        for (int i = 0; i < 8; i ++) {
            UILabel *lblOld = (UILabel *)[self.view viewWithTag:10+i];
            CGFloat value = [self.dataArry[i] intValue];
            if (value > 9999) {
                value = value/10000;
                lblOld.text = [NSString stringWithFormat:@"%.4f万",value];
            }else{
                lblOld.text = [NSString stringWithFormat:@"%.f",value];
            }
        }
        
    } failure:^(NetError *err) {
        [self didLoad];
    }];
    
}

#pragma mark - action
- (void)okAction:(UIButton *)sender {
    [self showLoading];
    BOOL isSuccess = NO;
    NSMutableArray *sizeArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArry.count; i ++) {
//        UILabel *lblOld = (UILabel *)[self.view viewWithTag:10+i];
        CGFloat oldValue = [self.dataArry[i] intValue];
//        lblOld.text = self.dataArry[i];
        UITextField *txt = (UITextField *)[self.view viewWithTag:100+i];
        UILabel *lblNew = (UILabel *)[self.view viewWithTag:1000+i];
        lblNew.textColor = RGBHex(kColorGray204);
        if (QGLOBAL.warehouseType == WarehouseTypeWarehousing || QGLOBAL.warehouseType == WarehouseTypeReturn) {
            CGFloat value = oldValue + txt.text.intValue;
            if (value > 9999) {
                value = value/10000;
                lblNew.text = [NSString stringWithFormat:@"%.4f万",value];
            }else{
                lblNew.text = [NSString stringWithFormat:@"%.f",oldValue + txt.text.intValue];
            }
            if (StrIsEmpty(txt.text)) {
                txt.text = @"0";
            }
            [sizeArr addObject:txt.text];
            isSuccess = YES;
        }else if (QGLOBAL.warehouseType == WarehouseTypeShipments){
            [self didLoad];
            CGFloat value = oldValue - txt.text.intValue;
            if (value < 0) {
                [self didLoad];
                [self showText:[NSString stringWithFormat:@"%d号尺寸出库数量小于总数量",30+i]];
                isSuccess = NO;
                break;
            }else{
                if (value > 9999) {
                    value = value/10000;
                    lblNew.text = [NSString stringWithFormat:@"%.4f万",value];
                }else{
                    lblNew.text = [NSString stringWithFormat:@"%.f",oldValue - txt.text.intValue];
                }
                if (StrIsEmpty(txt.text)) {
                    txt.text = @"0";
                }
                [sizeArr addObject:txt.text];
                isSuccess = YES;
            }
            
        }
        
    }
    if (isSuccess) {
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"确定保存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *can = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self didLoad];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [LoginAPI Inventoryoperation:sizeArr uid:self.uid action:strAction success:^(id model) {
                [self showText:@"操作成功"];
                [self didLoad];
            } failure:^(NetError *err) {
                [self showText:@"操作失败,请重试"];
                [self didLoad];
            }];
        }];
        [alt addAction:can];
        [alt addAction:cancel];
        [self presentViewController:alt animated:YES completion:nil];
        
    }
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
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
