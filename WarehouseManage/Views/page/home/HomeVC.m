//
//  HomeVC.m
//  Test
//
//  Created by zhchen on 2017/8/18.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "HomeVC.h"
#import "CommodityListVC.h"
#import "AddVC.h"
#import "StatisticalVC.h"
@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"首页"];
}

#pragma mark - action
- (IBAction)WarehousingAction:(id)sender {
    UIButton *btn = sender;
    CommodityListVC *vc = [CommodityListVC initFromXib];
    if (btn.tag == 100) {
        QGLOBAL.warehouseType = WarehouseTypeWarehousing;
    }else if (btn.tag == 101){
        QGLOBAL.warehouseType = WarehouseTypeShipments;
    }else if (btn.tag == 102){
        QGLOBAL.warehouseType = WarehouseTypeReturn;
    }
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)addAction:(id)sender {
    AddVC *vc = [AddVC initFromXib];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)statisticalstatisticalstatisticalAction:(id)sender
{
    StatisticalVC *vc = [StatisticalVC initFromXib];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)returnAction:(id)sender {
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
