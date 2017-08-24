//
//  PhotoPreView.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoPreView.h"
#import "PhotoViewerCell.h"
#import "CloudFileManager.h"
#import "UserAPI.h"
#import "shareView.h"
#import "ShareAPI.h"
#import "searchUserVC.h"
#import "PwdView.h"
#import "UMSocial.h"
#import "ThirdShareView.h"
#import "ThirdShare.h"
@interface PhotoPreView ()
{
    IBOutlet UIButton *fenBtn;
    IBOutlet UIButton *downBtn;
    IBOutlet UIButton *deleteBtn;
    IBOutlet UILabel *nameLab;
    IBOutlet NSLayoutConstraint *fenBtnLeft;
    
    IBOutlet NSLayoutConstraint *downLeft;
    IBOutlet NSLayoutConstraint *deleBtnRight;
}
@end

@implementation PhotoPreView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fenBtnLeft.constant = APP_W / 320.0 * 50.0;
    deleBtnRight.constant = fenBtnLeft.constant;
    downLeft.constant = (APP_W - 96 - fenBtnLeft.constant - deleBtnRight.constant) / 2;
    [fenBtn setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [fenBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [downBtn setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteBtn setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.itemType==PhotoPreViewItemTypeLocal||self.itemType==PhotoPreViewItemTypeAlbum|| self.itemType==PhotoPreViewItemTypeShare){
        vBottom.alpha=0;
    }
}
- (void)dataInit{
    [self show:self.indexSelected];
}
- (void)UIGlobal{
    [super UIGlobal];
    
}
#pragma mark - action
- (IBAction)downloadAction:(id)sender{
    id obj=[self curPhotoData];
    if (obj && [obj isKindOfClass:[UserItemModel class]]) {
        [CLOUD_FILE downloadList:@[obj]];
        

        [QGLOBAL loadWifiCheck:self isDownload:NO];
        
//        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已添加至传输列表" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //    [self addSubview:alt];
//        [alt show];
    }
    
    
}

- (IBAction)deleteAction:(id)sender{
    id obj=[self curPhotoData];
    
    if (obj && [obj isKindOfClass:[UserItemModel class]]) {
        UserItemModel *model=obj;
//        DLog(@"deleteAction %@",mm);
        NSString *str=@"确定删除吗？";;
        if (model.type.integerValue==CloudItemTypeFolder) {
            str=@"确定删除文件夹吗？";
        }
        if (model.type.integerValue==CloudItemTypeFile) {
            str=@"确定删除文件吗？";
        }
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (StrIsEmpty(model.path)) {
                return ;
            }
//            DLog(@"确定删除 %@",model);
//            return;
            
            NSArray *arr=@[model];
            [self showLoading];
            [UserAPI userDeletePath:arr isFolder:model.type.integerValue success:^(id responseObj) {
                
                [self didLoad];
                [self showText:@"删除成功!"];
              
                NSInteger index=[self.arrPhotos indexOfObject:model];
                if (index != NSNotFound) {
                    [self.arrPhotos removeObject:model];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    
                    [self.collectMain deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    
                    if (self.delegate  && [self.delegate respondsToSelector:@selector(cloudBaseCellDelegate:deleteModel:)]) {
                        [self.delegate cloudBaseCellDelegate:self deleteModel:model];
                    }
                    
                    if (self.arrPhotos.count==0) {
                        [self popVCAction:nil];
                    }
                }
                
                
                
                
                
            } failure:^(NetError *error) {
                [self didLoad];
                [self showText:[NSString stringWithFormat:@"%@",error.errMessage]];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:can];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
//    if ([self.delegate respondsToSelector:@selector(cloudBaseCellDelegate:deleteModel:)]) {
//        [self.delegate cloudBaseCellDelegate:self deleteModel:self.modItem];
//    }
    
}

- (IBAction)shareAction:(id)sender{
    id obj=[self curPhotoData];
    UserItemModel *model=nil;
    if (obj && [obj isKindOfClass:[UserItemModel class]]) {
        model=obj;
    }
    if (model==nil) {
        return;
    }
    
    shareView *cn=[shareView instanceWithBlock:^(ShareEnumType obj) {
        [MobClick event:cb_add_show];
        //        DLog(@"添加：%@",obj);
        switch (obj) {
            case CreateEnumTypepublic:
            {
                [self showLoading];
                [ShareAPI SharePublicPath:model.path success:^(ShareModel* mm) {
                    [self didLoad];
                    [[ThirdShare sharedInstance] ThirdShareView:mm.link name:model.name nav:self.navigationController title:kShareFileTitle btnCopy:YES];
                    
                } failure:^(NetError *err) {
                    [self showText:@"复制链接失败"];
                    DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                }];
                
                break;
            }
            case CreateEnumTypeprivate:
            {
                [self showLoading];
                PwdView *cn=[PwdView instanceWithBlock:^(NSString *pwd) {
                    [ShareAPI SharePrivatePath:model.path password:pwd success:^(ShareModel* mm) {
                        [self didLoad];
                        [[ThirdShare sharedInstance] ThirdShareView:mm.link name:model.name nav:self.navigationController title:kShareFileTitle btnCopy:YES];
                    } failure:^(NetError *err) {
                        [self showText:@"复制链接失败"];
                        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                    }];
                }];
//                cn.delegate = self;
                [cn show];
                
                break;
            }
            case CreateEnumTypeUser:
            {
                //分享用户
                DLog(@"to user:%@",model.path);
                searchUserVC *vc=[[searchUserVC alloc]initWithNibName:@"searchUserVC" bundle:nil];
                vc.backButtonEnabled=YES;
                vc.usersBlock=^(NSMutableArray *list){
                    DLog(@"users:%@",list);
                    
                    [ShareAPI ShareFriendPath:model.path users:list success:^(id model) {
                        [self showText:@"分享成功!"];
                    } failure:^(NetError *err) {
                        [self showText:@"分享失败!"];
                    }];
                    
                };
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                
                [self presentViewController:nav animated:YES completion:^{
                    //
                }];
            }
                break;
            default:
                
                break;
        }
        
    }];
    [cn show];
}

#pragma mark - UICollectionView
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString * CellIdentifier = @"PhotoPreViewCell";
    PhotoPreViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    
    if (row<self.arrPhotos.count) {
        id obj=self.arrPhotos[row];
        if ([obj isKindOfClass:[UIImage class]]) {
            [cell setCell:obj];
        }
        else if([obj isKindOfClass:[FileDownloadModel class]]) {
            FileDownloadModel*mm=obj;

            NSString *loaclUrl=[CloudFileManager getUserFileFullPath:mm.name docName:mm.docPath];;
            
            [cell setCell:[self loadLocalImage:loaclUrl]];
            nameLab.text=mm.name;
            
        }
        else if([obj isKindOfClass:[FileUploadModel class]]) {
            FileUploadModel*mm=obj;

            NSString *assUrl=mm.diskPath;

            [cell setCell:nil];

            [self loadAssetImage:assUrl cell:cell];
            nameLab.text=mm.name;
            
        }
        else if([obj isKindOfClass:[UserItemModel class]]){
            UserItemModel *mm=obj;
            [cell setCell:nil];
            [cell setCell:obj];
            
            nameLab.text=mm.name;
            
            /*
            //预加载
            if (row+1<self.arrPhotos.count) {
                id obj=self.arrPhotos[row+1];
                UserItemModel *mm=obj;
                NSString *url=nil;
                if ([mm isKindOfClass:[ShareModel class]]) {
                    ShareModel *shareModel = obj;
                    url=[QGLOBAL imageShareURLWithPath:shareModel.path who:shareModel.owner whoID:shareModel.shareId];
                }else{
                    url=[QGLOBAL imageURLWithPath:mm.path];
                }
                UIImageView *tmp=[UIImageView new];
                [tmp setImageAuthURL:url placeholderImage:[UIImage imageNamed:@"bg_no_img"] tag:mm.datetime refresh:NO];
                
            }
            if (row - 1 > 0) {
                id obj=self.arrPhotos[row-1];
                UserItemModel *mm=obj;
                NSString *url=nil;
                if ([mm isKindOfClass:[ShareModel class]]) {
                    ShareModel *shareModel = obj;
                    url=[QGLOBAL imageShareURLWithPath:shareModel.path who:shareModel.owner whoID:shareModel.shareId];
                }else{
                    url=[QGLOBAL imageURLWithPath:mm.path];
                }
                UIImageView *tmp=[UIImageView new];
                [tmp setImageAuthURL:url placeholderImage:[UIImage imageNamed:@"bg_no_img"] tag:mm.datetime refresh:NO];
            }
            */
            
        }
        
        /*
         //预加载
         UIImageView *pre=[[UIImageView alloc]init];
         if (row+1<self.arrPhotos.count) {
         id url=self.arrPhotos[row+1];
         if ([url isKindOfClass:[NSString class]]) {
         [pre setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
         }
         }
         if (row - 1 > 0) {
         id url=self.arrPhotos[row-1];
         if ([url isKindOfClass:[NSString class]]) {
         [pre setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
         }
         }
         */
        
        
        return  cell;
        
        
    }
    
    return cell;
}

#pragma mark - load
- (UIImage *)loadLocalImage:(NSString*)diskUrl{
    NSString *key=StrFromObj(diskUrl);
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    
    id obj = [cache objectForKey:key];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        return obj;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:key];
    UIImage *image = [UIImage imageWithData:data];
    if (image) [cache setObject:image forKey:key];
    
    return image;
}
//- collec
- (void)loadAssetImage:(NSString*)assUrl cell:(PhotoPreViewCell *)cell{
    NSString *key=StrFromObj(assUrl);
    
    if (StrIsEmpty(key)) {
        [cell setCell:nil];
        return;
    }
    
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    
    id obj = [cache objectForKey:key];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        [cell setCell:obj];;
    }
    else {
        [ASSETS_Album cleanPhotosQueue];
        [ASSETS_Album getFullImageByURL:key photoBlock:^(UIImage *fullResolutionImage) {
            if (fullResolutionImage) [cache setObject:fullResolutionImage forKey:key];
            [cell setCell:fullResolutionImage];
        } assetBlock:^(ALAsset *asset) {
            if (asset==nil) {
                [cell setCell:nil];
                return;
            }
        } failure:^(NSError *error) {
            [cell setCell:nil];
        }];
    }
    
//    if (index>=self.arrPhotos.count) {
//        return nil;
//    }
//    UIImage *image = [self getThumbnailByObject:self.arrPhotos[index]];
//    if (image) [cache setObject:image forKey:@(index)];
//    
//    return image;
}

//- (void)xxx{
//    if (loadIndex==indexPath.row) {
//        return;
//    }
//    loadIndex=indexPath.row;
//    if (loadIndex>=self.arrPhotos.count) {
//        return;
//    }
//    ALAsset *ass=self.arrPhotos[loadIndex];
//    
//    curPhoto=[self getCacheImage:ass.defaultRepresentation.url.absoluteString];
//    if (curPhoto) {
//        [self cellIndexPath:indexPath loadImage:curPhoto];
//        return;
//    }
//    
//    //    DLog(@"isOpening %i",PhotosAlbum.isOpening);
//    [ASSETS_Album cleanPhotosQueue];
//    [ASSETS_Album getFullImageByAsset:ass photoBlock:^(UIImage *fullResolutionImage) {
//        [self invokeAsyncQueueBlock:^id{
//            curPhoto = fullResolutionImage;
//            //            DLog(@"%@",NSStringFromCGSize(curPhoto.size));
//            if (curPhoto.size.width*curPhoto.size.height>1200*1200) {
//                curPhoto = [self imageByScalingToMinSize:curPhoto];
//            }
//            
//            [self setCacheImage:curPhoto key:ass.defaultRepresentation.url.absoluteString];
//            
//            return curPhoto;
//        } success:^(id obj){
//            [self cellIndexPath:indexPath loadImage:obj];
//        }];
//        
//        
//    } failure:^(NSError *error) {
//        //
//    }];
//}
#pragma mark - 页面滑动
- (void)checkSelected:(NSInteger)row{
    
}
- (void)loadPhotoForCell:(NSIndexPath *)indexPath{
    
}

- (void)isScrolling{
    [super isScrolling];
    
    [self barHidden:YES];
}
#pragma mark 单击屏幕
//- (void)oneTap{
//    [self closeAction:nil];
//}

- (void)saveImage:(UIImage*)photo{
    if (_dontSave) {
        return;
    }
    
    //保存图片操作
//    QWGLOBALMANAGER.saveImage = photo;
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:QWGLOBALMANAGER cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles: nil];
//    [sheet showInView:self.view];
}

@end


