//
//  StatisticalSizeVC.m
//  WarehouseManage
//
//  Created by zhchen on 2017/9/4.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "StatisticalSizeVC.h"
#import "LoginAPI.h"
#import "SizeCounCell.h"
@interface StatisticalSizeVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation StatisticalSizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshList];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 获取数据
- (void)refreshList
{
    [self showLoading];
    [LoginAPI StatisticalSizeCount:self.uid start:self.strartTime end:self.endTime success:^(NSMutableArray *arr) {
        [self didLoad];
        self.arrData = [NSMutableArray arrayWithArray:arr];
        
        [self.tableMain reloadData];
        
        
        
        
        
    } failure:^(NetError *err) {
        [self didLoad];
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
    
    SizeCounCell *cell;
    tableID = @"SizeCounCell";
    cell = (SizeCounCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
    }
    
    SizeCounModel *mm = self.arrData[indexPath.row];
    [cell setCell:mm];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
