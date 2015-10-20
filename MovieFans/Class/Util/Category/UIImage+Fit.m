//
//  UIImage+Fit.m
//  MovieFans
//
//  Created by Leo Gao on 2/24/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "UIImage+Fit.h"

@implementation UIImage (Fit)
#pragma mark 返回拉伸好的图片
+ (UIImage *)resizeImage:(NSString *)imgName {
    return [[UIImage imageNamed:imgName] resizeImage];
}

- (UIImage *)resizeImage
{
    CGFloat leftCap = self.size.width * 0.5f;
    CGFloat topCap = self.size.height * 0.5f;
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)cut:(CGSize)sizeScale
{
    CGFloat width = self.size.width * sizeScale.width;
    CGFloat height = self.size.height * sizeScale.height;
    CGFloat x = (self.size.width -  width) * 0.5;
    CGFloat y = (self.size.height - height) * 0.5;
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef ref = CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:ref];
}
//调整图片大小
- (UIImage *)scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
