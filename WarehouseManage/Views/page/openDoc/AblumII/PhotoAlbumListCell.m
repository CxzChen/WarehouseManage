//
//  PhotoAlbumListCell.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbumListCell.h"

@implementation PhotoAlbumListCell

+ (float)getCellHeight:(id)obj{
    return 78;
}

-(void)UIGlobal{
    [super UIGlobal];
    [self setSeparatorMargin:12 edge:EdgeLeft];
    
    lblTTL.textColor=RGBHex(kColorGray201);
    lblNum.textColor=RGBHex(kColorGray201);
    
    lblTTL.font=fontSystem(kFontS34);
    lblNum.font=fontSystem(kFontS28);
    
//    CGSize sz=[GLOBALMANAGER sizeText:lblTTL.text font:lblTTL.font];
//    
//    CGRect frm=lblNum.frame;
//    frm.origin.x=CGRectGetMinX(lblTTL.frame)+sz.width+5;
//    lblNum.frame=frm;
//    DLog(@"%@ frm %@",NSStringFromCGSize(sz),NSStringFromCGRect(frm));
//    [self layoutIfNeeded];
//    [self setNeedsDisplay];
}



- (void)setCellImage:(UIImage*)image title:(NSString*)title numberOfAssets:(NSInteger)numberOfAssets{
    photo.image=image;
    lblTTL.text=title;
    lblNum.text=[NSString stringWithFormat:@"(%ld)",(long)numberOfAssets];
    
    
}
@end
