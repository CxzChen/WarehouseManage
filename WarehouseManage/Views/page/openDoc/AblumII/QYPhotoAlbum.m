//
//  QYPhotoAlbum.m
//  PhotoInfo
//
//  Created by YAN Qingyang on 13-5-12.
//  Copyright (c) 2013年 YAN Qingyang. All rights reserved.
//  Version 0.1
//
// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2014 YAN Qingyang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "QYPhotoAlbum.h"
#import "QYImage.h"

static int instanceNum = 0;

@interface QYPhotoAlbum ()
<UIAlertViewDelegate>
{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *arrData;
    dispatch_queue_t queuePhotoAlbum;
    QYAblumPhotoBlock fullPhotoBlock;
    NSMutableArray *arrAssetList, *arrBlockList;
    

    float waitTime;
    int memorySize;
}
@end

@implementation QYPhotoAlbum
@synthesize isOpening=_isOpening;

+ (instancetype)instance{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - init
- (id)init
{
    if (self == [super init]) {
        assetsLibrary=[[ALAssetsLibrary alloc] init];
        NSString *queueID = [NSString stringWithFormat:@"Queue_PhotoAlbum_%d", instanceNum++];
        queuePhotoAlbum = dispatch_queue_create([queueID UTF8String], NULL);
        fullPhotoBlock=nil;
        arrAssetList=[[NSMutableArray alloc]init];
        arrBlockList=[[NSMutableArray alloc]init];
        waitTime=0;
        [self checkPhysicalMemory];
        return self;
    }
    return nil;
}

- (void)checkPhysicalMemory{
    if ([NSProcessInfo processInfo].physicalMemory<1000000000) {
        memorySize=500;
    }
    else memorySize=1000;
}

- (void)clean{

    [arrData removeAllObjects];
    arrData=nil;
    
  
}

//异步串行队列
- (void)invokeAsyncQueueBlock:(id (^)())block success:(void (^)(id obj))success
{
    dispatch_async(queuePhotoAlbum, ^(void) {
        id retVal = nil;
        if (block) {
            retVal = block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (success) {
                                   success(retVal);
                               }
                           });
        }
    });
}

