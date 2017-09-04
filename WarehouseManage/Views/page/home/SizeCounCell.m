//
//  SizeCounCell.m
//  WarehouseManage
//
//  Created by zhchen on 2017/9/4.
//  Copyright © 2017年 zhchen. All rights reserved.
//

#import "SizeCounCell.h"

@implementation SizeCounCell
- (void)setCell:(SizeCounModel *)model
{
    lblName.text = model.size;
    
    if (model.origin.intValue > 9999) {
        CGFloat a = model.origin.intValue;
        a = a/10000;
        lblOld.text = [NSString stringWithFormat:@"原:%.4f万",a];
    }else{
        lblOld.text = [NSString stringWithFormat:@"原:%@",model.origin];
    }
    if (model.now.intValue > 9999) {
        CGFloat a = model.now.intValue;
        a = a/10000;
        lblNew.text = [NSString stringWithFormat:@"现:%.4f万",a];
    }else{
        lblNew.text = [NSString stringWithFormat:@"现:%@",model.now];
    }
    if (model.warehousing.intValue > 9999) {
        CGFloat a = model.warehousing.intValue;
        a = a/10000;
        lblWare.text = [NSString stringWithFormat:@"入:%.4f万",a];
    }else{
        lblWare.text = [NSString stringWithFormat:@"入:%@",model.warehousing];
    }
    if (model.shipments.intValue > 9999) {
        CGFloat a = model.shipments.intValue;
        a = a/10000;
        lblShip.text = [NSString stringWithFormat:@"出:%.4f万",a];
    }else{
        lblShip.text = [NSString stringWithFormat:@"出:%@",model.shipments];
    }
    if (model.back.intValue > 9999) {
        CGFloat a = model.back.intValue;
        a = a/10000;
        lblReturn.text = [NSString stringWithFormat:@"退:%.4f万",a];
    }else{
        lblReturn.text = [NSString stringWithFormat:@"退:%@",model.back];
    }
    
    
    
    
    lblName.textColor = RGBHex(kColorGray205);
    lblOld.textColor = RGBHex(kColorGray205);
    lblNew.textColor = RGBHex(kColorGray205);
    lblWare.textColor = RGBHex(kColorGray205);
    lblShip.textColor = RGBHex(kColorGray205);
    lblReturn.textColor = RGBHex(kColorGray205);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
