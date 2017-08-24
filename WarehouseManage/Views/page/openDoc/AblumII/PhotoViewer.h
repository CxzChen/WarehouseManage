//
//  PhotoViewer.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/2.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//
#import "BaseCollectionCell.h"
#import "BaseViewController.h"
#import "PhotoModel.h"
#import "PhotoAlbum.h"
#import "PhotoAlbumList.h"
@protocol PhotoViewerDelegate;
@interface PhotoViewer : BaseViewController
{
    NSCache *cache;
    NSInteger loadIndex,curIndex,lastIndex;
    UIImage *curPhoto;
    IBOutlet UIView *vTop,*vBottom;
}
@property (nonatomic,strong) IBOutlet UICollectionView *collectMain;
@property (nonatomic,assign) NSMutableArray *arrPhotos;
@property (nonatomic,assign) NSMutableArray *arrSelected;
@property (nonatomic,assign) NSInteger maxPhotos;
@property (nonatomic,assign) NSInteger indexSelected;
@property (nonatomic,assign) PhotoAlbumBlock photosBlock;
- (IBAction)closeAction:(id)sender;
#pragma mark init
- (void)dataInit;
- (void)show:(NSInteger)index;
#pragma mark 单击屏幕
- (void)oneTap;
- (void)saveImage:(UIImage*)photo;
- (void)checkSelected:(NSInteger)row;
- (void)loadPhotoForCell:(NSIndexPath *)indexPath;
- (void)barHidden:(BOOL)enabled;
- (void)isScrolling;
- (id)curPhotoData;
@end

//@interface PhotoViewerCell : BaseCollectionCell
//
//@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;
//
//@end;
//
//@protocol PhotoViewerDelegate <NSObject>
//@optional
//- (void)PhotoViewerDelegate:(PhotoViewerCell*)cell;
//@end