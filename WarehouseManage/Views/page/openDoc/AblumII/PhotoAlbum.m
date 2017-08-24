//
//  PhotoAlbum.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbum.h"
#import "PhotoAlbumCell.h"
#import "PhotoAlbumList.h"
#import "PhotoViewer.h"
#import "QYPhotoAlbum.h"

//#import "SJAvatarBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>

static float kMargin = 4.f;
@interface PhotoAlbum ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoAlbumCellDelegate>
{
    IBOutlet UICollectionView *collectMain;
    IBOutlet UIView *vBottom;
    IBOutlet UILabel *lblSelected;
    IBOutlet UIButton *btnPreview,*btnOK;
    IBOutlet UILabel *fileLab;
    IBOutlet UIButton *fileBtn;
    IBOutlet UIButton *upBtn;
    IBOutlet UIView *viewBtn;
    
    PhotoAlbumBlock photosBlock;
    void (^failureBlock)(NSError *error) ;
    
    /////////////////////////////////////
    
    NSArray *arrGroups;
    NSArray *arrPhotos;
    
    NSMutableArray *arrSelected;
    NSMutableArray *arrTemp;
    NSInteger maxPhotos;
    
    float margin;
    
    BOOL isAllSel;
    NSString *topath2;
}
@end

@implementation PhotoAlbum

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_group==nil) {
        [ASSETS_Album getGroupsByPropertyType:QYPhotoAlbumTypeAll resultBlock:^(NSArray *groups) {
            if (groups.count) {
                ALAssetsGroup *grp=groups.firstObject;
                [self showGroup:grp];
            }
        } failure:failureBlock];
    }
    else {
        [self showGroup:_group];
    }
    
    
    [self showNum];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=NO;
//    [self naviLeftBottonImage:[UIImage imageNamed:@"nav_btn_back"] action:@selector(leftAction:)];
//    [self naviLeftBottonImage:[UIImage imageNamed:@"nav_btn_back"] highlighted:[UIImage imageNamed:@"nav_btn_back_sel"] action:@selector(leftAction:)];
    [collectMain reloadData];
    [self showNum];
}



