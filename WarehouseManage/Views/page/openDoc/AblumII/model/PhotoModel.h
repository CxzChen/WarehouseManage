//
//  PhotoModel.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "BaseModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
typedef NS_ENUM(int, PhotoModelType) {
    PhotoModelTypeUnknow     = 0,
    PhotoModelTypePhoto = 1,
    PhotoModelTypeVideo = 2,
};

@interface PhotoModel : BaseModel

@property (assign) NSInteger photoMinSize;
@property (assign) BOOL fullEnabled;
@property (nonatomic,retain) NSString *url;//图片唯一id
@property (nonatomic,retain) UIImage *thumbnail;
@property (nonatomic,retain) UIImage *fullImage;
@property (nonatomic,retain) ALAsset *asset;//可根据这个获取图片各种信息
@property (assign) NSInteger sort;
@property (assign) NSInteger type;
@property (nonatomic,retain) NSString *oid;//上传id
@end