#pragma mark - function
- (void)getSavedPhotosBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure{

    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //遍历相册组内照片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arrData insertObject:result atIndex:0];
        }
        else {
            
        }
    };
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            //只显示Photo(allPhotos),只显示Video(allVideos)，或显示全部(allAssets)
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
            //////////////////////////////////////////////////////////////
            /*
             ALAsset *asset=[arrData objectAtIndex:i];
             
             // 通过ALAssetProperty参数直接获取时间，地理坐标等
             NSDate *date = (NSDate*)[asset valueForProperty:ALAssetPropertyDate] ;
             CLLocation *loc = (CLLocation*)[asset valueForProperty:ALAssetPropertyLocation];
             
             // 通过metadata和<ImageIO/ImageIO.h>的kCGImageProperty参数 获取图像Exif，GPS等Dict信息
             // metadata需要在@autoreleasepool立即释放，否则内存泄漏
             @autoreleasepool {
             ALAssetRepresentation *rep=[asset defaultRepresentation];
             NSString *fileName  = [rep filename];
             
             NSDictionary * allMetadata = [rep metadata];
             NSDictionary *gpsInfo = [allMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
             NSDictionary *exif = [allMetadata objectForKey:(NSString*)kCGImagePropertyExifDictionary];
             
             //亮度值等
             NSNumber *sharpness = [exif objectForKey:(NSString*)kCGImagePropertyExifSharpness];
             NSNumber *brightness = [exif objectForKey:(NSString*)kCGImagePropertyExifBrightnessValue];
             }
             */
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    };
    
    //查询saved组
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)getSavedPhotosOldFirstBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure{
    
    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //遍历相册组内照片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arrData addObject:result];
        }
        else {
            
        }
    };
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            //只显示Photo(allPhotos),只显示Video(allVideos)，或显示全部(allAssets)
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    };
    
    //查询saved组
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}
#pragma mark - 根据参数获取数据
- (void)getGroupsByPropertyType:(QYPhotoAlbumType)propertyType resultBlock:(QYAblumGroupsBlock)resultBlock failure:(void(^)(NSError *error))failure{

    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        //NSLog(@"ALAssetsLibraryGroups:%@",group);
        if (group) {
            ALAssetsFilter *onlyPhotosFilter;
            switch (propertyType) {
                case QYPhotoAlbumTypeAll:
                    onlyPhotosFilter = [ALAssetsFilter allAssets];
                    break;
                case QYPhotoAlbumTypePhotos:
                    onlyPhotosFilter = [ALAssetsFilter allPhotos];
                    break;
                case QYPhotoAlbumTypeVideos:
                    onlyPhotosFilter = [ALAssetsFilter allVideos];
                    break;
                default:
                    break;
            }
            
            [group setAssetsFilter:onlyPhotosFilter];
            
            ALAssetsGroupType assetType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            //把相机胶卷列第一行
            if (assetType==ALAssetsGroupSavedPhotos) {
                [arrData insertObject:group atIndex:0];
            }
            else if(group.numberOfAssets>0)
                [arrData addObject:group];
            
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
    };
    
    //查询组
    NSUInteger groupTypes =  ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;//ALAssetsGroupLibrary
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

-(void)getAssetsByGroup:(ALAssetsGroup *)group propertyType:(QYPhotoAlbumType)propertyType resultBlock:(QYAssetsListBlock)resultBlock
{
    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    //    NSLog(@"%@",group);
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion =^(ALAsset *result,NSUInteger index, BOOL *stop)
    {
        if (result!=NULL)
        {
            switch (propertyType) {
                case QYPhotoAlbumTypePhotos:
                    if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]){
                        [arrData addObject:result];
                    }
                    break;
                case QYPhotoAlbumTypeVideos:
                    if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypeVideo]){
                        [arrData addObject:result];
                    }
                    break;
                case QYPhotoAlbumTypeAll:
                    [arrData addObject:result];
                    break;
                default:
                    break;
            }
            
        }
        else
        {
            resultBlock(arrData);
        }
        
    };
    [group enumerateAssetsUsingBlock:groupEnumerAtion];
}

- (void)getPhotosByGroup:(ALAssetsGroup*)group resultBlock:(QYAssetsListBlock)resultBlock failure:(void(^)(NSError *error))failure{

    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [arrData removeAllObjects];
    }
    
    //遍历相册组内照片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arrData insertObject:result atIndex:0];
        }
        else {
            
        }
    };
    
    //group获取方法，类似dictory，最后nil结尾，所以nil的时候调用reload
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            //只显示Photo(allPhotos),只显示Video(allVideos)，或显示全部(allAssets)
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        } else {
            if (resultBlock) {
                resultBlock(arrData);
            }
            //////////////////////////////////////////////////////////////
            /*
             ALAsset *asset=[arrData objectAtIndex:i];
             
             // 通过ALAssetProperty参数直接获取时间，地理坐标等
             NSDate *date = (NSDate*)[asset valueForProperty:ALAssetPropertyDate] ;
             CLLocation *loc = (CLLocation*)[asset valueForProperty:ALAssetPropertyLocation];
             
             // 通过metadata和<ImageIO/ImageIO.h>的kCGImageProperty参数 获取图像Exif，GPS等Dict信息
             // metadata需要在@autoreleasepool立即释放，否则内存泄漏
             @autoreleasepool {
             ALAssetRepresentation *rep=[asset defaultRepresentation];
             NSString *fileName  = [rep filename];
             
             NSDictionary * allMetadata = [rep metadata];
             NSDictionary *gpsInfo = [allMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
             NSDictionary *exif = [allMetadata objectForKey:(NSString*)kCGImagePropertyExifDictionary];
             
             //亮度值等
             NSNumber *sharpness = [exif objectForKey:(NSString*)kCGImagePropertyExifSharpness];
             NSNumber *brightness = [exif objectForKey:(NSString*)kCGImagePropertyExifBrightnessValue];
             }
             */
        }
    };
    
    //获取失败
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    };
    
    //查询saved组
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}



