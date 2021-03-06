//
//  QWBaseTableCell.h
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseCell.h"
@protocol cloudBaseCellDelegate <NSObject>
@optional
- (void)cloudBaseCellDelegate:(id)delegate  UserItemModel:(id)model;
@end

@interface BaseTableCell : BaseCell
//@property(nonatomic, assign) id delegate;
//
///**
// *  传递需要返回到的页面位置
// */
//@property (nonatomic, weak) id delegatePopVC;
//
///**
// *  是否显示分割线
// */
//@property (assign) BOOL separatorHidden;
//@property (nonatomic, retain) UIView* separatorLine;

/*!
 @method
 @brief 返回cell当前高度

 */
+ (float)getCellHeight:(id)data;

/*!
 @method
 @brief 设置cell内容

 */
- (void)setCell:(id)model;


/**
 *  app的UI全局设置，包括背景色，top bar背景等
 */
- (void)UIGlobal;

/**
 *  设置分割线前后边距
 *
 *  @param margin 边距
 *  @param edge   前还是后
 */
//- (void)setSeparatorMargin:(CGFloat)margin edge:(Enum_Edge)edge;

//- (void)assignByModel:(id)mod;


/**
 *  设置选择后背景的颜色
 *
 *  @param aColor 颜色color
 */
//- (void)setSelectedBGColor:(UIColor*)aColor;
@end
