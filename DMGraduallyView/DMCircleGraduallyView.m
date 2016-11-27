/**
 The MIT License (MIT)
 
 Copyright (c) 2016 DreamCao
 
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

#import "DMCircleGraduallyView.h"

@implementation DMCircleGraduallyView
{
    UIColor *_beginColor;
    UIColor *_endColor;
    CGFloat _beginPercent;
    CGFloat _endPercent;
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
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
    _beginPercent = 0.0;
    _endPercent = 1.0;
    
    [self calcVar];
}

- (void)calcVar
{
    _colorCenter = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
    _radius = MAX(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0) * sqrt(2);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self calcVar];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self calcVar];
    [self setNeedsDisplay];
}

- (void)setBeginColor:(UIColor * _Nullable)beginColor
             endColor:(UIColor * _Nullable)endColor
         beginPercent:(CGFloat)beginPercent
           endPercent:(CGFloat)endPercent
          colorCenter:(CGPoint)colorCenter
               radius:(CGFloat)radius
{
    _beginColor = beginColor;
    _endColor = endColor;
    _beginPercent = beginPercent;
    _endPercent = endPercent;
    _colorCenter = colorCenter;
    _radius = radius;
    
    [self setNeedsDisplay];
}

- (void)setBeginColor:(UIColor * _Nullable)beginColor
             endColor:(UIColor * _Nullable)endColor
         beginPercent:(CGFloat)beginPercent
           endPercent:(CGFloat)endPercent
{
    _beginColor = beginColor;
    _endColor = endColor;
    _beginPercent = beginPercent;
    _endPercent = endPercent;
    
    [self setNeedsDisplay];
}

- (UIColor *)startColor
{
    if (nil == _beginColor)
    {
        _beginColor = [UIColor whiteColor];
    }
    
    return _beginColor;
}

- (void)setBeginColor:(UIColor *)beginColor
{
    _beginColor = beginColor;
    
    [self setNeedsDisplay];
}

- (UIColor *)endColor
{
    if (nil == _endColor)
    {
        _endColor = [UIColor grayColor];
    }
    
    return _endColor;
}

- (void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    
    [self setNeedsDisplay];
}

- (void)setBeginPercent:(CGFloat)beginPercent
{
    _beginPercent = beginPercent;
    
    [self setNeedsDisplay];
}

- (CGFloat)beginPercent
{
    return _beginPercent;
}

- (void)setEndPercent:(CGFloat)endPercent
{
    _endPercent = endPercent;
    
    [self setNeedsDisplay];
}

- (CGFloat)endPercent
{
    return _endPercent;
}

- (void)setColorCenter:(CGPoint)colorCenter
{
    _colorCenter = colorCenter;
    
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawWithRect:rect withContextRef:context];
}

- (void)drawWithRect:(CGRect)rect
      withContextRef:(CGContextRef)context
{
    // 绘制颜色渐变
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef beginColor = CGColorCreateCopy(self.startColor.CGColor);
    CGColorRef endColor = CGColorCreateCopy(self.endColor.CGColor);
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        self.beginPercent, // 对应起点颜色位置
        self.endPercent  // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGPoint center = _colorCenter;
    CGFloat radius = _radius;
    
    CGContextDrawRadialGradient(context, gradientRef, center, 0, center, radius, 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
}

@end