- (UIImage *)getFullImageByAsset:(ALAsset*)asset limitBite:(NSInteger)limitBite{
    //获取图
    UIImage *fullResolutionImage;
    @autoreleasepool {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        float scale=rep.scale;

        if (limitBite > 0 && rep.size > limitBite) {
            scale=(float)rep.size/(float)limitBite;
        }

        fullResolutionImage = [UIImage imageWithCGImage:rep.fullResolutionImage scale:scale orientation:(UIImageOrientation)rep.orientation];
//        DLog(@"%lld:%d->%f,%@",rep.size,limitBite,scale,NSStringFromCGSize(fullResolutionImage.size));
    }
    return fullResolutionImage;
}

- (UIImage *)getScreenImageByAsset:(ALAsset*)asset{
    //获取原图
    UIImage *fullResolutionImage;
    @autoreleasepool {
        //        ALAssetRepresentation *rep = [asset defaultRepresentation];
        
        fullResolutionImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        //[UIImage imageWithCGImage:rep.fullScreenImage scale:[rep scale] orientation:UIImageOrientationUp];
    }
    return fullResolutionImage;
}

- (UIImage *)getAspectRatioThumbnailByAsset:(ALAsset*)asset{
    //获取原图
    UIImage *image;
    @autoreleasepool {
        image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
     
    }
    return image;
}

- (void)getFullImageByURL:(NSString*)assetUrl photoBlock:(QYAblumPhotoBlock)photoBlock assetBlock:(void(^)(ALAsset *asset))assetBlock failure:(void(^)(NSError *error))failure{
    [assetsLibrary assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset){
        assetBlock(asset);
        
        if (photoBlock)
            fullPhotoBlock = photoBlock;
        
        if (asset != nil) {
            [arrAssetList addObject:asset];
        }
        
        [self photosQueue];
    }  failureBlock:failure];
}

- (void)getFullImageByAsset:(ALAsset*)asset photoBlock:(QYAblumPhotoBlock)photoBlock failure:(void(^)(NSError *error))failure{
    if (photoBlock)
        fullPhotoBlock = photoBlock;
    
    if (asset != nil) {
        [arrAssetList addObject:asset];
    }
    
    [self photosQueue];
}

- (void)getFullImageByAssetList:(NSArray*)list photoBlock:(QYAblumPhotoBlock)photoBlock failure:(void(^)(NSError *error))failure{
    [self cleanPhotosQueue];
    
    fullPhotoBlock = photoBlock;
    if (list.count) {
        [arrAssetList addObjectsFromArray:list];
    }
    [self photosQueue];
}

- (void)getFullImageByAssetList:(NSArray*)list photosBlock:(void(^)(NSArray* listPhotos))photosBlock failure:(void(^)(NSError *error))failure{
    [self cleanPhotosQueue];
    NSMutableArray *tmp=[[NSMutableArray alloc] initWithCapacity:list.count];
    fullPhotoBlock = ^(UIImage *fullResolutionImage){
        [tmp addObject:fullResolutionImage];
        if (tmp.count==list.count) {
            if (photosBlock) {
                photosBlock(tmp);
            }
        }
    };
    if (list.count) {
        [arrAssetList addObjectsFromArray:list];
    }
    [self photosQueue];
}

