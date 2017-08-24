//
//  PhotoAlbumList.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbumList.h"
#import "PhotoAlbumListCell.h"
#import "QYPhotoAlbum.h"
#import "PhotoAlbum.h"
@interface PhotoAlbumList ()
{
    NSArray *arrData;
//    NSArray *arrGroups;
    void (^failureBlock)(NSError *error) ;
    PhotoAlbumBlock photosBlock;
    NSInteger maxPhotos;
    
    NSMutableArray *arrSelected;
    QYPhotoAlbumType pType;
}
@end

@implementation PhotoAlbumList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [ASSETS_Album getGroupsByPropertyType:pType resultBlock:^(NSArray *groups) {
        arrData=[groups copy];
        DLog(@"%@",arrData);
        [self.tableMain reloadData];
//        if (arrGroups.count) {
//            ALAssetsGroup *grp=arrGroups.firstObject;
//            [self showGroup:grp];
//        }
    } failure:failureBlock];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self naviLeftBottonImage:nil highlighted:nil action:nil];
}



- (void)UIGlobal{
    [super UIGlobal];
    
//    self.title=@"照片";
    self.view.backgroundColor=RGBHex(kColorW);
    
    [self naviLeftButton:@"关闭" action:@selector(closeAction:)];
    [self naviTitle:@"选择相册"];
    
    [self.tableMain setContentInset:UIEdgeInsetsMake(kNavibarH, 0, 0, 0)];
}

//- (void)showList:(NSArray*)list block:(PhotoAlbumListSelectedBlock)block{
////    DLog(@"########### %@",list);
//    groupBlock=block;
//    arrData=list;
//    
//}

#pragma matk - action
- (IBAction)closeAction:(id)sender{
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
#pragma mark - fct
- (void)selectType:(QYPhotoAlbumType)propertyType maxNum:(NSInteger)maxNum selected:(NSMutableArray*)list block:(PhotoAlbumBlock)block failure:(void(^)(NSError *error))failure{
    failureBlock=failure;
    
    photosBlock=block;
    maxPhotos=maxNum;
    
    pType=propertyType;
    
    if (arrSelected==nil)
        arrSelected=[[NSMutableArray alloc]init];
    
    
//    [self showNum];
}

- (void)close{
    [self closeAction:nil];
}
#pragma mark 表格
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PhotoAlbumListCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID = @"PhotoAlbumListCell";
    
    PhotoAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    cell.delegate=self;
    if (row<arrData.count) {
        ALAssetsGroup *grp=[arrData objectAtIndex:row];
        [cell setCellImage:[UIImage imageWithCGImage:grp.posterImage] title:[grp valueForProperty:ALAssetsGroupPropertyName] numberOfAssets:grp.numberOfAssets];
        
//        cell.imageView.image=[UIImage imageWithCGImage:grp.posterImage];
//        cell.textLabel.text=[grp valueForProperty:ALAssetsGroupPropertyName];
//        [cell setCell:nil];
        return cell;
    }
    
    
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%@",indexPath);
    
    
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:.3];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromRight];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
//    [self.navigationController popViewControllerAnimated:NO];
//    
//    if (indexPath.row<arrData.count && groupBlock) {
//        groupBlock([arrData objectAtIndex:indexPath.row]);
//    }
    
    if (indexPath.row<arrData.count) {
        PhotoAlbum *vc = [QGLOBAL viewControllerName:@"PhotoAlbum" storyboardName:@"PhotoAlbum"];
        //    vc.arrPhotos = arrTemp;
//        vc.arrSelected= arrSelected;
//        vc.maxPhotos=maxPhotos;
//        
//        vc.photosBlock=photosBlock;
        if (pType==QYPhotoAlbumTypePhotos) {
            vc.type=PhotoModelTypePhoto;
        }
        else if (pType==QYPhotoAlbumTypeVideos) {
            vc.type=PhotoModelTypeVideo;
        }
        vc.group=[arrData objectAtIndex:indexPath.row];
        [vc selectPhotos:maxPhotos selected:arrSelected block:photosBlock failure:failureBlock];
        [self.navigationController pushViewController:vc animated:YES];
//        [vc showGroup:[arrData objectAtIndex:indexPath.row]];
//        groupBlock([arrData objectAtIndex:indexPath.row]);
    }

    
}

#pragma mark - 页面滑动
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    
}
@end
