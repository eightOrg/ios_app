//
//  UIImage+ChangeToSize.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/15.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChangeToSize)
#pragma mark - 缩放
+(UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size;
#pragma mark - 圆形
+(UIImage*)JH_CircleImage:(UIImage *)image scaledToSize:(CGSize)size;
#pragma mark - 按照宽度缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）KB
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

//直接按照比例压缩
+(NSData *)compressOriginalImageOnece:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
@end
