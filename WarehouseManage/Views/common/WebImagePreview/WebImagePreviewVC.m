//
//  WebImagePreviewVC.m
//  Test
//
//  Created by zhchen on 2017/4/27.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "WebImagePreviewVC.h"
#import "WebImagePreviewCell.h"
#import "PhotoAlbum.h"
//#import "ThirdShare.h"
@interface WebImagePreviewVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WebImagePreviewCellDelegate>
{
    NSInteger loadIndex,curIndex,lastIndex;
    UIImage *imgSave;
    IBOutlet UIButton *btnMenu;
    IBOutlet UIView *vT;
}

@end

@implementation WebImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.naviBar.hidden=YES;
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7 以上
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}
- (void)dataInit{
    loadIndex=-1;
    curIndex=-1;
    lastIndex=-1;
    
    [self show:_indexSelected];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    
    self.view.backgroundColor=RGBHex(kColorB);
    
    CGRect frm=self.view.bounds;
    self.collectMain.frame=frm;
    
    self.collectMain.pagingEnabled=YES;
    self.collectMain.backgroundColor=RGBHex(kColorB);
    
    //在显示状态栏时，防止内部控件抖动
    self.automaticallyAdjustsScrollViewInsets = NO;
    _lblNum.textColor = RGBHex(kColorW);
    
    btnMenu.backgroundColor = RGBAHex(kColorB, 0.2);
    btnMenu.layer.cornerRadius = 2;
    btnMenu.clipsToBounds = YES;
    
    // 渐变色浮层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBAHex(kColorB, 0.2).CGColor, (__bridge id)RGBAHex(kColorB, 0).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, APP_W, 64);
    [self.view.layer addSublayer:gradientLayer];
}

- (void)show:(NSInteger)index{
    if (index>=0 && index<self.arrPhotos.count) {
        lastIndex=index;
        SyncBegin
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [self.collectMain scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [self checkInfos:index];
        [self loadImageForCell:indexPath];
        SyncEnd
    }
    
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
    static NSString * CellID = @"WebImagePreviewCell";
    //    BaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //注册cell
    UINib *cellNib = [UINib nibWithNibName:CellID bundle:[NSBundle mainBundle]];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:CellID];
    
    BaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    
    cell.delegate=self;
    
    if (row<self.arrPhotos.count) {
        id obj=self.arrPhotos[row];
        if ([obj isKindOfClass:[UIImage class]]) {
            [cell setCell:obj];
        }
        else if([obj isKindOfClass:[ImgModel class]]){
            //            ImagesPreviewModel *mm=obj;
//                        [cell setCell:nil];
            [cell setCell:obj];
        }
        
        return  cell;
        
        
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size;
}


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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollDidEnd];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self isScrolling];
}

#pragma mark - self scroll
- (void)scrollDidEnd {
    NSArray *visibleCells = [self.collectMain visibleCells];
    for (WebImagePreviewCell *cell in visibleCells) {
        NSIndexPath *indexPath = [self.collectMain indexPathForCell:cell];
        
        [self loadImageForCell:indexPath];
    }
}

- (void)isScrolling {
    float mm = CGRectGetWidth(self.collectMain.frame)/2;
    NSArray *visibleCells = [self.collectMain visibleCells];
    for (WebImagePreviewCell *cell in visibleCells) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        CGRect frm=[cell convertRect:cell.bounds toView:window];
        NSIndexPath *indexPath = [self.collectMain indexPathForCell:cell];
        
        if (frm.origin.x <= mm && frm.origin.x >= -mm) {
            //滑动状态检查图片对应状态
            if (curIndex!=indexPath.row) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:curIndex inSection:0];
                WebImagePreviewCell *cellImg = (WebImagePreviewCell *)[self.collectMain cellForItemAtIndexPath:index];
                [UIView animateWithDuration:.25 animations:^{
                    cellImg.scroll.zoomScale = 1;
                }];
            }
            [self checkInfos:indexPath.row];
            
            //            [self checkSelected:indexPath.row];
        }
        if (frm.origin.x==0) {
            lastIndex=indexPath.row;
        }else{
            
        }
    }
}

#pragma mark - 滑动停止,加载
- (void)checkInfos:(NSInteger)row{
    if (curIndex==row) {
        return;
    }
    
    curIndex=row;
    if (curIndex<self.arrPhotos.count) {
        if (self.arrPhotos.count>1) {
            _lblNum.hidden = NO;
            _lblNum.text=[NSString stringWithFormat:@"%ld/%ld",curIndex+1,(unsigned long)self.arrPhotos.count];
        }else{
            _lblNum.hidden = YES;
        }
        
    }
}

- (void)loadImageForCell:(NSIndexPath *)indexPath{
    if (loadIndex==indexPath.row) {
        return;
    }
    
    loadIndex=indexPath.row;
    if (loadIndex>=self.arrPhotos.count) {
        return;
    }
}
#pragma mark - PhotoViewerDelegate
- (void)WebImagePreviewCellTapDelegate:(WebImagePreviewCell*)cell{
    [self oneTap];
}

- (void)WebImagePreviewCellDelegate:(WebImagePreviewCell*)cell success:(BOOL)success{
    if (success) {
        btnMenu.hidden = NO;
    }else{
        btnMenu.hidden = YES;
    }
    
}
#pragma mark 单击屏幕
- (void)oneTap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 菜单
- (IBAction)btnMenuAction:(id)sender {
    NSIndexPath *index = [NSIndexPath indexPathForRow:curIndex inSection:0];
    WebImagePreviewCell *cell = (WebImagePreviewCell *)[self.collectMain cellForItemAtIndexPath:index];
    imgSave = cell.imgPhoto.image;
    
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveimage];
    }];
    [alt addAction:camera];
    UIAlertAction *PhotoLibrary = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[ThirdShare sharedInstance] ThirdShareView:nil title:nil nav:self.navigationController content:nil btnCopy:NO shareType:ShareImage img:imgSave];
    }];
    [alt addAction:PhotoLibrary];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}
- (void)saveimage
{
    [ASSETS_Album saveImageToSavePhoto:imgSave resultBlock:^(NSString *url, ALAsset *asset) {
        [self showLoadingImageWithImg:@"duigggg" Message:@"保存成功"];
        [self performSelector:@selector(didLoad) withObject:nil afterDelay:1.0];
    } failure:^(NSError *error) {
        [self showLoadingImageWithImg:@"chacc" Message:@"保存失败"];
        [self performSelector:@selector(didLoad) withObject:nil afterDelay:1.0];
    }];
}
#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
