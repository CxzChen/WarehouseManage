//
//  WebImagePreviewModel.h
//  Test
//
//  Created by zhchen on 2017/4/27.
//  Copyright © 2017年 YAN.Qingyang. All rights reserved.
//

#import "BaseModel.h"
@interface ImgModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *url_preview;//预览图片地址
@property (nonatomic,retain) NSString<Optional> *url_origin;//原图地址

//@property (nonatomic,retain) NSString<Optional> *height;
//@property (nonatomic,retain) NSString<Optional> *width;
@end
@protocol ImgModel <NSObject>
@end
@interface WebImagePreviewModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *index;
@property (nonatomic,retain) NSMutableArray<ImgModel,Optional> *imgs;
@end
