//
//  LoginAPI.h
//  WarehouseManage
//
//  Created by zhchen on 2017/8/30.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAPI : NSObject
// 登录
+ (void)loginUsername:(NSString *)username password:(NSString *)password success:(void(^)(AuthModel*  model))success failure:(void(^)(NetError* err))failure;

// 登录校验
+ (void)checkAuthUsername:(NSString *)username vso_token:(NSString *)vso_token success:(void(^)(UserModel *model))success failure:(void(^)(NetError* err))failure;
// 新增
+ (void)addCommodityName:(NSString *)name sizeArr:(NSMutableArray *)sizeArr success:(void(^)(UserModel *model))success failure:(void(^)(NetError* err))failure;
// 商品列表
+ (void)commodityListStart:(NSString *)start end:(NSString *)end success:(void(^)(NSMutableArray *arr))success failure:(void(^)(NetError* err))failure;
// 尺寸列表
+ (void)SizeCount:(NSString *)uid success:(void(^)(NSMutableDictionary *dict))success failure:(void(^)(NetError* err))failure;
// 入/出/退
+ (void)Inventoryoperation:(NSMutableArray *)arr uid:(NSString *)uid action:(NSString *)action success:(void(^)(id model))success failure:(void(^)(NetError* err))failure;
// 删除
+ (void)DeleteCommidity:(NSString *)uid success:(void(^)(id model))success failure:(void(^)(NetError* err))failure;
// 尺寸数量
+ (void)StatisticalSizeCount:(NSString *)uid start:(NSString *)start end:(NSString *)end success:(void(^)(NSMutableArray *arr))success failure:(void(^)(NetError* err))failure;
@end

