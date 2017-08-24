//
//  PhotoPreView.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoViewer.h"

typedef NS_ENUM(int, PhotoPreViewItemType) {
    PhotoPreViewItemTypeWeb   = 0,
    PhotoPreViewItemTypeLocal = 1,
    PhotoPreViewItemTypeAlbum = 2,
    PhotoPreViewItemTypeShare = 3,
};

@interface PhotoPreView : PhotoViewer
@property (nonatomic, assign) BOOL dontSave;
@property (nonatomic, assign) PhotoPreViewItemType itemType;
@end

