//
//  PhotoViewer.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/2.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoViewer.h"
#import "QYPhotoAlbum.h"
//#import "UIImageView+WebCache.h"
#import "PhotoViewerCell.h"
//#import "ScrollTouch.h"
//#import "PhotoZoomScroll.h"
//#import "UIScrollView+EX.h"
//static float kMargin = 30.f;


@interface PhotoViewer()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoViewerDelegate>
{
    BOOL barHide;
    
    
    IBOutlet UIButton *btnSelect,*btnOK;
    
    IBOutlet UILabel *lblSelected;
    
//    NSIndexPath *curIndexPath;
    BOOL enabledBtn;
    dispatch_queue_t queueOpenPhoto;
    
}

@end

@implementation PhotoViewer
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    
//    [self invokeAsyncVoidBlock:^{
//        [self show:_indexSelected];
//    } success:^{
//        //
//    }];
    
}
- (void)dataInit{
    queueOpenPhoto=dispatch_queue_create("QPhotoViewer", NULL);
    
    loadIndex=-1;
    curIndex=-1;
    lastIndex=-1;
    enabledBtn=YES;
    
    [self showNum];
    [self show:_indexSelected];
}

- (void)UIGlobal{
    [super UIGlobal];
    barHide = YES;
    [self barHidden:barHide];
    self.navigationController.navigationBarHidden=YES;
    
    CGRect frm=self.view.bounds;
    self.collectMain.frame=frm;
    

    
    self.collectMain.pagingEnabled=YES;
    self.collectMain.backgroundColor=RGBHex(kColorB);
    
    [btnOK setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
    [btnOK setTitleColor:RGBHex(kColorW) forState:UIControlStateDisabled];
    
    //在显示状态栏时，防止内部控件抖动
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DLog(@"!!!!!!!!!!!!!!! didReceiveMemoryWarning !!!!!!!!!!!!!!!!!!");
//    cache.totalCostLimit
    [cache removeAllObjects];
}
#pragma mark -
- (void)barStatus{
    barHide=!barHide;
    [self barHidden:barHide];
}

- (void)barHidden:(BOOL)enabled{
    barHide=enabled;
    if (enabled) {
        vTop.hidden=YES;
        vBottom.hidden=YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    else {
        vTop.hidden=NO;
        vBottom.hidden=NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)checkSelected:(NSInteger)row{
    if (curIndex==row) {
        return;
    }
    
    curIndex=row;
    if (curIndex<self.arrPhotos.count) {
        ALAsset *ass=[self.arrPhotos objectAtIndex:curIndex];
        NSString *url=[ass.defaultRepresentation.url absoluteString];
//        cell.imgPhoto.image=[UIImage imageWithCGImage:ass.thumbnail];
//        cell.url=[ass.defaultRepresentation.url absoluteString];
//        cell.index=row;
        btnSelect.selected=NO;
        for (PhotoModel *mode in self.arrSelected) {
            if ([mode.url isEqualToString:url]) {
                btnSelect.selected=YES;
                break;
            }
        }
    }
}

- (void)showNum{
    lblSelected.text=[NSString stringWithFormat:@"完成（%lu）",(unsigned long)_arrSelected.count];
}

- (void)show:(NSInteger)index{
    if (index>=0) {
        lastIndex=index;
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [self.collectMain scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [self checkSelected:index];
        [self loadPhotoForCell:indexPath];
      
    }
    
}

- (void)invokeAsyncVoidBlock:(void(^)())block
                     success:(void(^)())success
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        if (block) {
            block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (success) {
                                   success();
                               }
                           });
        }
    });
}

- (void)invokeAsyncQueueBlock:(id (^)())block
                      success:(void (^)(id obj))success
{
    
    dispatch_async(queueOpenPhoto, ^(void) {
        id retVal = nil;
        if (block) {
            retVal = block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (success) {
                                   success(retVal);
                               }
                           });
        }
    });
}


