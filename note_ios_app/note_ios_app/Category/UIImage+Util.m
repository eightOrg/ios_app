//
//  UIImage+Util.m
//  carFinance
//
//  Created by hyjt on 2017/7/5.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

/**
 UIImage使用颜色生成
 
 @param color UIColor
 @param rect 大小
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color withRect:(CGRect )rect
{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 将第一张图绘制到第二张中间
 @param firstImage 上边的图（直接获取原始大小）
 @param secondImage 下边的图
 @param rect 下边大小
 @return 图片
 */
+(UIImage *)combineWithFirstImage:(UIImage *)firstImage  secondImage:(UIImage *)secondImage byRect:(CGRect)rect{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    [secondImage drawInRect:rect];
    CGFloat width = firstImage.size.width;
    CGFloat height = firstImage.size.height;
    //将第一个图绘制到中间
    [firstImage drawInRect:CGRectMake(rect.origin.x+(rect.size.width-width)/2, rect.origin.y+(rect.size.height-height)/2, width, height)];
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
    
}
/**
 *  图片缩放
 *  @param image 传入图片
 *  @param size  需要的图片大小
 *  @return 返回新图片
 */
+(UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
    
}
/**
 *  将图片变成圆形
 *  @param image 传入图片
 *  @return 返回圆形的图片
 */
+(UIImage*)JH_CircleImage:(UIImage *)image scaledToSize:(CGSize)size{
    // self -> 圆形图片
    
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    
    // 上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪
    CGContextClip(context);
    
    // 绘制图片到圆上面
    [image drawInRect:rect];
    
    // 获得图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
/**
 *  等比例缩放图片
 *
 *  @param sourceImage 原始图片
 *  @param defineWidth 指定宽度
 *
 *  @return 新的图片
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）Kbyte
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.1f) {
        maxQuality = maxQuality - 0.1f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

/**
 按比例压缩图片至指定最大容量

 @param image 原始图片
 @param size 指定大小
 @return 图片Data数据
 */
+(NSData *)compressOriginalImageOnece:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = size/dataKBytes;
    data = UIImageJPEGRepresentation(image, maxQuality);
    return data;
}
@end
