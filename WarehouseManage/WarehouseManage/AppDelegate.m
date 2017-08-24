//
//  AppDelegate.m
//  WarehouseManage
//
//  Created by zhchen on 2017/8/18.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //清理hybird缓存
    //    [BaseWKWebViewVC deleteWebCache];
    
    //设置全局webview的useragent
    //    [BaseWKWebViewVC setGlobalWebUserAgent];
    
    //检查是否被其他app唤起
    [self checkStatus:launchOptions];
    
    //初始化db
    [self initDBData];
    
    //Umeng统计
    [self initStatistic];
    
    //网络
    [self networkingInit];
    
    //设置推送通知,需要用户允许
//    [self registJPush:launchOptions];
    
    //umeng
    //注册第三方,设置微信AppId、appSecret，分享url
    [self UMSocialInit];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 程序进入前台
    //刷一波推送通知消息
    //    [Messages refreshMessagesWithSuccess:nil failure:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 程序重新激活，比如锁屏
    [QGLOBAL postNotif:NotifAppDidBecomeActive data:nil object:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#pragma mark - check login
- (void)checkStatus:(NSDictionary *)launchOptions{
    [self initNavigationBarStyle];
    
    //    if (0) { //开发用
//    if ([[GuideModel getModelFromDB] firstOpen] == NO) { //第一次运行
//        GuideModel *model = [[GuideModel alloc] init];
//        model.firstOpen = YES;
//        model.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        
//        QGLOBAL.guideModel = model;
//        //        [self guideInit];
//        [self mainInit];
//    }else{
//        [self mainInit];
//        
//        
//        //        [QGLOBAL checkAuthResult:^(BOOL enabled) {
//        //
//        //
//        //        }];
//    }
    [self loginInit];
    //判断是不是点击唤起的app
//    [self checkOpenAppStyle:launchOptions];
}

- (void)mainInit{
    QGLOBAL.menu=nil;
    _nav=nil;
    _nav=[[UINavigationController alloc]initWithRootViewController:[QGLOBAL menu]];
    _nav.navigationBarHidden=YES;
    
    if (self.window==nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _nav;
}
- (void)guideInit{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [QGLOBAL viewControllerName:@"GuideVC" storyboardName:@"Guide"];
    
}
- (void)loginInit
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    LoginVC *vc = [LoginVC initFromXib];
    
    self.window.rootViewController = vc;
}
#pragma mark  导航栏
/**
 *  初始化导航栏样式
 */
- (void)initNavigationBarStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //背景色
    [[UINavigationBar appearance] setBarTintColor:RGBHex(kColorMain001)];
    //左右按钮文字颜色
    [[UINavigationBar appearance] setTintColor:RGBHex(kColorW)];
    //标题色
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:RGBHex(kColorW)}];
    
    //把分割线设同色
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[RGBHex(kColorMain001) CGColor]);
    CGContextFillRect(context, rect);
    UIImage * imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - Umeng统计
- (void)initStatistic{
    //iOS平台数据发送策略包括BATCH（启动时发送）和SEND_INTERVAL（按间隔发送）两种
    [MobClick setAppVersion:VERSION];
    //    [MobClick startWithAppkey:kUMengKey reportPolicy:BATCH channelId:kAppChannel];
    UMConfigInstance.appKey = kUMengKey;
    UMConfigInstance.channelId = kAppChannel;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    
}

#pragma mark - 初始化
- (void)initDBData{
    //   [ProjAPI getProjTypeList:YES success:^(NSMutableArray *arr) {
    //
    //   } failure:^(NetError *err) {
    //
    //   }];
}

#pragma mark -  网络
- (void)networkingInit{
    [QGLOBAL checkConnection];
    
}

#pragma mark - JPush
//- (void)registJPush:(NSDictionary *)launchOptions {
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    }
//    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
//    else {
//        //categories 必须为nil
//        
//    }
//    
//    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    
//    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
//    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:launchOptions appKey:kJPUSHKey
//                          channel:kAppChannel //统计渠道
//                 apsForProduction:kIsPushProduction //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
//            advertisingIdentifier:nil];//不用广告为空
//}

#pragma mark - 通过外部程序打开app
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    // 接受传过来的参数
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创意云欢迎您!"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    return YES;
}