#pragma mark - action
- (IBAction)OK:(id)sender{
    if (ASSETS_Album.isOpening) {
        DLog(@"正在载入");
        return;
    }
    else {
        DLog(@"可以发送");
        btnOK.enabled=NO;
    }
    
    [self invokeAsyncQueueBlock:^id{
        if (_arrSelected.count==0) {
            //            [_arrSelected addObject:nil];
            if (lastIndex>=0 && lastIndex<self.arrPhotos.count) {
                ALAsset *ass=[self.arrPhotos objectAtIndex:lastIndex];
                NSString *url=[ass.defaultRepresentation.url absoluteString];
                
                PhotoModel *mode=[PhotoModel new];
                mode.thumbnail=[UIImage imageWithCGImage:ass.thumbnail];
                mode.url=url;
                mode.asset=ass;
               
                
                
                [_arrSelected addObject:mode];
            }
        }
        return _arrSelected;
    } success:^(id obj) {
        [self closeAction:nil];
        if (_photosBlock) {
            _photosBlock(_arrSelected);
        }
    }];

}
- (IBAction)closeAction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    
}
- (IBAction)popVCAction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [super popVCAction:sender];
}

- (IBAction)selectAction:(id)sender{
    if (!enabledBtn) {
        return;
    }
    
    if (!btnSelect.selected && _arrSelected.count==_maxPhotos ) {
        [self showError:@"选择上限"];
        return;
    }
    
    if (lastIndex<0||lastIndex>=self.arrPhotos.count) {
        return;
    }
    
    ALAsset *ass=[self.arrPhotos objectAtIndex:lastIndex];
    NSString *url=[ass.defaultRepresentation.url absoluteString];
    
    if (btnSelect.selected) {
        btnSelect.selected=false;
        
        BOOL canMove=false;
        int i = 0;
        for (PhotoModel *mode in _arrSelected) {
            if ([mode.url isEqualToString:url]) {
                canMove=YES;
                break;
            }
            i++;
        }
        if (canMove) {
            [_arrSelected removeObjectAtIndex:i];
        }
    }
    else {
        btnSelect.selected=YES;
        PhotoModel *mode=[PhotoModel new];
        mode.thumbnail=[UIImage imageWithCGImage:ass.thumbnail];
        mode.url=url;
        mode.asset=ass;

        
        
        [_arrSelected addObject:mode];
    }
    
    [self showNum];
    
}
#pragma mark asset
- (id)curPhotoData{
    if (lastIndex>=0 && lastIndex<self.arrPhotos.count) {
        id obj=[self.arrPhotos objectAtIndex:lastIndex];

        return obj;
    }
    else if (self.arrPhotos.count && lastIndex==self.arrPhotos.count){
        lastIndex--;
        return self.arrPhotos.lastObject;
    }
    return nil;
}
#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrPhotos.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString * CellIdentifier = @"kPhotoViewerCell";
    PhotoViewerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate=self;

    if (row<self.arrPhotos.count) {
//        [self checkSelected:row];
        [cell setCell:[self preLoadThumbnail:row]];
        
        //预加载
        if (row+1<self.arrPhotos.count) {
            [self preLoadThumbnail:row+1];
        }
        if (row - 1 > 0) {
            [self preLoadThumbnail:row-1];
        }
        
        return  cell;
        
       
    }
    
    return cell;
}


//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self checkSelected:indexPath.row];
//}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PhotoViewerCell getCellSize:nil];
}

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
//}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 滑动停止,加载


- (void)loadPhotoForCell:(NSIndexPath *)indexPath{
    if (loadIndex==indexPath.row) {
        return;
    }
    
    loadIndex=indexPath.row;
    if (loadIndex>=self.arrPhotos.count) {
        return;
    }
    ALAsset *ass=self.arrPhotos[loadIndex];
    
    curPhoto=[self getCacheImage:ass.defaultRepresentation.url.absoluteString];
    if (curPhoto) {
        [self cellIndexPath:indexPath loadImage:curPhoto];
        return;
    }
    
//    DLog(@"isOpening %i",PhotosAlbum.isOpening);
    [ASSETS_Album cleanPhotosQueue];
    [ASSETS_Album getFullImageByAsset:ass photoBlock:^(UIImage *fullResolutionImage) {
        [self invokeAsyncQueueBlock:^id{
            curPhoto = fullResolutionImage;
//            DLog(@"%@",NSStringFromCGSize(curPhoto.size));
            if (curPhoto.size.width*curPhoto.size.height>1200*1200) {
                curPhoto = [self imageByScalingToMinSize:curPhoto];
            }
            
            [self setCacheImage:curPhoto key:ass.defaultRepresentation.url.absoluteString];
            
            return curPhoto;
        } success:^(id obj){
            [self cellIndexPath:indexPath loadImage:obj];
        }];
        
        
    } failure:^(NSError *error) {
        //
    }];
    
}

