//
//  CommodityCell.m
//  Test
//
//  Created by zhchen on 2017/8/18.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "CommodityCell.h"

@implementation CommodityCell
- (void)setCell:(CommodityListModel *)model
{
    lblName.text = model.good.name;
    
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
    
    
    
    
    lblName.textColor = RGBHex(kColorGray203);
    lblOld.textColor = RGBHex(kColorGray203);
    lblNew.textColor = RGBHex(kColorGray203);
    lblWare.textColor = RGBHex(kColorGray203);
    lblShip.textColor = RGBHex(kColorGray203);
    lblReturn.textColor = RGBHex(kColorGray203);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
