//
//  PhotoViewerCell.m
//  CloudBox
//
//  Created by Qingyang on 15/12/15.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "PhotoViewerCell.h"


@interface PhotoViewerCell()
<UIScrollViewDelegate,ScrollTouchesDelegate>
{
    
    //    UIButton *btn;
    
}
@end

@implementation PhotoViewerCell
+ (CGSize)getCellSize:(id)data{
    CGSize sz = [UIScreen mainScreen].bounds.size;
    
    return sz;
}



- (void)UIGlobal{
    [super UIGlobal];
}

- (void)setCell:(id)data{
    self.photo=data;
    
    self.scroll.minimumZoomScale = 1;
    self.scroll.maximumZoomScale = 2;
    self.scroll.zoomScale = 1;
    
    if (self.imgPhoto==nil) {
        self.imgPhoto = [[UIImageView alloc]init];
    }
    if (self.photo==nil) {
        [self.imgPhoto setImage:nil];
        return;
    }
    
    [self.imgPhoto setImage:self.photo];
    
    CGSize sz=[self originSize:self.photo.size fitInSize:[UIScreen mainScreen].bounds.size];
    //    DLog(@"%@->%@: %@->%@",NSStringFromCGSize([UIScreen mainScreen].bounds.size),NSStringFromCGSize(scroll.frame.size),NSStringFromCGSize(photo.size),NSStringFromCGSize(sz));
    
    CGRect frm = [UIScreen mainScreen].bounds;
    frm.origin.x=(frm.size.width-sz.width)/2;
    frm.origin.y=(frm.size.height-sz.height)/2;
    frm.size=sz;
    self.imgPhoto.frame=frm;
    //    self.imgPhoto.alpha=0.25;
    [self.scroll addSubview:self.imgPhoto];
    
    self.scroll.delegateTouch=self;
}


#pragma mark CGSize适配大小
- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize{
    if (oSize.height<=0 || oSize.width<=0) {
        return fSize;
    }
    
    float os=oSize.width/oSize.height;
    float fs=fSize.width/fSize.height;
    
    float ww,hh;
    if (os>fs) {
        ww=fSize.width;
        hh=oSize.height*fSize.width/oSize.width;
    }
    else {
        ww=oSize.width*fSize.height/oSize.height;
        hh=fSize.height;
    }
    
    
    //约等于floor()，ceil()四舍五入
    if (floor(os*100) / 100 == floor(fs*100) / 100 ) {
        //        DLog(@"%f %f",oSize.width/oSize.height,fSize.width/fSize.height);
        ww=fSize.width;
        hh=fSize.height;
        
    }
    
    return CGSizeMake(ww, hh);
}


#pragma mark - UIScrollViewDelegate
//返回需要缩放对象
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgPhoto;
}

//缩放时保持居中
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    
    [self.imgPhoto setCenter:CGPointMake(xcenter, ycenter)];
}


-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(id)scrollView{
    if ([self.delegate respondsToSelector:@selector(PhotoViewerDelegate:)]) {
        [self.delegate PhotoViewerDelegate:self];
    }
}

@end


@implementation PhotoPreViewCell
- (void)setCell:(id)data{
//    self.photo=data;
    self.contentView.backgroundColor=RGBHex(kColorB);
    self.scroll.backgroundColor=RGBAHex(kColorB, 0);
    
    self.scroll.minimumZoomScale = 1;
    self.scroll.maximumZoomScale = 2;
    self.scroll.zoomScale = 1;
    
    if (self.imgPhoto==nil) {
        self.imgPhoto = [[UIImageView alloc]init];
    }
    self.imgPhoto.image = nil;
    
    if (data==nil) {
        [self.imgPhoto setImage:[UIImage imageNamed:@"bg_no_img"] ];
        [self resize];
        return;
    }
    else if([data isKindOfClass:[UIImage class]]){
        self.photo=data;
        [self.imgPhoto setImage:data];
        [self resize];
    }
//    else if([data isKindOfClass:[FileDownloadModel class]]){
//        FileDownloadModel*mm=data;
//        DLog(@">>>下载完成:%@",mm.name);
//    }
//    else if([data isKindOfClass:[FileUploadModel class]]){
//        FileUploadModel*mm=data;
//        DLog(@">>>上传完成:%@",mm.name);
//    }
    else if([data isKindOfClass:[UserItemModel class]]){
        UserItemModel *mm=data;
        NSString *url=nil;
        if ([mm isKindOfClass:[ShareModel class]]) {
            ShareModel *shareModel = data;
            url=[QGLOBAL imageShareURLWithPath:shareModel.path who:shareModel.owner whoID:shareModel.shareId];
        }else{
            url=[QGLOBAL imageURLWithPath:mm.path];
            
        }

        if (act==nil) {
            act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            act.center = CGPointMake(APP_W/2, APP_H/2);
        }
        __block UIActivityIndicatorView *actSelf=act;//self.contentView.center;

        actSelf.alpha=1;
        [act startAnimating];
        [self.contentView addSubview:act];
        
        __weak typeof (self) weakSelf = self;
        
        [self.imgPhoto setImageAuthURL:url placeholderImage:[UIImage imageNamed:@"bg_no_img"] tag:mm.datetime refresh:NO progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

            if (weakSelf) {
                [weakSelf resize];
            }
            
            [UIView animateWithDuration:.25 animations:^{
                actSelf.alpha=0;
            } completion:^(BOOL finished) {
                [actSelf removeFromSuperview];
            }];
        }];
    }
    
//
    
    
}

- (void)resize{
    CGSize sz=[self originSize:self.imgPhoto.image.size fitInSize:[UIScreen mainScreen].bounds.size];
    
    
    CGRect frm = [UIScreen mainScreen].bounds;
    frm.origin.x=(frm.size.width-sz.width)/2;
    frm.origin.y=(frm.size.height-sz.height)/2;
    frm.size=sz;
    self.imgPhoto.frame=frm;
    
    [self.scroll addSubview:self.imgPhoto];
    
    self.scroll.delegateTouch=self;
}


@end