- (void)getImagesByAssetList:(NSArray*)list limitSize:(CGSize)limitSize photosBlock:(void(^)(NSArray* listPhotos))photosBlock failure:(void(^)(NSError *error))failure{
    [self cleanPhotosQueue];
    NSMutableArray *tmp=[[NSMutableArray alloc] initWithCapacity:list.count];
    
    __weak typeof (self) weakSelf = self;
    fullPhotoBlock = ^(UIImage *fullResolutionImage){
        [tmp addObject:[weakSelf image:fullResolutionImage toSize:limitSize]];
        if (tmp.count==list.count) {
            if (photosBlock) {
                photosBlock(tmp);
            }
        }
    };
    if (list.count) {
        [arrAssetList addObjectsFromArray:list];
    }
    
    [self photosQueue];
}

- (UIImage *)getFullImageByAsset:(ALAsset*)asset{
    //获取原图
    UIImage *fullResolutionImage;

    @autoreleasepool {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        //        DLog(@"%lld",rep.size);
        fullResolutionImage = [UIImage imageWithCGImage:rep.fullResolutionImage scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
    }
    
    return fullResolutionImage;
}
//- (void)getImageByAsset:(ALAsset*)asset limitSize:(CGSize)limitSize photo:(void(^)(UIImage *fullResolutionImage))photo failure:(void(^)(NSError *error))failure{
//    UIImage *img = [self getFullImageByAsset:asset];
//    photo(img);
//}

#pragma mark - video
//#define KCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoAssetUrl:(NSURL *)url fileName:(NSString *)fileName writeToPath:(NSString*)docPath
{
    NSString *doc=docPath?docPath:[FileManager getTmpPath];
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [doc stringByAppendingPathComponent:fileName];
                char const *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 1024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
    
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                }
                

                
            } failureBlock:nil];
        }
    });
}
#pragma mark - 图片处理
//- (UIImage*)photoToMin:(UIImage*)photo{
//    UIImage * image = photo;
//    image = [image imageByScalingToMinSize];
//    image = [UIImage scaleAndRotateImage:image];
//    return image;
//}

#pragma mark - 图片队列
- (void)photosQueue{
    if (arrAssetList.count>0) {
        if (waitTime>0) {
//            DLog(@"photosQueue 正在加载x%d: %f",arrAssetList.count,waitTime);
            return;
        }
   
        ALAsset *ass=[arrAssetList firstObject];
        QYAblumPhotoBlock block = nil;
        if (arrBlockList.count>0) {
            block = [arrBlockList firstObject];
        }
        
        long long sz=ass.defaultRepresentation.size;
        if (sz>10000000) {
            waitTime=(double)sz/10000000.0;
            DLog(@"大数据: %f",waitTime);
        }
        else {
            waitTime=0.25f;
        }
        
        if (memorySize>500) {
            waitTime=0.01f;
        }
        
        UIImage *img=[self getFullImageByAsset:ass];
        if (block)
            block(img);
        else if(fullPhotoBlock){
            fullPhotoBlock(img);
        }
        if (block) [arrBlockList removeObject:block];
        [arrAssetList removeObject:ass];
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self performSelector:@selector(startPhotosQueue) withObject:nil afterDelay:waitTime];
                       });
    }
}

- (void)startPhotosQueue{
    waitTime=0.f;
    [self photosQueue];
}

- (void)cleanPhotosQueue{
    fullPhotoBlock=nil;
    [arrAssetList removeAllObjects];
    [arrBlockList removeAllObjects];
//    for (int i = 1; i<arrAssetList.count; i++) {
//        [arrAssetList removeObjectAtIndex:i];
//    }
}

- (BOOL)isOpening{
    if (waitTime>0) {
        return YES;
    }
    return NO;
}

- (void)setIsOpening:(BOOL)isOpening{
    _isOpening=isOpening;
}

#pragma mark - 检查设置状态
+ (BOOL)checkAlbumAuthorizationStatus{
    BOOL auth=YES;
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if(status == ALAuthorizationStatusNotDetermined){
        //请求访问相册
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                
                return;
            }
            *stop = TRUE;
        } failureBlock:^(NSError *error) {
            
        }];
        return auth;
    }
    else if (status == ALAuthorizationStatusDenied) {
        auth=false;
    }
    
    return auth;
}

