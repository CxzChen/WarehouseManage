//
//  CommodityListVC.m
//  Test
//
//  Created by zhchen on 2017/8/18.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "CommodityListVC.h"
#import "CommodityCell.h"
#import "AccessRecordVC.h"
@interface CommodityListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *txtSearch;
}
@end

@implementation CommodityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CommodityModel *p1 = [[CommodityModel alloc] init];
    p1.name = @"A";
    p1.odlNum = @"153653";
    p1.lastNum = @"22";
    p1.wareNum = @"11";
    p1.shipNum = @"11";
    p1.returnNum = @"1";
    p1.size = @[@"50",@"30",@"20"];
    CommodityModel *p2 = [[CommodityModel alloc] init];
    p2.name = @"B";
    p2.odlNum = @"110";
    p2.lastNum = @"33";
    p2.wareNum = @"11";
    p2.shipNum = @"11";
    p2.returnNum = @"1";
    p2.size = @[@"50",@"30",@"30"];
    CommodityModel *p3 = [[CommodityModel alloc] init];
    p3.name = @"C";
    p3.odlNum = @"90";
    p3.lastNum = @"22";
    p3.wareNum = @"11";
    p3.shipNum = @"11";
    p3.returnNum = @"1";
    p3.size = @[@"50",@"30",@"10"];
    CommodityModel *p4 = [[CommodityModel alloc] init];
    p4.name = @"D";
    p4.odlNum = @"80";
    p4.lastNum = @"8";
    p4.wareNum = @"11";
    p4.shipNum = @"11";
    p4.returnNum = @"1";
    p4.size = @[@"50",@"10",@"20"];
    self.arrData = [NSMutableArray arrayWithObjects:p1,p2,p3,p4, nil];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - UI
-(void)UIGlobal
{
    [super UIGlobal];
    [self naviSearchTextfield:70];
    
}
#pragma mark - 导航栏文字按钮
- (id)naviSearchTextfield:(CGFloat)margin{
    UIView* aView=[[UIView alloc]init];
    float ww=APP_W-margin;
    CGRect frm=CGRectMake(0, 0, ww, 44);//self.navigationController.navigationBar.bounds;
    aView.frame=frm;
    aView.backgroundColor=[UIColor clearColor];
    
    frm.size.width-=15;
    frm.size.height=30;
    //    frm.origin.x=15;
    frm.origin.y=(aView.height-frm.size.height)/2;
    
    txtSearch=nil;
    txtSearch=[[UITextField alloc]initWithFrame:frm];
    txtSearch.backgroundColor=RGBHex(kColorW);
    txtSearch.layer.cornerRadius=txtSearch.height/2;
    txtSearch.clipsToBounds=YES;
    txtSearch.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    txtSearch.returnKeyType=UIReturnKeySearch;
    txtSearch.delegate=self;
    txtSearch.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtSearch.tintColor = RGBHex(kColorMain001);
    [aView addSubview:txtSearch];
    
    frm=CGRectMake(0, 0, 36, 34);
    UIImageView *img=[[UIImageView alloc]initWithFrame:frm];
    img.image=[UIImage imageNamed:@"search"];
    img.contentMode=UIViewContentModeCenter;
    txtSearch.leftView=img;
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    
    [self.navigationItem setTitleView:aView];
    [self naviTitleView:aView];
    //显示键盘
    [txtSearch becomeFirstResponder];
    
    return aView;
}
#pragma mark - 获取数据
- (void)refreshList
{
    [self showLoading];
    
    
}
#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableID;
    
    CommodityCell *cell;
    tableID = @"CommodityCell";
    cell = (CommodityCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
    }
    
    CommodityModel *mm = self.arrData[indexPath.row];
    [cell setCell:mm];
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityModel *mm = self.arrData[indexPath.row];
    AccessRecordVC *vc = [AccessRecordVC initFromXib];
    vc.dataArry = [NSArray arrayWithArray:mm.size];
    vc.oldNum1 = mm.size[0];
    vc.oldNum2 = mm.size[1];
    vc.oldNum3 = mm.size[2];
    vc.name = mm.name;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
#pragma mark - action
- (void)searchAction:(UIButton *)sender
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
