//
//  Umeng.h
//  VSO
//
//  Created by Qingyang on 17/2/8.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#ifndef Umeng_h
#define Umeng_h

//umeng key

#pragma mark - umeng key
///页面的统计 [MobClick beginLogPageView:@"OnePage"]; [MobClick endLogPageView:@"OnePage"];

///普通事件 [MobClick event:@"Forward"];

///计数事件 [MobClick event:(NSString *)eventId attributes:(NSDictionary *)attributes];
///////////[MobClick event:@"purchase" attributes:@{@"type" : @"book", @"quantity" : @"3"}];

///属性内容 [MobClick event:@"Mac_Category" label:cell.textLabel.text];
///////////[MobClick event:@"pay" attributes:@{@"book" : @"Swift Fundamentals"} counter:110];

#pragma mark - 社交统计

#define UMUserRegist @"UMUserRegist" //,注册是否成功,1
#define UMUserTelVerfPage @"UMUserTelVerfPage" //,验证手机页面,0
#define UMUserLoginPage @"UMUserLoginPage" //,登录页面,0
#define UMUserLogin @"UMUserLogin" //,登录,1
#define UMUserLoginQQ @"UMUserLoginQQ" //,QQ登录,0
#define UMUserLoginWB @"UMUserLoginWB" //,微博登录,0
#define UMUserLoginWX @"UMUserLoginWX" //,微信登录,0
#define UMUserUpdateAvatar @"UMUserUpdateAvatar" //,用户更新头像,0
#define UMAuthPerso @"UMAuthPerso" //,个人认证,0
#define UMAuthComp @"UMAuthComp" //,企业认证,0
#define UMSubscrFromHome @"UMSubscrFromHome" //,主页订阅,0
#define UMSubscrFromMine @"UMSubscrFromMine" //,个人菜单订阅,0
#define UMSubscrFromReg @"UMSubscrFromReg" //,注册后订阅,0
#define UMSubscrLeave @"UMSubscrLeave" //,离开订阅,0
#define UMSubscrSuccess @"UMSubscrSuccess" //,成功订阅,1
#define UMHomeSearchBar @"UMHomeSearchBar" //,主页搜索框,0
#define UMHomeTaskHouse @"UMHomeTaskHouse" //,主页需求大厅,0
#define UMSearchCondition @"UMSearchCondition" //,搜索－条件,1
#define UMSearchHistory @"UMSearchHistory" //,搜索－历史关键词,0
#define UMSearchPropose @"UMSearchPropose" //,搜索－推荐,0
#define UMTaskSubmisPage @"UMTaskSubmisPage" //,需求投稿页面,0
#define UMTaskSubmission @"UMTaskSubmission" //,需求投稿,1
#define UMTaskSubmisIncompl @"UMTaskSubmisIncompl" //,需求投稿没填完整,0
#define UMTaskShare @"UMTaskShare" //,需求分享,1
#define UMTaskFavo @"UMTaskFavo" //,需求收藏,0
#define UMTaskComment @"UMTaskComment" //,需求评价,0
#define UMTaskDetailPage @"UMTaskDetailPage" //,需求详情页面,0
#define UMMgrTaskMenu @"UMMgrTaskMenu" //,需求管理菜单,1
#define UMNavSlide @"UMNavSlide" //,导航栏侧滑,0
#define UMTaskFavoList @"UMTaskFavoList" //,需求收藏列表,0
#define UMTaskHot @"UMTaskHot" //,需求最火,0
#define UMTaskRich @"UMTaskRich" //,需求最壕,0
#define UMUserLogin3rd @"UMUserLogin3rd" //,第三方登录,1
#define UMUserRegist3rd @"UMUserRegist3rd" //,第三方登录,1
#define UMTaskShareWB @"UMTaskShareWB" //,需求分享WB,0
#define UMTaskShareWX @"UMTaskShareWX" //,需求分享WX,0
#define UMTaskShareWXFrd @"UMTaskShareWXFrd" //,需求分享WXfrd,0
#define UMTaskShareQQ @"UMTaskShareQQ" //,需求分享QQ,0
#define UMTaskShareQQZone @"UMTaskShareQQZone" //,需求分享QQZ,0
#define UMTaskGuide @"UMTaskGuide" //引导页,1

#endif /* Umeng_h */
