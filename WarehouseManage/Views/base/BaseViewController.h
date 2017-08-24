//
//  basePage.h
//  Show
//
//  Created by YAN Qingyang on 15-2-11.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "BaseVC.h"
#import "MBProgressHUD.h"
//#import "Constant.h"
#import "Warning.h"
//#import "QWGlobalManager.h"
//#import "MJRefresh.h"
#import "Notification.h"

#define kNavibarH 64 //导航栏总高
#define kNaviViewH (kNavibarH-20) //导航栏可用区域
#define kTopBarItemWidth 36
#define kTopBarItemHeight 36
#define kTopBarItemMargin 15
#define kTopBarItemFixMargin (0-(8+4*SCREEN_SCALE))//-16,-16,-20，对应3种机型
#define kTopBarItemViewWidth 60

@interface BaseViewController : BaseVC
<MBProgressHUDDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    IBOutlet UIButton *btnPopVC;
}
@property (nonatomic, strong) UINavigationBar * naviBar;
@property (nonatomic, strong) UINavigationItem *naviItem;
@property (nonatomic, strong) IBOutlet UITableView *tableMain;

@property (nonatomic, strong) UIView *vInfo;
@property (nonatomic, strong) UIView *vInfoLogin;
@property (nonatomic, strong) UIView *vInfoRefresh;
@property (nonatomic, strong) UIView *vGif;
//@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic, assign) BOOL slipDisabled;//禁止滑动返回
@property (nonatomic, assign) BOOL hidesMenu;
@property (nonatomic, assign) BOOL hidesPopNav;//隐藏上一页导航栏
@property (nonatomic, assign) BOOL backButtonEnabled;
/**
 *  app的UI全局设置，包括背景色，top bar背景等
 */
- (void)UIGlobal;

/**
 *  获取全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param obj  通知来源
 */
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj;

/**
 *  touch up inside动作，返回上一页
 *
 *  @param sender 触发返回动作button
 */
- (IBAction)popVCAction:(id)sender;

//跳转到指定页
- (IBAction)jumpToPopVCAction:(id)sender;
/**
 *  显示等待菊花
 */
- (void)showLoading;
- (void)showLoadingWin;
/**
 *  等待并显示文字
 *
 *  @param msg 文字
 */
- (void)showLoadingWithMessage:(NSString*)msg;
/**
 *  等待并显示图片
 *
 *  @param msg 图片
 */
- (void)showLoadingImageWithImg:(NSString *)img Message:(NSString*)msg;
/**
 *  关闭等待
 */
- (void)didLoad;

/**
 *  显示成功/失败
 *
 *  @param msg 文字
 */
- (void)showSuccess:(NSString *)msg;
- (void)showError:(NSString *)msg;

/**
 *  显示提示信息
 *
 *  @param txt 显示内容
 */
- (void)showText:(NSString*)txt;

/**
 *  显示提示信息
 *
 *  @param txt   内容
 *  @param delay 延迟几秒后消失
 */
- (void)showText:(NSString*)txt delay:(double)delay;
- (void)showWindowText:(NSString*)txt delay:(double)delay;
/**
 *  显示错误信息
 *
 *  @param error 错误对象
 */
- (void)showErrorMessage:(NSError*)error;

/**
 *  调试用
 *
 *  @param msg 多字符串参数，结尾加nil
 */
- (void)showLog:(NSString*)msg, ...;


//- (void)zoomClick;
- (void)backToPreviousController:(id)sender;


#pragma mark - 导航栏
#pragma mark 导航返回按钮自定义
- (id)naviBackButton;
- (id)naviTitle:(NSString*)ttl;
- (id)naviTitleView:(UIView*)aView;
- (id)naviLeftButton:(NSString*)aTitle action:(SEL)action;
- (id)naviRightButton:(NSString*)aTitle action:(SEL)action;
- (id)naviLeftButtonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action;
- (id)naviRightButtonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action;
#pragma mark 导航栏左右自定义
- (id)naviBarLeftView:(UIView*)aView;
- (id)naviBarRightView:(UIView*)aView;
#pragma mark - 角标
- (void)setNaviLeftBadge:(NSInteger)num;
#pragma mark 是否联网
/**
 *  是否联网
 *
 *  @return <#return value description#>
 */
- (BOOL)isNetWorking;
/**
 *  显示无数据状态，断网状态
 *
 *  @param text      说明文字
 *  @param imageName 图片名字
 */
#pragma mark info
-(void)showInfoView:(NSString *)text image:(NSString*)imageName;
-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag;
// 登录
-(void)showInfoViewLogin:(NSString *)text image:(NSString*)imageName;
-(void)showInfoViewLogin:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag;
-(void)showFailureView:(NSString *)text image:(NSString*)imageName btnHidden:(BOOL)btnHidden sel:(SEL)selector;
#pragma mark 动图
-(void)showGifLoading;

/**
 *  移除上面的东西
 */
- (void)removeInfoView;

- (void)removeInfoLoginView;
- (void)removeFailureView;
- (void)removeGifLoadingView;
/**
 *  点击后调用该空方法
 *
 *  @param sender nil
 */
- (IBAction)viewInfoClickAction:(id)sender;


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender;


@end