#pragma mark- 第三方
- (void)UMSocialInit{
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMengKey];
    
    //    [UMSocialWechatHandler setWXAppId:kWXID appSecret:kWXSecret url:@"www.vsochina.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXID appSecret:kWXSecret redirectURL:@"www.vsochina.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQOpenID appSecret:nil redirectURL:@"www.vsochina.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWBKey appSecret:kWBSecret redirectURL:@"https://api.weibo.com/oauth2/default.html"];
    //    [UMSocialQQHandler setQQWithAppId:kQQOpenID appKey:kQQOpenKey url:@"www.vsochina.com"];
    
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kWBKey
    //                                              secret:kWBSecret
    //                                         RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
}
#pragma mark - 通过通知等打开app
//- (void)checkOpenAppStyle:(NSDictionary *)launchOptions{
//    //badge数字
//    
//    
//    id obj =nil;
//    
//    obj = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if ([QGLOBAL object:obj isClass:[NSDictionary class]]) {
//        //无需这里处理通知
//        //        [Messages pushData:obj appActive:NO];
//        
//        
//        //        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@">>> 是推送点击: %@", obj] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //        [alt show];
//        
//    }
//    
//    obj = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if ([QGLOBAL object:obj isClass:[UILocalNotification class]]) {
//        DLog(@">>> 本地通知: %@", obj);
//    }
//    
//    obj = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
//    if ([QGLOBAL object:obj isClass:[NSURL class]]) {
//        NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
//        DLog(@">>> 由其他应用程序:%@ 通过openURL启动:%@",bundleId, obj);
//    }
//}


#pragma mark - 设置推送类型,不用极光
//- (void)setPushType{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
//    
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        /*
//         UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
//         [acceptAction setActivationMode:UIUserNotificationActivationModeBackground];
//         [acceptAction setTitle:@"One"];
//         [acceptAction setIdentifier:@"QY1_ACTION"];
//         [acceptAction setDestructive:NO];
//         [acceptAction setAuthenticationRequired:NO];
//         
//         UIMutableUserNotificationAction *denyAction = [[UIMutableUserNotificationAction alloc] init];
//         [denyAction setActivationMode:UIUserNotificationActivationModeBackground];
//         [denyAction setTitle:@"Two"];
//         [denyAction setIdentifier:@"QY2_ACTION"];
//         [denyAction setDestructive:NO];
//         [denyAction setAuthenticationRequired:NO];
//         
//         UIMutableUserNotificationCategory *actionCategory = [[UIMutableUserNotificationCategory alloc] init];
//         [actionCategory setIdentifier:@"ACTIONABLE"];
//         [actionCategory setActions:@[acceptAction, denyAction]
//         forContext:UIUserNotificationActionContextDefault];
//         
//         NSSet *categories = [NSSet setWithObject:actionCategory];
//         
//         UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:categories];
//         */
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }
//#else
//    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//#endif
//    
//}

#pragma mark 注册远程推送通知
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    //检查当前用户是否允许通知
//    if (notificationSettings.types != UIUserNotificationTypeNone) {
//        DLog(@">>> 注册远程推送通知");
//        [application registerForRemoteNotifications];
//    }
//}

#pragma mark - 获取 DeviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenSt = [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@">>> 获取 DeviceToken: %@\n%ld", deviceTokenSt,(long)deviceTokenSt.length);
    
    //保存DeviceToken并提交服务器
    
    
    // JPush - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        DLog(@">>> registrationID : %@ resCode：%i",registrationID,resCode);
        //保存DeviceToken，registrationID，Username并提交服务器绑定
        //暂时不用
        /*
         [Messages setDevie:deviceTokenSt regId:registrationID];
         
         if ([QGLOBAL hadAuthToken] && Messages.isRegDevice==false) {
         [MessageAPI PushDevie:deviceTokenSt regId:registrationID username:QGLOBAL.auth.username success:^(NSMutableArray *arr) {
         Messages.isRegDevice=YES;
         } failure:^(NetError *err) {
         
         }];
         }
         */
//    }];
}

#pragma mark- 无法获取设备ID
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@">>> 注册失败，无法获取设备ID, 具体错误: %@", error);
}

#pragma mark- 极光推送 iOS 10 Support 前台获取推送
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//    
//    BOOL appActive=true;
    //内容解析，角标刷新
    //    [Messages pushData:userInfo appActive:appActive];
//}

#pragma mark- 极光推送 iOS 10 Support 点击通知进入
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
//    
//    DLog(@"+++ iOS 10 收到极光推送");
//    BOOL appActive=NO;
    //内容解析
    //    [Messages pushData:userInfo appActive:appActive];
    
    
//}

#pragma mark- 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    DLog(@"+++ 收到推送:%i",(int)[UIApplication sharedApplication].applicationState);
//    BOOL appActive=(UIApplicationStateActive==[UIApplication sharedApplication].applicationState)?true:false;
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
    
    //内容解析
    //    [Messages pushData:userInfo appActive:appActive];
    
}


@end
