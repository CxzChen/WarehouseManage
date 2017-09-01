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
#import "LoginAPI.h"
#import "MJRefresh.h"
@interface CommodityListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *txtSearch;
    MJRefreshNormalHeader *headerMJ;
    NSMutableArray *arrAll;
}
@end

@implementation CommodityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshList];
    [self setupMJ];
    
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
//    [txtSearch becomeFirstResponder];
    
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
    [LoginAPI commodityListStart:nil end:nil success:^(NSMutableArray *arr) {
        [self didLoad];
        self.arrData = [NSMutableArray array];
        arrAll = [NSMutableArray array];
        [arrAll addObjectsFromArray:arr];
        [self.arrData addObjectsFromArray:arr];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityListModel *mm = self.arrData[indexPath.row];
    AccessRecordVC *vc = [AccessRecordVC initFromXib];
    vc.name = mm.good.name;
    vc.uid = mm.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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

#pragma mark 指定可以进行编辑的行(cell)
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark 指定tableView的编辑方式(删除还是添加)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 提交编辑结果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommodityListModel *mm = self.arrData[indexPath.row];
    [LoginAPI DeleteCommidity:mm.uid success:^(id model) {
        [self.arrData removeObject:mm];
        [arrAll removeObject:mm];
        // 让tableView执行编辑操作
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NetError *err) {
        [self showText:@"删除失败"];
    }];
    
}
#pragma mark 修改滑动删除的字样
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
