//
//  PhotoAlbum.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoModel.h"
#import "QYPhotoAlbum.h"
#import "PhotoAlbumList.h"


@interface PhotoAlbum : BaseViewController

//@property (nonatomic,assign) NSMutableArray *arrSelected;
//@property (nonatomic,assign) NSInteger maxPhotos;
////@property (nonatomic,assign) NSInteger indexSelected;
//@property (nonatomic,assign) PhotoAlbumBlock photosBlock;
@property (nonatomic,retain) ALAssetsGroup* group;
@property (nonatomic,assign) PhotoModelType type;
- (void)selectPhotos:(NSInteger)maxNum selected:(NSArray*)list block:(PhotoAlbumBlock)block failure:(void(^)(NSError *error))failure;

- (void)close;
- (void)showGroup:(ALAssetsGroup*)grp;


@end
