//
//  PhotoViewerCell.h
//  CloudBox
//
//  Created by Qingyang on 15/12/15.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "ScrollTouch.h"
@interface PhotoViewerCell : BaseCollectionCell
@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, retain) IBOutlet ScrollTouch *scroll;
@property (nonatomic, retain) UIImage *photo;
- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize;
@end;

@protocol PhotoViewerDelegate <NSObject>
@optional
- (void)PhotoViewerDelegate:(PhotoViewerCell*)cell;
@end


@interface PhotoPreViewCell : PhotoViewerCell
{
    UIActivityIndicatorView *act;
}
@end