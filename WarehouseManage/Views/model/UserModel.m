//
//  UserModel.m
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@end
@implementation AuthModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"authid"}];
}
@end
@implementation GuideModel

@end
@implementation PersonalInfoModel

@end

@implementation RealNameModelDB
+ (NSString *)getPrimaryKey{
    return @"username";
}
@end
@implementation RealNameModel

@end
@implementation CompanyAuthModelDB

@end
@implementation CompanyAuthModel

@end

@implementation AuthAreaListModel

@end
@implementation AuthCityModel

@end
@implementation AuthCountyModel

@end
@implementation GroupModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"gid"}];
}
@end
@implementation GroupListModel

@end

@implementation ProjListModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"pid"}];
}
@end
@implementation ProjListModelII
+(JSONKeyMapper *)keyMapper
{
return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"pid"}];
}
@end
@implementation ProjStatusModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"pid"}];
}
@end
@implementation FoucsInfoModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"foucsId"}];
}

@end
@implementation FoucsModel

@end
@implementation MessageCountModel

@end
@implementation CommodityModel

@end
