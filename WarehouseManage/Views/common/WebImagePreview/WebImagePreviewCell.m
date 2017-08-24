//
//  WebImagePreviewCell.m
//  Test
//
//  Created by zhchen on 2017/4/27.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "WebImagePreviewCell.h"

@interface WebImagePreviewCell ()<UIScrollViewDelegate>
{
    UIActivityIndicatorView *act;
    ImgModel *mmImage;
    IBOutlet UIButton *btnReload;
    UIView *vBack;
}
@end

@implementation WebImagePreviewCell
+ (CGSize)getCellSize:(id)data{
    CGSize sz = [UIScreen mainScreen].bounds.size;
    
    return sz;
}
- (void)UIGlobal{
    [super UIGlobal];
    [btnReload setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
}
- (void)setCell:(id)data{
    btnReload.hidden=YES;
    
    self.contentView.backgroundColor=RGBHex(kColorB);
    self.scroll.backgroundColor=RGBAHex(kColorB, 0);
    
    self.scroll.minimumZoomScale = 1;
    self.scroll.maximumZoomScale = 3;//支持放大三倍
    self.scroll.zoomScale = 1;
    
    mmImage = data;
    if (self.imgPhoto==nil) {
        
        self.imgPhoto = [[UIImageView alloc]init];
//                self.imgPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mmImage.width.floatValue, mmImage.height.floatValue)];
        
    }
//    self.imgPhoto.frame = CGRectMake(0, 0, mmImage.width.floatValue, mmImage.height.floatValue);
//    [self resize];
    
    self.imgPhoto.userInteractionEnabled = YES;
    // 单击
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.scroll addGestureRecognizer:singleTapGestureRecognizer];
    // 双击
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.scroll addGestureRecognizer:doubleTapGestureRecognizer];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    if (data==nil) {
        [self.imgPhoto setImage:nil];
        [self resize];
        return;
    }
    else if([data isKindOfClass:[UIImage class]]){
        self.photo=data;
        [self.imgPhoto setImage:data];
        [self resize];
    }
    else if([data isKindOfClass:[ImgModel class]]){
        mmImage=data;
        [self loadImage:NO];
        //        DLog(@"%@",[mmImage toDictionary]);
    }
    
}
- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer
{
    DLog(@"%f",self.scroll.zoomScale);
    if (self.scroll.zoomScale<=1) {
        [UIView animateWithDuration:0.2 animations:^{
//            self.scroll.zoomScale = 3;
            CGFloat w = APP_W / self.imgPhoto.size.width;
            CGFloat h = APP_H / self.imgPhoto.size.height;
            CGFloat scale;
            if (w > h) {
                scale = w;
            }else{
                scale = h;
            }
            if (scale == 1) {
                scale = 3;
            }
            self.scroll.zoomScale = scale;
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.scroll.zoomScale = 1;
        }];
    }
    
}
- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(WebImagePreviewCellTapDelegate:)]) {
        [self.delegate WebImagePreviewCellTapDelegate:self];
    }
}
- (void)loadImage:(BOOL)retry{
    btnReload.hidden=YES;
    NSString *url=mmImage.url_preview;
    
    
    if (act==nil) {
        vBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H)];
        vBack.backgroundColor = RGBHex(kColorB);
        [self.contentView addSubview:vBack];
        act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        act.center = CGPointMake(APP_W/2, APP_H/2);
    }
    __block UIActivityIndicatorView *actSelf=act;//
    
    actSelf.alpha=1;
    [act startAnimating];
    [self.contentView addSubview:act];
    [act bringSubviewToFront:vBack];
    SDWebImageOptions op=retry?SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached:SDWebImageRetryFailed|SDWebImageProgressiveDownload;
    __weak typeof (self) weakSelf = self;
    [self.imgPhoto setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] options:op progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {            
            [weakSelf resize];
            [weakSelf loadSuccess:NO];
        }
        else if (weakSelf) {
            
            [weakSelf resize];
            [weakSelf loadSuccess:YES];
            
        }
        [weakSelf vBackHidden];
        
    }];
}
- (void)vBackHidden
{
    [UIView animateWithDuration:.25 animations:^{
        vBack.alpha = 0;
        act.alpha=0;
    } completion:^(BOOL finished) {
        [act removeFromSuperview];
        [vBack removeFromSuperview];
    }];
}
//修改图片显示大小，图片大小不变
- (void)resize{
    CGSize sz=[self originSize:self.imgPhoto.image.size fitInSize:[UIScreen mainScreen].bounds.size];
    
    CGRect frm = [UIScreen mainScreen].bounds;
    frm.origin.x=(frm.size.width-sz.width)/2;
    frm.origin.y=(frm.size.height-sz.height)/2;
    frm.size=sz;
    self.imgPhoto.frame=frm;
    
    [self.scroll addSubview:self.imgPhoto];
}
- (void)loadSuccess:(BOOL)success{
    if (success) {
        btnReload.hidden=YES;
    }else {
        btnReload.center=_imgPhoto.center;
        btnReload.hidden=NO;
    }
    if ([self.delegate respondsToSelector:@selector(WebImagePreviewCellDelegate:success:)]) {
        [self.delegate WebImagePreviewCellDelegate:self success:success];
    }
}
#pragma mark - Action
- (IBAction)reloadAction:(id)sender{
    [self loadImage:YES];
}

#pragma mark - CGSize适配大小
//图片适配相框，过大的等比缩小，过小的不管
- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize{
    oSize.width = oSize.width/2;
    oSize.height = oSize.height/2;

    if (oSize.height<=0 || oSize.width<=0) {
        return fSize;
    }
    if (oSize.height<=fSize.height/2 && oSize.width<=fSize.width/2) {
        return oSize;
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

//图片适配相框，过大的等比缩小，过小的等比放大
- (CGSize)originSize:(CGSize)oSize fitToSize:(CGSize)fSize{
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
    return _imgPhoto;
}

//缩放时保持居中
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    
    [self.imgPhoto setCenter:CGPointMake(xcenter, ycenter)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
