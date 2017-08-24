//
//  UserModel.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"
@interface AuthModel : BaseModel
//@property (nonatomic,retain) NSString<Optional> *access_id;//auth_username
//@property (nonatomic,retain) NSString<Optional> *access_token;//auth_token
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString<Optional> *loginID;
@property (nonatomic,retain) NSString<Optional> *isnewpwd;
@property (nonatomic,retain) NSString<Optional> *email;
@property (nonatomic,retain) NSString<Optional> *logined;
@property (nonatomic,retain) NSString<Optional> *mobile;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *password;
@property (nonatomic,retain) NSString<Optional> *status;
@property (nonatomic,retain) NSString<Optional> *uid;
@property (nonatomic,retain) NSString<Optional> *authid;
@property (nonatomic,retain) NSString<Optional> *vso_token;
@property (nonatomic,retain) NSString<Optional> *avatar;
@property (nonatomic,retain) NSString<Optional> *choose_role_source;
@end
@interface UserModel : BasePrivateModel
@property (nonatomic,retain) NSString<Optional> *uid;
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *sex;
@property (nonatomic,retain) NSString<Optional> *truename;
@property (nonatomic,retain) NSString<Optional> *indus_pid;
@property (nonatomic,retain) NSString<Optional> *indus_name;
@property (nonatomic,retain) NSString<Optional> *avatar;
@property (nonatomic,retain) NSString<Optional> *lable;
@property (nonatomic,retain) NSString<Optional> *mobile;
@property (nonatomic,retain) NSString<Optional> *email;
@property (nonatomic,retain) NSString<Optional> *group_id;
@property (nonatomic,retain) NSString<Optional> *group_name;
@property (nonatomic,retain) NSDictionary<Optional> *auth_realname_record;
@property (nonatomic,retain) NSDictionary<Optional> *auth_enterprise_record;
@property (nonatomic,retain) NSString<Optional> *brief;
@end
@interface PersonalInfoModel : BaseModel

@end

@interface GuideModel : BaseModel
@property(nonatomic,copy)NSString *version;
@property(nonatomic,assign)BOOL firstOpen;

@end

@interface RealNameModelDB : BasePrivateModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *id_card;
@property (nonatomic,retain) NSString<Optional> *id_pic;
@property (nonatomic,retain) NSString<Optional> *id_pic_2;
@property (nonatomic,retain) NSString<Optional> *id_pic_3;
@property (nonatomic,retain) NSString<Optional> *realname;
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *start_time;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *validity_s_time;
@property (nonatomic,retain) NSString<Optional> *validity_e_time;
@property (nonatomic,retain) NSString<Optional> *s_time;
@property (nonatomic,retain) NSString<Optional> *e_time;
@property (nonatomic,retain) NSString<Optional> *authH;
@property (nonatomic,retain) NSNumber<Optional> *isEdit;
@end

@interface RealNameModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *id_card;
@property (nonatomic,retain) NSString<Optional> *id_pic;
@property (nonatomic,retain) NSString<Optional> *id_pic_2;
@property (nonatomic,retain) NSString<Optional> *id_pic_3;
@property (nonatomic,retain) NSString<Optional> *realname;
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *start_time;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *validity_s_time;
@property (nonatomic,retain) NSString<Optional> *validity_e_time;
@property (nonatomic,retain) NSString<Optional> *nopass_des;
@end
@interface CompanyAuthModelDB : BasePrivateModel
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *company;
@property (nonatomic,retain) NSString<Optional> *legal;
@property (nonatomic,retain) NSString<Optional> *licen_num;
@property (nonatomic,retain) NSString<Optional> *licen_pic;
@property (nonatomic,retain) NSString<Optional> *turnover;
@property (nonatomic,retain) NSString<Optional> *area_prov;
@property (nonatomic,retain) NSString<Optional> *area_city;
@property (nonatomic,retain) NSString<Optional> *area_dist;
@property (nonatomic,retain) NSString<Optional> *ent_start_time;
@property (nonatomic,retain) NSString<Optional> *ent_end_time;
@property (nonatomic,retain) NSString<Optional> *address;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *authH;
@property (nonatomic,retain) NSString<Optional> *s_time;
@property (nonatomic,retain) NSString<Optional> *e_time;
@property (nonatomic,retain) NSNumber<Optional> *isEdit;
@end
@interface CompanyAuthModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *company;
@property (nonatomic,retain) NSString<Optional> *legal;
@property (nonatomic,retain) NSString<Optional> *legal_id_card;
@property (nonatomic,retain) NSString<Optional> *licen_num;
@property (nonatomic,retain) NSString<Optional> *licen_pic;
@property (nonatomic,retain) NSString<Optional> *turnover;
@property (nonatomic,retain) NSString<Optional> *telephone;
@property (nonatomic,retain) NSString<Optional> *area_prov;
@property (nonatomic,retain) NSString<Optional> *area_city;
@property (nonatomic,retain) NSString<Optional> *area_dist;
@property (nonatomic,retain) NSString<Optional> *ent_start_time;
@property (nonatomic,retain) NSString<Optional> *ent_end_time;
@property (nonatomic,retain) NSString<Optional> *residency;
@property (nonatomic,retain) NSString<Optional> *indus_pid;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *licen_address;
@end