- (void)cellIndexPath:(NSIndexPath *)indexPath loadImage:(UIImage*)image{
    PhotoViewerCell *cell = (PhotoViewerCell *)[self.collectMain cellForItemAtIndexPath:indexPath];
    [cell setCell:curPhoto];

}

- (void)scrollDidEnd {
    enabledBtn=YES;
    
    NSArray *visibleCells = [self.collectMain visibleCells];
    for (PhotoViewerCell *cell in visibleCells) {
        NSIndexPath *indexPath = [self.collectMain indexPathForCell:cell];
        
        [self loadPhotoForCell:indexPath];
    }
}

- (void)isScrolling {
    
    
    float mm = CGRectGetWidth(self.collectMain.frame)/2;
    NSArray *visibleCells = [self.collectMain visibleCells];
    for (PhotoViewerCell *cell in visibleCells) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        CGRect frm=[cell convertRect:cell.bounds toView:window];
        NSIndexPath *indexPath = [self.collectMain indexPathForCell:cell];

        if (frm.origin.x <= mm && frm.origin.x >= -mm) {
//            DLog(@"%d:%@",indexPath.row,NSStringFromCGRect(frm));
            [self checkSelected:indexPath.row];
        }
        if (frm.origin.x==0) {
            lastIndex=indexPath.row;
            enabledBtn=YES;
        }
        else enabledBtn=NO;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self scrollDidEnd];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    enabledBtn=YES;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self isScrolling];
}


#pragma mark -  preload
- (UIImage *)loadCellImage:(NSInteger)index{
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    if (index>=self.arrPhotos.count) {
        return nil;
    }
    ALAsset *ass=self.arrPhotos[index];
    UIImage *img=[self getCacheImage:ass.defaultRepresentation.url.absoluteString];
    if (img) {
        return img;
    }
    img=[self preLoadThumbnail:index];
    return img;
}

- (UIImage *)getCacheImage:(NSString*)key{
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    id obj = [cache objectForKey:key];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        return obj;
    }
    return nil;
}

- (void)setCacheImage:(UIImage*)image key:(NSString*)key{
    if (image) [cache setObject:image forKey:key];
}

- (UIImage *)preLoadThumbnail:(NSInteger)index{
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    
    id obj = [cache objectForKey:@(index)];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        return obj;
    }
    
    if (index>=self.arrPhotos.count) {
        return nil;
    }
    UIImage *image = [self getThumbnailByObject:self.arrPhotos[index]];
    if (image) [cache setObject:image forKey:@(index)];
    
    return image;
}

