//
//  PhotoAlbumList.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QYPhotoAlbum.h"
typedef void (^PhotoAlbumBlock)(NSMutableArray *list);
typedef void (^PhotoAlbumListSelectedBlock)(ALAssetsGroup *grp);

@interface PhotoAlbumList : BaseViewController
{
    PhotoAlbumListSelectedBlock groupBlock;
}

//@property (nonatomic, retain) NSArray *arrGroups;

//- (void)showList:(NSArray*)list block:(PhotoAlbumListSelectedBlock)block;

- (void)selectType:(QYPhotoAlbumType)propertyType maxNum:(NSInteger)maxNum selected:(NSMutableArray*)list block:(PhotoAlbumBlock)block failure:(void(^)(NSError *error))failure;

- (void)close;
@end