- (void)UIGlobal{
    [super UIGlobal];
    


//    margin=kMargin*AUTOSIZE.autoSizeScale;
    
    collectMain.backgroundColor=[UIColor clearColor];
    [collectMain setContentInset:UIEdgeInsetsMake(kNavibarH, 0, CGRectGetHeight(viewBtn.frame), 0)];
//    collectMain setContentScaleFactor:<#(CGFloat)#>
    
    vBottom.backgroundColor=RGBAHex(kColorW, .8f);

    
    [fileBtn setBackgroundColor:RGBHex(kColorW)];
    fileBtn.layer.borderWidth = 0.5;
    fileBtn.layer.borderColor = RGBAHex(kColorGray208, 0.3).CGColor;
    fileBtn.layer.cornerRadius = kCornerRadius;
    upBtn.layer.borderWidth = 0.5;
    upBtn.layer.borderColor = RGBAHex(kColorGray208, 0.3).CGColor;
    upBtn.layer.cornerRadius = kCornerRadius;
    [upBtn setTitle:@"上传" forState:UIControlStateNormal];
    fileLab.font = fontSystem(kFontS26);
    fileLab.backgroundColor = RGBHex(kColorMain001);
    fileLab.textColor = RGBHex(kColorW);
    fileLab.layer.cornerRadius=fileLab.width/2;

    

//    upBtn.titleLabel.font = fontSystemBold(kFontS28);
    
//    viewBtn.layer.borderWidth = 0.5;
//    viewBtn.layer.borderColor = RGBAHex(kColorGray208, 0.3).CGColor;
    viewBtn.backgroundColor = RGBHex(kColorW);

//    [btnOK setBackgroundColor:RGBHex(kColorW)];
    [btnOK setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    
    NSString *ttl=[self.group valueForProperty:ALAssetsGroupPropertyName];
    [self naviTitle:ttl];
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

- (void)invokeAsyncQueueBlock:(void(^)())block
                      success:(void(^)())success
{
    dispatch_queue_t aQueue = dispatch_queue_create("QPhotoViewer", NULL);
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
#pragma mark - init
- (void)showGroup:(ALAssetsGroup*)grp{
    self.title=[grp valueForProperty:ALAssetsGroupPropertyName];
    [ASSETS_Album getAssetsByGroup:grp propertyType:QYPhotoAlbumTypeAll resultBlock:^(NSArray *arrAssets) {
        arrPhotos=arrAssets;
        
        [collectMain reloadData];
        if (arrPhotos.count){

//            DLog(@"showGroup：%lu %@",(unsigned long)arrPhotos.count,NSStringFromCGSize(collectMain.contentSize));
//            [collectMain scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:arrPhotos.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [self removeInfoView];
            [self performSelector:@selector(scrollToButtom) withObject:nil afterDelay:0.01];
        }
        else {
            //没有照片
            [self showInfoView:@"相册为空" image:nil];
        }
    }];

}

- (void)scrollToButtom{
//    DLog(@"showGroup：%lu %@",(unsigned long)arrPhotos.count,NSStringFromCGSize(collectMain.contentSize));
    [collectMain scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:arrPhotos.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

//#pragma mark -----
//+ (void)storyBoradAutoLay:(UIView *)allView
//{
//    for (UIView *temp in allView.subviews) {
//        temp.frame = RectMake(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
//        for (UIView *temp1 in temp.subviews) {
//            temp1.frame = RectMake(temp1.frame.origin.x, temp1.frame.origin.y, temp1.frame.size.width, temp1.frame.size.height);
//        }
//    }
//}
//#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
//#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试
////修改CGRectMake
//CG_INLINE CGRect RectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
//{
//    float autoSizeScaleX;
//    float autoSizeScaleY;
//    if(ScreenHeight > 480){
//        autoSizeScaleX = ScreenWidth/320;
//        autoSizeScaleY = ScreenHeight/568;
//    }else{
//        autoSizeScaleX = 1.0;
//        autoSizeScaleY = 1.0;
//    }
//    
//    CGRect rect;
//    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleY;
//    rect.size.width = width * autoSizeScaleX; rect.size.height = height * autoSizeScaleY;
//    return rect;
//}
//
//CG_INLINE CGSize SizeMake(CGFloat width, CGFloat height)
//{
//    float autoSizeScaleX;
//    float autoSizeScaleY;
//    if(ScreenHeight > 480){
//        autoSizeScaleX = ScreenWidth/320;
//        autoSizeScaleY = ScreenHeight/568;
//    }else{
//        autoSizeScaleX = 1.0;
//        autoSizeScaleY = 1.0;
//    }
//    
//    CGRect rect;
//    
//    rect.size.width = width * autoSizeScaleX;
//    rect.size.height = height * autoSizeScaleY;
//    return rect.size;
//}
#pragma mark - fct
- (void)selectPhotos:(NSInteger)maxNum selected:(NSMutableArray*)list block:(PhotoAlbumBlock)block failure:(void(^)(NSError *error))failure{
    failureBlock=failure;
    
    photosBlock=block;
    maxPhotos=maxNum;
    
    arrSelected=list;
    if (arrSelected==nil)
        arrSelected=[[NSMutableArray alloc]initWithArray:list];
    
    
    [self showNum];
}

- (void)showNum{
//    DLog(@"+++ %li",arrSelected.count);
    NSString *ss=[NSString stringWithFormat:@"%lu",(unsigned long)arrSelected.count];
    fileLab.text=ss;
//    [btnOK setTitle:str forState:UIControlStateNormal];
    
    if (arrSelected.count>0) {
        btnPreview.enabled=YES;
        btnOK.enabled=YES;
    }
    else {
        btnPreview.enabled=NO;
        btnOK.enabled=NO;
    }
    
    if (arrSelected.count > 0) {
        [upBtn setBackgroundColor:RGBHex(kColorMain001)];
        [upBtn setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
    }
    else {
        [upBtn setBackgroundColor:RGBHex(kColorW)];
        [upBtn setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    }
}

- (void)clean{
    arrGroups=nil;
    arrPhotos=nil;
    
    //    [arrSelected removeAllObjects];
    //    arrSelected=nil;
}

- (void)close{
    [self closeAction:nil];
}

- (void)allSelected:(BOOL)selected{
    if (selected) {
        for (ALAsset *ass in arrPhotos) {
            PhotoModel *mode=[PhotoModel new];
            
//            mode.thumbnail=[UIImage imageWithCGImage:ass.thumbnail];
            mode.url=ass.defaultRepresentation.url.absoluteString;
            mode.asset=ass;
            mode.type=self.type;
            [arrSelected addObject:mode];
        }
    }
    else {
        [arrSelected removeAllObjects];
    }
    
    
    
    [self showNum];
}
#pragma mark - action

- (IBAction)closeAction:(id)sender{
    if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [ASSETS_Album clean];
            [self clean];
        }];
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [ASSETS_Album clean];
            [self clean];
        }];
    }
    
}

- (IBAction)leftAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
//    PhotoAlbumList* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbumList"];
//    
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:.3];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromLeft];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
//    [self.navigationController pushViewController:vc animated:NO];
//    
//    [vc showList:arrGroups block:^(ALAssetsGroup *grp) {
//        
//        [self showGroup:grp];
//    }];
}

