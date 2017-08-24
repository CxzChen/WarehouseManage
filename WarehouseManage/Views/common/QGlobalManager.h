//
//  QGlobalManager.h
//  resource
//
//  Created by Yan Qingyang on 15/10/13.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "GlobalManager.h"
#import "menuTab.h"
#import "QYSlideslipA.h"
#import "UserModel.h"
//#import "SignVC.h"
typedef NS_ENUM(NSInteger, WarehouseType){
    WarehouseTypeDefault = 0,
    WarehouseTypeShipments , // 出库
    WarehouseTypeWarehousing, // 入库
    WarehouseTypeReturn, // 退货
};
#define  QGLOBAL [QGlobalManager sharedInstance]
#define APPDelegate (AppDelegate*)[UIApplication sharedApplication].delegate
#define APPRootVC [UIApplication sharedApplication].keyWindow.rootViewController

@interface QGlobalManager : GlobalManager

@property (nonatomic, retain) NSString *curPath;
@property (nonatomic, retain) NSString *uploadPath;

@property (nonatomic, strong) menuTab *menu;
@property (nonatomic, strong) AuthModel *auth;
@property (nonatomic, strong) UserModel *usermodel;
@property (nonatomic,strong) GuideModel *guideModel;

@property (nonatomic, strong) UIImage *navAvatar;
@property (nonatomic,strong) NSMutableArray *indusArr;
@property (nonatomic,assign)WarehouseType warehouseType;
+ (instancetype)sharedInstance;

#pragma mark - apple store
- (void)openAppStoreLink;

//- (void)checkAuthResult:(void(^)(BOOL enabled))block;
//- (void)logout;
//- (void)logoutSuccess:(void (^)(BOOL isLogout))isLogout;
//- (void)authInvalid;
//- (void)userInfo:(NSString*)uname success:(void(^)(id model))success failure:(void(^)(id err))failure;

#pragma mark - 检查用户名，电话等
- (BOOL)isUsername:(NSString*)text;
- (BOOL)isNickname:(NSString*)text;
#pragma mark - file download

#pragma mark - 自动消息
//- (void)showText:(NSString*)txt;
#pragma mark 时间格式
- (NSString*)dateTimeIntervalToStr:(NSString*)datetime;
- (NSString *)dateDiffFromTimeInterval:(NSString *)datetime;
#pragma mark - video

#pragma mark - file path

#pragma mark - auth
- (BOOL)hadAuthToken;
#pragma mark - 倒计时
//- (void)setCD:(BOOL)reset btn:(UIButton*)btn type:(TelCheckType)type;
//#pragma mark - 发布
//- (void)publishInVC:(UIViewController*)sourceVC toVC:(UIViewController*)destinationVC;
@end
