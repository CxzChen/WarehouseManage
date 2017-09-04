//
//  LoginAPI.m
//  WarehouseManage
//
//  Created by zhchen on 2017/8/30.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "LoginAPI.h"

@implementation LoginAPI
+ (void)loginUsername:(NSString *)username password:(NSString *)password success:(void (^)(AuthModel *))success failure:(void (^)(NetError *))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(username);
    dd[@"password"] = StrFromObj(password);
    [HTTPConnecting post:API_Login params:dd success:^(id responseObj) {
        NSDictionary *json=responseObj;
        NSError* err = nil;
        AuthModel* mm = [[AuthModel alloc] initWithDictionary:json error:&err];
        mm.username = username;
        if (success) {
            success(mm);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

// 登录校验
+ (void)checkAuthUsername:(NSString *)username vso_token:(NSString *)vso_token success:(void(^)(UserModel *model))success failure:(void(^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
//    dd[@"username"] = StrFromObj(username);
    dd[@"token"] = StrFromObj(vso_token);
    [HTTPConnecting post:API_LoginStatus params:dd success:^(id responseObj) {
        NSDictionary *dict = responseObj;
        NSError* err = nil;
        UserModel *mm = [[UserModel alloc] initWithDictionary:dict error:&err];
        DLog(@">>> API_UserInfo:%@",mm);
        if (success) {
            success (mm);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
// 新增
+ (void)addCommodityName:(NSString *)name sizeArr:(NSMutableArray *)sizeArr success:(void(^)(UserModel *model))success failure:(void(^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"name"] = StrFromObj(name);
    dd[@"category"] = @"trousers";
    NSString *size;
    for (int i = 0; i < sizeArr.count; i++) {
        size = [NSString stringWithFormat:@"%d",30+i];
        dd[size] = sizeArr[i];
    }
    [HTTPConnecting post:API_Add params:dd success:^(id responseObj) {
        
        if (success) {
            success (responseObj);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
// 商品列表
+ (void)commodityListStart:(NSString *)start end:(NSString *)end success:(void(^)(NSMutableArray *arr))success failure:(void(^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    //    dd[@"username"] = StrFromObj(username);
    if (StrIsEmpty(start) || StrIsEmpty(end)){
        
    }else{
        dd[@"beginTime"] = StrFromObj(start);
        dd[@"endTime"] = StrFromObj(end);
    }
    
    [HTTPConnecting get:API_CommodityList params:dd success:^(id responseObj) {
        NSError* err = nil;
        NSMutableArray *arr = [CommodityListModel arrayOfModelsFromDictionaries:responseObj error:&err];
        if (success) {
            success (arr);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
// 尺寸列表
+ (void)SizeCount:(NSString *)uid success:(void(^)(NSMutableDictionary *dict))success failure:(void(^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"goodId"] = StrFromObj(uid);
    NSString *url = [NSString stringWithFormat:@"%@good/%@/reserve",BASE_URL_INNER,uid];
    [HTTPConnecting get:url params:dd success:^(id responseObj) {
        NSMutableDictionary *dd = responseObj;
        if (success) {
            success (dd);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
// 入/出/退
+ (void)Inventoryoperation:(NSMutableArray *)arr uid:(NSString *)uid action:(NSString *)action success:(void(^)(id model))success failure:(void(^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    NSString *size;
    for (int i = 0; i < arr.count; i++) {
        size = [NSString stringWithFormat:@"%d",30+i];
        dd[size] = arr[i];
    }
    NSString *url = [NSString stringWithFormat:@"%@good/%@/reserve/%@",BASE_URL_INNER,uid,action];
    [HTTPConnecting post:url params:dd success:^(id responseObj) {
        
        if (success) {
            success (responseObj);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
// 删除
+ (void)DeleteCommidity:(NSString *)uid success:(void(^)(id model))success failure:(void(^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@good/%@",BASE_URL_INNER,uid];
    [HTTPConnecting delete:url params:dd success:^(id responseObj) {
        
        if (success) {
            success (responseObj);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}

// 尺寸数量
+ (void)StatisticalSizeCount:(NSString *)uid start:(NSString *)start end:(NSString *)end success:(void(^)(NSMutableArray *arr))success failure:(void(^)(NetError* err))failure
{
    NSString *url = [NSString stringWithFormat:@"%@good/%@/detreserve",BASE_URL_INNER,uid];
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (StrIsEmpty(start) || StrIsEmpty(end)){
        
    }else{
        dd[@"beginTime"] = StrFromObj(start);
        dd[@"endTime"] = StrFromObj(end);
    }
    
    [HTTPConnecting get:url params:dd success:^(id responseObj) {
        NSMutableDictionary *dd = responseObj;
        NSMutableArray *sizeArr = dd[@"size"];
        NSError* err = nil;
        NSMutableArray *arr = [SizeCounModel arrayOfModelsFromDictionaries:sizeArr error:&err];
        
        
        if (success) {
            success (arr);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
@end