- (BOOL)checkCache:(NSUInteger)index{
    if (cache) {
        id obj = [cache objectForKey:@(index)];
        if (obj && [obj isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - size
- (UIImage *)imageByScalingToMinSize:(UIImage*)img
{
    UIImage *sourceImage = img;
    UIImage *newImage = nil;
    
    if (!sourceImage)
    {
        return nil;
    }
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (MIN(width, height) > 640.0f){
        if (width <= height) {
            height = height*640/width;
            width = 640;
        }else{
            width = width*640/height;
            height = 640;
        }
    }
    
    CGSize targetSize = CGSizeMake(width, height);
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"%s,could not scale image",__func__);
    
    return newImage ;
}

#pragma mark -  get photo
/*
- (void)loadImageByAsset:(ALAsset *)asset block:(void(^)(UIImage *photo))block{
    //    DLog(@"~~~ loadIndex: %d",index);
    [self invokeAsyncQueueBlock:^id{
        curPhoto = [self getImageByObject:asset];
        //        DLog(@"%@",NSStringFromCGSize(img.size));
        if (curPhoto.size.width*curPhoto.size.height>1200*1200) {
            curPhoto = [self imageByScalingToMinSize:curPhoto];
        }
        
        return curPhoto;
    } success:^(id obj) {
        block(obj);
    }];
//    dispatch_queue_t aQueue =dispatch_queue_create("QLocalNotif", NULL);
//
//    dispatch_async(aQueue, ^(void) {
//        if (block) {
//            block();
//            dispatch_async(dispatch_get_main_queue(),
//                           ^{
//                               if (success) {
//                                   success();
//                               }
//                           });
//        }
//    });
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        UIImage *image = [self getImageByObject:asset];
//        //        UIImage *image = [self loadImageAtIndex:index];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (block) {
//                block(image);
//            }
//            
//        });
//    });
}

- (UIImage*)getImageByObject:(ALAsset *)obj{
    ALAsset *ass=obj;
    UIImage *img=[PhotosAlbum getFullImageByAsset:ass];
    
    return img;
}
*/
- (UIImage*)getThumbnailByObject:(ALAsset *)obj{
    ALAsset *ass=obj;
    UIImage *img=[UIImage imageWithCGImage:ass.aspectRatioThumbnail];
    return img;
}

#pragma mark - PhotoViewerDelegate
- (void)PhotoViewerDelegate:(PhotoViewerCell*)cell{
    [self oneTap];
}

- (void)PhotoViewerSaveImage:(UIImage*)photo{
    [self saveImage:photo];
}
#pragma mark 单击屏幕
- (void)oneTap{
    [self barStatus];
}

- (void)saveImage:(UIImage*)photo{
    
}

@end


//@interface PhotoViewerCell()
//<UIScrollViewDelegate,ScrollTouchesDelegate>
//{
//    IBOutlet ScrollTouch *scroll;
//    UIImage *photo;
////    UIButton *btn;
//}
//@end

//@implementation PhotoViewerCell
//+ (CGSize)getCellSize:(id)data{
//    CGSize sz = [UIScreen mainScreen].bounds.size;
//
//    return sz;
//}
//
//
//
//- (void)UIGlobal{
//    [super UIGlobal]; 
//}
//
//- (void)setCell:(id)data{
//    photo=data;
//    
//    scroll.minimumZoomScale = 1;
//    scroll.maximumZoomScale = 2;
//    scroll.zoomScale = 1;
//    
//    if (self.imgPhoto==nil) {
//        self.imgPhoto = [[UIImageView alloc]init];
//    }
//    if (photo==nil) {
//        [self.imgPhoto setImage:nil];
//        return;
//    }
//    
//    [self.imgPhoto setImage:photo];
//
//    CGSize sz=[self originSize:photo.size fitInSize:[UIScreen mainScreen].bounds.size];
////    DLog(@"%@->%@: %@->%@",NSStringFromCGSize([UIScreen mainScreen].bounds.size),NSStringFromCGSize(scroll.frame.size),NSStringFromCGSize(photo.size),NSStringFromCGSize(sz));
//    
//    CGRect frm = [UIScreen mainScreen].bounds;
//    frm.origin.x=(frm.size.width-sz.width)/2;
//    frm.origin.y=(frm.size.height-sz.height)/2;
//    frm.size=sz;
//    self.imgPhoto.frame=frm;
////    self.imgPhoto.alpha=0.25;
//    [scroll addSubview:self.imgPhoto];
//    
//    scroll.delegateTouch=self;
//}
//
//
//#pragma mark CGSize适配大小
//- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize{
//    if (oSize.height<=0 || oSize.width<=0) {
//        return fSize;
//    }
//    
//    float os=oSize.width/oSize.height;
//    float fs=fSize.width/fSize.height;
//    
//    float ww,hh;
//    if (os>fs) {
//        ww=fSize.width;
//        hh=oSize.height*fSize.width/oSize.width;
//    }
//    else {
//        ww=oSize.width*fSize.height/oSize.height;
//        hh=fSize.height;
//    }
//    
//    
//    //约等于floor()，ceil()四舍五入
//    if (floor(os*100) / 100 == floor(fs*100) / 100 ) {
////        DLog(@"%f %f",oSize.width/oSize.height,fSize.width/fSize.height);
//        ww=fSize.width;
//        hh=fSize.height;
//        
//    }
//    
//    return CGSizeMake(ww, hh);
//}
//
//
//#pragma mark - UIScrollViewDelegate
////返回需要缩放对象
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return _imgPhoto;
//}
//
////缩放时保持居中
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
//
//    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?scrollView.contentSize.width/2 : xcenter;
//    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
//    
//    [self.imgPhoto setCenter:CGPointMake(xcenter, ycenter)];
//}
//
//
//-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(id)scrollView{
//    if ([self.delegate respondsToSelector:@selector(PhotoViewerDelegate:)]) {
//        [self.delegate PhotoViewerDelegate:self];
//    }
//}
//
//@end