- (IBAction)previewAction:(id)sender{
    if (arrSelected.count==0) {
        return;
    }
    arrTemp=nil;
    arrTemp=[[NSMutableArray alloc]initWithCapacity:maxPhotos];
    for (PhotoModel *mode in arrSelected) {
        [arrTemp addObject:mode.asset];
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoViewer* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoViewer"];
    vc.arrPhotos = arrTemp;
    vc.arrSelected= arrSelected;
    vc.maxPhotos=maxPhotos;
    vc.indexSelected = 0;
    vc.photosBlock=photosBlock;

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)OKAction:(id)sender{
    //现在不能选文件夹，先默认当前
    if (arrSelected.count==0) {
        return;
    }
    

    QGLOBAL.uploadPath=topath2;
//    DLog(@"%@",topath2);

//    [self showLoading];
    
    QGLOBAL.uploadPath=QGLOBAL.curPath;

    [self closeAction:nil];
    if (photosBlock) {
        photosBlock(arrSelected);
    }
    /*
    dispatch_queue_t dispatchQueue = dispatch_queue_create("PhotoViewer.queue.next", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (PhotoModel *mode in arrSelected) {
        if (mode.fullImage==nil && mode.asset) {
            dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
                mode.fullImage=[ASSETS_Album getFullImageByAsset:mode.asset];
            });
        }
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self closeAction:nil];
        if (photosBlock) {
            photosBlock(arrSelected);
        }
    });
    */
    
}





#pragma mark --UICollectionView
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrPhotos.count;
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
    static NSString * CellIdentifier = @"kPhotoAlbumCell";
    PhotoAlbumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate=self;
    if (row<arrPhotos.count) {
        ALAsset *ass=[arrPhotos objectAtIndex:row];
        cell.imgPhoto.image=[UIImage imageWithCGImage:ass.thumbnail];
        cell.url=[ass.defaultRepresentation.url absoluteString];
        cell.index=row;
        cell.btnSelect.selected=NO;
        for (PhotoModel *mode in arrSelected) {
            if ([mode.url isEqualToString:cell.url]) {
                cell.btnSelect.selected=YES;
                break;
            }
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    float ww=
    return AutoSize(88, 88);
//    [AutoSize getSize:CGSizeMake(101, 101)];
//    return CGSizeMake(101*AUTOSIZE.autoSizeScale, 101*AUTOSIZE.autoSizeScale);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float ss=AutoValue(kMargin);//kMargin*AUTOSIZE.autoSizeScale;
    return UIEdgeInsetsMake(ss, ss, ss, ss);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return AutoValue(kMargin);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return kMargin*AUTOSIZE.autoSizeScaleX;
//}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //PhotoViewer
    NSInteger row=indexPath.row;
    
    if (row<arrPhotos.count) {
        
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
//        PhotoViewer* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoViewer"];
//        vc.arrPhotos = arrPhotos;
//        vc.arrSelected= arrSelected;
//        vc.maxPhotos=maxPhotos;
//        vc.indexSelected = row;
//        vc.photosBlock=photosBlock;
//
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - PhotoAlbumCellDelegate
- (void)PhotoAlbumCellDelegate:(PhotoAlbumCell*)cell{
    
    if (!cell.btnSelect.selected && arrSelected.count==maxPhotos ) {
        NSString *ss=[NSString stringWithFormat:@"最多选择%li张",maxPhotos];
        [self showText:ss];
        return;
    }
    if (cell.btnSelect.selected) {
        
        cell.btnSelect.selected=false;
//        [upBtn setBackgroundColor:RGBHex(kColorW)];
//        [upBtn setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
//        cell.im.image = [UIImage imageNamed:@"duox"];
        BOOL canMove=false;
        int i = 0;
        for (PhotoModel *mode in arrSelected) {
            if ([mode.url isEqualToString:cell.url]) {
                canMove=YES;
                break;
            }
            i++;
        }
        if (canMove) {
            [arrSelected removeObjectAtIndex:i];
        }
    }
    else {
        cell.btnSelect.selected=YES;
        
        
//        cell.im.image = [UIImage imageNamed:@"duoxxz"];
        PhotoModel *mode=[PhotoModel new];
        
        mode.thumbnail=cell.imgPhoto.image;
        mode.url=cell.url;
        mode.type=self.type;
        
        if (cell.index<arrPhotos.count) {
            ALAsset *ass=[arrPhotos objectAtIndex:cell.index];
            mode.asset=ass;
            
        }
        [arrSelected addObject:mode];
    }
    
    [self showNum];
}




@end
