/**
 The MIT License (MIT)
 
 Copyright (c) 2015 DreamCao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "DMGraduallyView.h"

@implementation DMGraduallyView

@synthesize beginColor = _beginColor;
@synthesize endColor   = _endColor;

+ (instancetype)scrollItemGraduallyViewWithDirection:(DMGraduallyDirection)direction
{
    return [[self alloc] initWithDirection:direction];
}

- (instancetype)initWithDirection:(DMGraduallyDirection)direction
{
    self = [super init];
    if (self)
    {
        self.direction = direction;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (void)defaultSetting
{
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.direction = 0;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)setDirection:(NSInteger)direction
{
    if (direction < DMGraduallyMax)
    {
        _direction = direction;
        
        [self setNeedsDisplay];
    }
}

- (UIColor *)beginColor
{
    if (nil == _beginColor)
    {
        _beginColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    
    return _beginColor;
}

- (UIColor *)endColor
{
    if (nil == _endColor)
    {
        _endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    
    return _endColor;
}

- (void)setBeginColor:(UIColor *)beginColor
{
    _beginColor = beginColor;
    
    [self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制颜色渐变
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef beginColor = CGColorCreateCopy(self.beginColor.CGColor);
    CGColorRef endColor = CGColorCreateCopy(self.endColor.CGColor);
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,	   // 对应起点颜色位置
        1.0f		// 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGPoint startPoint = {0, 0};
    CGPoint endPoint = {0, 0};
    
    if (DMGraduallyLeft == self.direction)
    {
        startPoint = (CGPoint){0, 0};
        endPoint = (CGPoint){rect.size.width, 0};
    }
    else if (DMGraduallyRight == self.direction)
    {
        startPoint = (CGPoint){rect.size.width, 0};
        endPoint = (CGPoint){0, 0};
    }
    else if (DMGraduallyTop == self.direction)
    {
        startPoint = (CGPoint){0, 0};
        endPoint = (CGPoint){0, rect.size.height};
    }
    else if (DMGraduallyBottom == self.direction)
    {
        startPoint = (CGPoint){0, rect.size.height};
        endPoint = (CGPoint){0, 0};
    }
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
}

@end