+ (BOOL)checkCameraAuthorizationStatus{
    BOOL auth=YES;
    if (![[AVCaptureDevice  class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        //Do something…
        
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus)
    {
        case AVAuthorizationStatusAuthorized:
        case AVAuthorizationStatusRestricted:
        {
            //Do something…
            break;
        }
        case AVAuthorizationStatusDenied:
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App name" message:@"Appname does not have access to your camera. To enable access, go to iPhone Settings > AppName and turn on Camera." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            
            //设置里摄像头被关了
            auth=false;
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // //请求访问
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        //Do something…
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        //Do something…
                                    });
                 }
             }];
            break;
        }
        default:
            break;
    }
    return auth;
}
#pragma mark - asset获取图片
//+ (UIImage *)getFullImageByAsset:(ALAsset*)asset{
//    //获取原图
//    UIImage *fullResolutionImage;
//    @autoreleasepool {
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        
//        fullResolutionImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
//    }
//    return fullResolutionImage;
//}

//预览图，UIImageOrientationUp，不用调整方向
//+ (UIImage *)getPreviewImageByAsset:(ALAsset*)asset{
//    @autoreleasepool {
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        return [UIImage imageWithCGImage:rep.fullScreenImage];
//        //        return [UIImage imageWithCGImage:[rep fullScreenImage] scale:[rep scale] orientation:UIImageOrientationUp];//(UIImageOrientation)rep.orientation
//    }
//    return nil;
//}

//+ (UIImage *)getImageByAsset:(ALAsset*)asset scale:(CGFloat)scale{
//    //获取缩放图
//    UIImage *image;
//    @autoreleasepool {
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        
//        image = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
//        image = [QYImage fixImageOrientation:image];
//        image = [QYImage scaleImage:image toScale:scale];
//        
//        //        [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale]/scale orientation:UIImageOrientationUp];
//    }
//    return image;
//}
#pragma mark -
//
//+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
//{
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
//    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return scaledImage;
//}

+ (NSDate *)getDateByAsset:(ALAsset*)asset{
    NSDate *date = (NSDate*)[asset valueForProperty:ALAssetPropertyDate];
    
    return date;
}

+ (NSDictionary *)getGPSByAsset:(ALAsset*)asset{
    NSDictionary *gpsInfo=nil;
    @autoreleasepool {
        ALAssetRepresentation *rep=[asset defaultRepresentation];
        
        NSDictionary * allMetadata = [rep metadata];
        gpsInfo = [allMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
    if (gpsInfo!=nil) {
        return gpsInfo;
    }
    return [NSDictionary dictionary];
}

+ (NSDictionary *)getExifByAsset:(ALAsset*)asset{
    NSDictionary *exif=nil;
    @autoreleasepool {
        ALAssetRepresentation *rep=[asset defaultRepresentation];
        
        NSDictionary * allMetadata = [rep metadata];
        exif = [allMetadata objectForKey:(NSString*)kCGImagePropertyExifDictionary];
        //        gpsInfo = [allMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
    if (exif!=nil) {
        return exif;
    }
    return [NSDictionary dictionary];
}

+ (CGSize)getSizeOfImageByAsset:(ALAsset*)asset{
    CGSize sz=CGSizeZero;
    @autoreleasepool {
        ALAssetRepresentation *rep=[asset defaultRepresentation];
        //        UIImageOrientation ort=((UIImageOrientation)[rep orientation]);
        //        return [rep dimensions];
        
        UIImage *image = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale] orientation:UIImageOrientationUp];//UIImageOrientationUp
        //        NSLog(@"getSizeOfImageByAsset:%@ %@",NSStringFromCGSize(image.size),NSStringFromCGSize([rep dimensions]));
        return image.size;
    }
    
    return sz;
}

+ (NSString *)getNameByAsset:(ALAsset*)asset{
    NSString *fileName=nil;
    @autoreleasepool {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        fileName  = [assetRepresentation filename];
        [assetRepresentation UTI];
    }
    return fileName;
}


+ (NSURL *)getURLByAsset:(ALAsset*)asset{
    NSURL *url=nil;
    @autoreleasepool {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        url  = [assetRepresentation url];
    }
    return url;
}
#pragma mark - url获取图片
+ (void)getImageThumbnailByURL:(NSString*)assetUrl
                         photo:(void(^)(UIImage *thumbnail, ALAsset *asset))photo failure:(void(^)(NSError *error))failure{
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset){
        photo([UIImage imageWithCGImage:asset.thumbnail],asset);
    }  failureBlock:failure];
}



