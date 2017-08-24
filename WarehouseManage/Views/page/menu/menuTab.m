//
//  menuTab.m
//  CloudBox
//
//  Created by qyyan on 15/12/2.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "menuTab.h"
@interface menuTab ()
{
    NSString *path;
    id curSel;
//    NSString *
}
@end

@implementation menuTab

- (id)initWithDelegate:(id)dlg{
    self = [super init];
    if (self) {
        self.delegate=dlg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBar];
    self.selectedIndex = Enum_TabBar_Items_Home;
//    [self getCurVC:Enum_TabBar_Items_Search];
    [[UITabBar appearance] setBackgroundColor:RGBHex(kColorGray209)];

}



/**
 *  初始化tab标签样式
 */
- (void)initTabBar
{
    QYTabbarItem *bar1=[QYTabbarItem new];
    bar1.title=@"首页";
    bar1.clazz=@"HomeVC";
    bar1.storyboard=nil;//@"cloudBox";
    bar1.picNormal=@"shouy";
    bar1.picSelected=@"shouy2";
    bar1.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Home];
    
    QYTabbarItem *bar2=[QYTabbarItem new];
    bar2.title=@"销售单";
    bar2.clazz=@"";
    bar2.storyboard=nil;
    bar2.picNormal=@"xiangm";
    bar2.picSelected=@"xiangm2";
    bar2.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Projet];
    
    QYTabbarItem *bar3=[QYTabbarItem new];
    bar3.title=@"客户";
    bar3.clazz=@"";
    bar3.storyboard=nil;
    bar3.picNormal=@"quanz";
    bar3.picSelected=@"quanz2";
    bar3.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Group];
    
    QYTabbarItem *bar4=[QYTabbarItem new];
    bar4.title=@"商品";
    bar4.clazz=@"";
    bar4.storyboard=nil;
    bar4.picNormal=@"huod";
    bar4.picSelected=@"huod2";
    bar4.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Activity];
    
//    QYTabbarItem *bar5=[QYTabbarItem new];
//    bar5.title=@"";
//    bar5.clazz=@"";
//    bar5.storyboard=nil;
//    bar5.picNormal=@"wod";
//    bar5.picSelected=@"wod2";
//    bar5.tag=[NSString stringWithFormat:@"%i",Enum_TabBar_Items_Mine];
    
    [self addTabBarItem:bar1,nil];//
}

- (void)getCurVC:(int)tag{
    if (tag<0||tag>=self.viewControllers.count) {
        return;
    }
    curSel=self.viewControllers[tag];
    
}
#pragma mark - didSelect
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    DLog(@"didSelectItem:%@",item);
//    if (item.tag!=Enum_TabBar_Items_Add) {
//        [self getCurVC:item.tag];
//    }
 
    //    [self showBadgePoint:YES itemTag:tabBarController.selectedIndex];
    //    [self showBadgeNum:99 itemTag:tabBarController.selectedIndex];
    //    UINavigationController *nav = self.arrTabItems[item.tag];
    //    if([nav.topViewController isKindOfClass:[UserCenterPageViewController class]]){
    //        UserCenterPageViewController *VC = (UserCenterPageViewController *)nav.topViewController;
    //        VC.tabBarItemSelected = YES;
    //    }
    
}


@end
