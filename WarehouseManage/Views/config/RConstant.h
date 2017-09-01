//
//  RConstant.h
//  resource
//
//  Created by Yan Qingyang on 15/10/21.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#ifndef RConstant_h
#define RConstant_h
/* ....................................................................................*/
#pragma mark - ### 生产环境 ###
// ----------------------------- 正式生产环境 API------------------------------- //
#define BASE_URL_INNER                @"http://121.41.32.148:3000/v1/" //@"https://cyy.vsochina.com/"
//#define BASE_URL_APINEW               @"https://apinew.vsochina.com/"
////hybrid h5地址
//#define BASE_HYBRID_URL                  @"https://m.vsochina.com/"

// ----------------------------- 参数------------------------------- //
//极光推送
#define kJPUSHKey @""
#define kIsPushProduction YES
#define kAppChannel                     @"apple store"  //正式环境切这个，代表apple store
#define kH5DevTest NO
#define kH5ShowAlert YES

/* ....................................................................................*/
#pragma mark - *** 开发环境 ***
// ----------------------------- 提测时注释掉 ------------------------------- //
//#define BASE_HYBRID_URL                  @"http://172.16.23.68:8081/"// @"http://172.16.23.215:8081/"//陈甜 @"http://172.16.23.67:8081/"//正云
//#define BASE_HYBRID_URL                       @"http://172.16.23.76:8081/" //新飞
//#define kJPUSHKey @""
//#define kAppChannel                             @"VSO_DEV"
//#define kH5DevTest YES
//#define kH5ShowAlert NO

/* ....................................................................................*/







#pragma mark - 其他常量
//app id
#define kAppleStoreID @"1193111633"
//友盟
#define kUMengKey @"58abfa594ad15631230000fb"
//QQ
#define kQQOpenKey @"aeDFrxXZRbfF1TSp"
#define kQQOpenID @"1106004258"
//微博
#define kWBKey @"2614300090"
#define kWBSecret @"29a875e9029a0f5a6dfe57164319fdd0"
//微信
#define kWXID @"wx20e48d1ff83570f4"
#define kWXSecret @"87bbadce67f21a0df41b9fc984aa1416"

#define kHttpUserAgent      @"VSO-Flag-APIV1-iOS/%@ (iOS %@)"
#define kWebUserAgent       @" VSO-Test/%@ iOS/%@ Language/%@"

#define kAppStoreVersion @"kAppStoreVersion" 

#define kSideMenuShadow AutoValue(80)



#define kPageSize 20 //每页数据条数
//#define kADTime 5 //广告时间延迟5秒
#define kBtnCornerRadius 4 //按钮圆角度数
#define kSignLength 30 //签名字数
#define kNicknameLength 20 //字数

#define kCellHeight 53 //cell高度
#define kTelCDTime 121 //手机验证等待
#define kTaskLineSpac 1.2 // 具体要求行距
#define kTelNum @"400-164-7979"

#pragma mark - 广告文件夹
#define kADFolderName @"ADFolder" 

#pragma mark - 常用语
#define Msg_WIFIOnly @"您设置了WI-FI下载!"
#define Msg_4GDownload @"正在使用流量下载!"
#define Msg_4GUpload @"正在使用流量上传!"

#define Msg_ThirdLoginErr @"网络连接超时，请重试"

#define Err_DataErr @"数据异常!"


#define Msg_Login @"该账号尚未注册"
// 分享
#define Msg_ShareTitle @"flag社-你的脑洞超乎你想象"
#define Msg_ShareContent @"这里汇聚了敢想,敢拼,乐于分享的创作者与爱好者,被吐槽图样图森破?来这里证明自己!"
#define H5_ShareUrl @"https://m.vsochina.com/maker/module/loadpage.html"
// 签署协议提示语
#define Msg_ProtocolAgree @"请先勾选你已阅读协议内容"
#define Msg_PwdFormat @"格式错误,仅限字母数字及字符"
#define Txt_PwdNum @"请设置6-20位密码"
//-----------1.0.20新加提示语----------//
#define Msg_CheckInternet @"网络异常、请检查网络设置"
#define Msg_Is4G @"文件大小为%@，您当前为2G/3G/4G环境，继续预览将耗费较多流量"//@"正在使用手机流量，下载可能产生大量流量消费"
#define Msg_FileNoExist @"文件不存在"

#define Msg_FileDownloadSuccess @"文件下载成功"
#define Msg_FileDownloadNoDiskSpace @"没有足够空间，下载失败"
#define Msg_FileDownloadFailure @"文件下载失败"
#define Msg_FileDownloadCancel @"放弃下载"
//---------------------//
#define H5_BASE_URL @"https://m.vsochina.com/"


#endif /* RConstant_h */
