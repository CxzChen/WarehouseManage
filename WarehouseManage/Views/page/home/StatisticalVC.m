//
//  StatisticalVC.m
//  WarehouseManage
//
//  Created by zhchen on 2017/8/22.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "StatisticalVC.h"
#import "CommodityCell.h"
#import "ASBirthSelectSheet.h"
#import "LoginAPI.h"
#import "StatisticalSizeVC.h"
@interface StatisticalVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *txtSearch;
    NSString *strDateF,*endDateF,*strDate,*endDate;
    UIButton *btnStart,*btnStop;
    MJRefreshNormalHeader *headerMJ;
    NSMutableArray *arrAll;
}
@end

@implementation StatisticalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshList];
    [self setupMJ];
    strDateF = nil;
    endDateF = nil;
    // Do any additional setup after loading the view from its nib.
}
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"统计"];
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
#pragma mark - 上下拉刷新
- (void)setupMJ {
    headerMJ = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    [headerMJ setTitle:@"松开即可刷新" forState:MJRefreshStateIdle];
    self.tableMain.header = headerMJ;
    headerMJ.stateLabel.textColor = RGBHex(kColorGray201);
    headerMJ.stateLabel.font = fontSystem(kFontS26);
    headerMJ.lastUpdatedTimeLabel.textColor = RGBHex(kColorGray203);
    headerMJ.lastUpdatedTimeLabel.font = fontSystem(kFontS20);
    
}

- (void)refreshData{
    [headerMJ beginRefreshing];
}
#pragma mark - 获取数据
- (void)refreshList
{
    [self showLoading];
    [LoginAPI commodityListStart:strDate end:endDate success:^(NSMutableArray *arr) {
        [self didLoad];
        self.arrData = [NSMutableArray array];
        [self.arrData addObjectsFromArray:arr];
        arrAll = [NSMutableArray array];
        [arrAll addObjectsFromArray:arr];
        [self.tableMain.header endRefreshing];
        [self.tableMain reloadData];
    } failure:^(NetError *err) {
        [self didLoad];
        [self showText:@"加载失败，请刷新重试"];
        [self.tableMain.header endRefreshing];
    }];
    
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
    
    CommodityListModel *mm = self.arrData[indexPath.row];
    [cell setCell:mm];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *vH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 82)];
    vH.backgroundColor = RGBHex(kColorW);
    btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame = CGRectMake(15, 0, (APP_W - 52)/2, 40);
    if (StrIsEmpty(strDateF)) {
        [btnStart setTitle:@"起始时间" forState:UIControlStateNormal];
    }else{
        [btnStart setTitle:strDateF forState:UIControlStateNormal];
    }
    
    [btnStart setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [vH addSubview:btnStart];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(btnStart.frame)+3, CGRectGetMinY(btnStart.frame), 16, 40)];
    lbl.text = @"至";
    lbl.textColor = RGBHex(kColorGray203);
    [vH addSubview:lbl];
    
    btnStop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStop.frame = CGRectMake(CGRectGetMaxX(lbl.frame)+3, 0, (APP_W - 52)/2, 40);
    if (StrIsEmpty(endDateF)) {
        [btnStop setTitle:@"截止时间" forState:UIControlStateNormal];
    }else{
        [btnStop setTitle:endDateF forState:UIControlStateNormal];
    }
    [btnStop setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    [btnStop addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
    [vH addSubview:btnStop];
    
    UIView *vSp = [[UIView alloc] initWithFrame:CGRectMake(0, 40, APP_W, 0.5)];
    vSp.backgroundColor = RGBHex(kColorGray206);
    [vH addSubview:vSp];
    UIView *vSp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, APP_W, 0.5)];
    vSp2.backgroundColor = RGBHex(kColorGray206);
    [vH addSubview:vSp2];
    UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAll.frame = CGRectMake(15, CGRectGetMaxY(vSp.frame), APP_W-30, 40);
    [btnAll setTitle:@"全选" forState:UIControlStateNormal];
    [btnAll setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    [btnAll addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
     [vH addSubview:btnAll];
    
    return vH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityListModel *mm = self.arrData[indexPath.row];
    StatisticalSizeVC *vc = [StatisticalSizeVC initFromXib];
    vc.strartTime = strDate;
    vc.endTime = endDate;
    vc.uid = mm.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - action
- (void)startAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSDate *date) {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        strDateF = [formatter stringFromDate:date];
        
        strDate=[QGLOBAL dateToTimeInterval:date];
        [btnStart setTitle:strDateF forState:UIControlStateNormal];
        
        strDate = [NSString stringWithFormat:@"%@ 00:00:00",strDateF];
        
//        RealNameModelDB *mm = [RealNameModelDB getModelFromDB];
//        mm.s_time = strDate;
//        mm.validity_s_time = strDateF;
//        AMDManager.realNameModelDB = mm;
//        NSInteger row;
//        if (areaNum == 0) {
//            row = 3;
//        }else{
//            row = 4;
//        }
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
//        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:datesheet];
}
- (void)stopAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSDate *date) {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        endDateF=[formatter stringFromDate:date];
        endDate=[QGLOBAL dateToTimeInterval:date];
        [btnStop setTitle:endDateF forState:UIControlStateNormal];
        endDate = [NSString stringWithFormat:@"%@ 23:59:59",endDateF];
        [self refreshList];
//        RealNameModelDB *mm = [RealNameModelDB getModelFromDB];
//        mm.e_time = endDate;
//        mm.validity_e_time = endDateF;
//        AMDManager.realNameModelDB = mm;
//        NSInteger row;
//        if (areaNum == 0) {
//            row = 3;
//        }else{
//            row = 4;
//        }
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
//        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:datesheet];
}
- (void)allAction:(UIButton *)sender
{
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [super textFieldShouldReturn:textField];
    self.arrData = [NSMutableArray arrayWithArray:arrAll];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *temp =nil;
    NSMutableArray *strArr = [NSMutableArray array];
    for(int i =0; i < [txtSearch.text length]; i++)
    {
        temp = [txtSearch.text substringWithRange:NSMakeRange(i,1)];
        [strArr addObject:temp];
    }
    for (CommodityListModel *mm in self.arrData) {
        if ([mm.good.name containsString:txtSearch.text]) {
            [arr addObject:mm];
        }else{
            for (NSString *str in strArr) {
                if ([mm.good.name containsString:str]) {
                    [arr addObject:mm];
                }
            }
        }
    }
    NSSet *set = [NSSet setWithArray:arr];
    NSArray *dateArr = [NSArray arrayWithArray:[set allObjects]];
    self.arrData = [NSMutableArray arrayWithArray:dateArr];
    [self.tableMain reloadData];
    if (self.arrData.count < 1) {
        [self showText:@"没有此商品"];
    }
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
