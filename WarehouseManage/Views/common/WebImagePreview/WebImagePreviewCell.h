//
//  WebImagePreviewCell.h
//  Test
//
//  Created by zhchen on 2017/4/27.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "WebImagePreviewModel.h"
@interface WebImagePreviewCell : BaseCollectionCell
@property (nonatomic,retain) UIImageView *imgPhoto;
@property (nonatomic, retain) IBOutlet UIScrollView *scroll;
@property (nonatomic, retain) UIImage *photo;
@end
@protocol WebImagePreviewCellDelegate <NSObject>
@optional
- (void)WebImagePreviewCellTapDelegate:(WebImagePreviewCell*)cell;
- (void)WebImagePreviewCellDelegate:(WebImagePreviewCell*)cell success:(BOOL)success;
@end
