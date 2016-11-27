//
//  ViewController.m
//  DMGraduallyViewDemo
//
//  Created by Dream on 15/6/21.
//  Copyright (c) 2015年 GoSing. All rights reserved.
//

#import "ViewController.h"
#import "DMGraduallyView.h"
#import "DMCircleGraduallyView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DMGraduallyView *m_graduallyView;
@property (weak, nonatomic) IBOutlet DMCircleGraduallyView *m_circleView;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.m_graduallyView.beginColor = [UIColor colorWithRed:0x22/255.0 green:0xaa/255.0 blue:0xa3/255.0 alpha:1];
    self.m_graduallyView.endColor = [UIColor colorWithRed:0x50/255.0 green:0x7b/255.0 blue:0xb4/255.0 alpha:1];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    self.m_graduallyView.direction = DMGraduallyCustom;
    self.m_graduallyView.beginPoint = CGPointMake(0, height);
    self.m_graduallyView.endPoint = CGPointMake(width, 0);
    
    self.m_imageView.image = [self.m_graduallyView generateImage];
    
    [self.m_circleView setBeginColor:[UIColor redColor] endColor:[UIColor whiteColor] beginPercent:0 endPercent:0.3];
}



@end