+ (void)getImageByURL:(NSString*)assetUrl maxSize:(long long)maxSize
                photo:(void(^)(UIImage *thumbnail, UIImage *compressionImage))photo failure:(void(^)(NSError *error))failure{
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset){
        @autoreleasepool {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            CGFloat compression=1;
            if (rep.size>maxSize) {
                compression=(CGFloat)maxSize/(CGFloat)rep.size;
            }
            UIImage *fullImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:[rep scale] orientation:(UIImageOrientation)rep.orientation];
            //            fullImage=[QYImage fixImageOrientation:fullImage];
            
            NSData *data = UIImageJPEGRepresentation(fullImage, compression);
            UIImage *aImg = [UIImage imageWithData:data];
            //
            
//            DLog(@"\n%lli \n%f \n%@ \n%d",rep.size,compression,NSStringFromCGSize(rep.dimensions),data.length);
            photo([UIImage imageWithCGImage:asset.thumbnail],aImg);
        }
    }  failureBlock:failure];
}

#pragma mark - 保存到相册
- (void)saveImageToSavePhoto:(UIImage*)image resultBlock:(void(^)(NSString *url, ALAsset *asset))resultBlock failure:(void(^)(NSError *error))failure
{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    [assetsLibrary writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        //error handling
        if (error!=nil) {
            if (failure)
                failure(error);
            return;
        }
        
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset){
           resultBlock(assetURL.absoluteString, asset);
        }  failureBlock:failure];
        
    }];
    
    //    [lib writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
    //                       completionBlock:^(NSURL* assetURL, NSError* error) {
    //
    //                           //error handling
    //                           if (error!=nil) {
    //                               failure(error);
    //                               return;
    //                           }
    //
    //                           imageURL(assetURL.absoluteString);
    //
    //                       }];
    
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}
#pragma mark - size
- (UIImage*)image:(UIImage*)img toSize:(CGSize)limitSize{
    CGSize sz;
    if (!CGSizeEqualToSize(limitSize, CGSizeZero) && (img.size.width*img.size.width>limitSize.width*limitSize.height)) {
        sz=[self originSize:img.size fitInSize:limitSize];
        img=[self originImage:img toSize:sz];
    }

    return img;
}
#pragma mark - CGSize适配大小
- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize{
    if (oSize.height<=0 || oSize.width<=0) {
        return fSize;
    }
    
    float os=oSize.width/oSize.height;
    float fs=fSize.width/fSize.height;
    
    float ww,hh;
    if (os>fs) {
        ww=fSize.width;
        hh=oSize.height*fSize.width/oSize.width;
    }
    else {
        ww=oSize.width*fSize.height/oSize.height;
        hh=fSize.height;
    }
    
    
    //约等于floor()，ceil()四舍五入
    if (floor(os*100) / 100 == floor(fs*100) / 100 ) {
        //        DLog(@"%f %f",oSize.width/oSize.height,fSize.width/fSize.height);
        ww=fSize.width;
        hh=fSize.height;
        
    }
    
    return CGSizeMake(ww, hh);
}

- (UIImage *)originImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}
@end
