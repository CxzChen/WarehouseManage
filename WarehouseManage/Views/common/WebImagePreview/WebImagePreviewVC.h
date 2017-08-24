//
//  WebImagePreviewVC.h
//  Test
//
//  Created by zhchen on 2017/4/27.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "BaseViewController.h"
#import "WebImagePreviewModel.h"
@interface WebImagePreviewVC : BaseViewController
@property (nonatomic,assign) NSInteger indexSelected;//选择照片位置
@property (nonatomic,strong) NSMutableArray *arrPhotos;
@property (nonatomic,strong) IBOutlet UICollectionView *collectMain;
@property (nonatomic,strong) IBOutlet UILabel *lblNum;
@end
