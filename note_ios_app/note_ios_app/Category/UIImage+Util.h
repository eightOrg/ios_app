//
//  UIImage+Util.h
//  carFinance
//
//  Created by hyjt on 2017/7/5.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

/**
 UIImage使用颜色生成

 @param color UIColor
 @param rect 大小
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color withRect:(CGRect )rect;

/**
 将第一张图绘制到第二张中间
 @param firstImage 上边的图（直接获取原始大小）
 @param secondImage 下边的图
 @param rect 下边大小
 @return 图片
 */
+(UIImage *)combineWithFirstImage:(UIImage *)firstImage  secondImage:(UIImage *)secondImage byRect:(CGRect)rect;

#pragma mark - 缩放
+(UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size;
#pragma mark - 圆形
+(UIImage*)JH_CircleImage:(UIImage *)image scaledToSize:(CGSize)size;
#pragma mark - 按照宽度缩放
+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）KB
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 按比例压缩图片至指定最大容量
 
 @param image 原始图片
 @param size 指定大小
 @return 图片Data数据
 */
+(NSData *)compressOriginalImageOnece:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
@end