@interface AuthCountyModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *s;
@property (nonatomic,retain) NSNumber<Optional> *isEx;
@end
@protocol AuthCountyModel <NSObject>

@end
@interface AuthCityModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *n;
@property (nonatomic,retain) NSMutableArray<AuthCountyModel,Optional> *a;
@property (nonatomic,retain) NSNumber<Optional> *isEx;
@end
@protocol AuthCityModel <NSObject>

@end
@interface AuthAreaListModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *p;
@property (nonatomic,retain) NSMutableArray<AuthCityModel,Optional> *c;
@property (nonatomic,retain) NSNumber<Optional> *isEx;
@end

@interface GroupModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *gid;
@property (nonatomic,retain) NSString<Optional> *circle_name;
@property (nonatomic,retain) NSString<Optional> *circle_desc;
@property (nonatomic,retain) NSString<Optional> *circle_admin;
@property (nonatomic,retain) NSString<Optional> *circle_icon;
@property (nonatomic,retain) NSString<Optional> *is_recommend;
@property (nonatomic,retain) NSString<Optional> *created_at;
@property (nonatomic,retain) NSString<Optional> *updated_at;
@property (nonatomic,retain) NSNumber<Optional> *isSel;
@end
@protocol GroupModel <NSObject>

@end
@interface GroupListModel : BaseModel
@property (nonatomic,retain) NSMutableArray<Optional,GroupModel> *circles;
@property (nonatomic,retain) NSString<Optional> *total;
@end


@interface ProjListModelII : BaseModel
@property (nonatomic,retain) NSString<Optional> *pid;
@property (nonatomic,retain) NSString<Optional> *name;
@property (nonatomic,retain) NSString<Optional> *parent_id;
@end

@protocol ProjListModelII <NSObject>

@end


@interface ProjListModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *pid;
@property (nonatomic,retain) NSString<Optional> *name;
@property (nonatomic,retain) NSNumber<Optional> *isSel;
@property (nonatomic,retain) NSArray<Optional,ProjListModelII> *children;
@end
@interface ProjStatusModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *pid;
@property (nonatomic,retain) NSString<Optional> *name;
@end

@interface FoucsInfoModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *created_at;
@property (nonatomic,retain) NSString<Optional> *foucsId;
@property (nonatomic,retain) NSString<Optional> *subscriber;
@property (nonatomic,retain) NSString<Optional> *updated_at;
@end

@protocol FoucsInfoModel <NSObject>

@end
@interface FoucsModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *message;
@property (nonatomic,retain) NSString<Optional> *result;
@property (nonatomic,retain) FoucsInfoModel<Optional> *data;
@end

@interface MessageCountModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *type;
@property (nonatomic,retain) NSString<Optional> *count;
@end

@interface CommodityModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *name;
@property (nonatomic,retain) NSString<Optional> *odlNum;
@property (nonatomic,retain) NSString<Optional> *lastNum;
@property (nonatomic,retain) NSString<Optional> *shipNum;
@property (nonatomic,retain) NSString<Optional> *wareNum;
@property (nonatomic,retain) NSString<Optional> *returnNum;
@property (nonatomic,retain) NSArray<Optional> *size;
@end
