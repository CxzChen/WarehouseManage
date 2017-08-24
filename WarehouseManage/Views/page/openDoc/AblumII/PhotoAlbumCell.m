//
//  PhotoAlbumCell.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbumCell.h"

@implementation PhotoAlbumCell
- (void)UIGlobal{
//    self.backgroundColor=RGBHex(kColor2);
//    self.backgroundView.backgroundColor=RGBHex(kColor2);
    self.btnSelect.backgroundColor=[UIColor clearColor];

    UIEdgeInsets edge=UIEdgeInsetsMake(AutoValue(-55), AutoValue(55), 0, 0);
//    DLog(@"%f %f",AutoMoveValue(45),AutoValue(45));
//    UIEdgeInsetsMake(AutoValue(-40), AutoValue(40), 0, 0);
    [self.btnSelect setContentEdgeInsets:edge];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self UIGlobal];
}

- (IBAction)selectAction:(id)sender{
    /*
    //按钮动画
    UIButton *btn=sender;
    if (btn.selected==false) {
        [UIView animateWithDuration:.25f animations:^{
            btn.transform = CGAffineTransformMakeScale(1.15, 1.15);
        } completion:^(BOOL finished) {
            btn.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
    */
//    btn.selected=!btn.selected;
    if ([self.delegate respondsToSelector:@selector(PhotoAlbumCellDelegate:)]) {
        [self.delegate PhotoAlbumCellDelegate:self];
    }
}

//- (void)setCell:(PhotoModel*)data{
//    
//}
@end
