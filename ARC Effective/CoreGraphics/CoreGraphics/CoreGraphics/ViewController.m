//
//  ViewController.m
//  CoreGraphics
//
//  Created by zhangke on 15/5/8.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import "GraphicsView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //Core Graphics属于媒体层，它负责疾呼所有在IOS屏幕上进行的绘图操作。创建任何界面元素时，iOS都是用Core Graphics来将这些元素绘制到窗口中去的。通过实现和重载Core Graphics的方法，可以创建自定义的界面元素。
    //图形上下文：在图形上下文之外是无法进行绘图操作的
    //正确的使用方法是继承一个UIView的子类，重载其drawRect:方法获得它的上下文UIGraphicsGetCurrentContext（）
    
    
//    图形上下文类似画家的画布，承载绘图动作。绘图动作顺序执行，新动作在前一个动作的基础上完成。
//    最常见的用法是继承一个UIView的子类，重载其drawRect。视图刷新或者重绘drawRect都会被调用。调用频率很高，所以应该极为轻量级。
//    从不直接调用drawRect，需要重绘使用setNeedDisplay（作用是让iOS根据它的安排调用drawRect）。
    
    //画布，就是画画呢
    
    //路径(path)
    //笔画(stroke)
    //填充色(fill color)
    //线条粗细(line width)
    //线条图案(line dash)
    //阴影(shadow)
    //渐变(Gradient)
    //剪裁路径(clip path)
    //当前形变矩阵(current transform matrix)
    

    
    
    
    GraphicsView* gView=[[GraphicsView alloc] initWithFrame:self.view.bounds];
    gView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:gView];
    
    

}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{

}


@end
