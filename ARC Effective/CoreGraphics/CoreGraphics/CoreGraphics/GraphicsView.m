//
//  GraphicsView.m
//  CoreGraphics
//
//  Created by zhangke on 15/5/8.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "GraphicsView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation GraphicsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    
    //获取context
    CGContextRef context=UIGraphicsGetCurrentContext();
    //rgba,1,0,0,1 ,红色 ,fillColor
    CGContextSetRGBFillColor(context,1,0,0,1);
    //蓝色，strokeColor
    CGContextSetRGBStrokeColor(context,0,0,1,1);

    //宽度
    CGContextSetLineWidth(context, 10);
    
    
    //设置线的起始端的样式
//    CGContextSetLineCap(context, 20);
    
    //虚线，段点
//    const CGFloat length=10;
//    CGContextSetLineDash(context, 10, &length, 5);
    
    //相交，圆，切线 
//    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    
    //添加路径path
    CGContextAddRect(context, CGRectMake(100,30,100,100));
    //在context中按照path，fill，stroke画
    //需要画了，要不然画笔颜色和填充色就变了
    CGContextDrawPath(context, kCGPathFillStroke);
    //只能画笔画，不能填充
//    CGContextStrokePath(context);
    
    
    //画线
    //设置线的颜色
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    //设置线的宽度
    CGContextSetLineWidth(context, 4);
    //设置线的起始端的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置线的连接样式
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    //移动画笔到该点
    CGContextMoveToPoint(context, 0, 200);
    //画到该点
    CGContextAddLineToPoint(context, 200, 200);
    
    CGPoint lines[]={
        CGPointMake(10, 90),
        CGPointMake(70, 60),
        CGPointMake(130, 90),
        CGPointMake(190, 60),
        CGPointMake(250, 90),
        CGPointMake(310, 60),
    };
    
    CGFloat length[]={10,5,10};
    
    //dash，段，虚线，设置间隔
    CGContextSetLineDash(context, 8, length, 3);
    
    CGContextAddLines(context, lines, 6);
    
    //用笔画画
    CGContextStrokePath(context);
    
    //UIBezierPath 也能画，UI层封装CG，addlinetopoint，画笔画到某个point
    [[UIColor blackColor] setStroke];

    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10.0, 90.0)];
    [path addLineToPoint:CGPointMake(70.0, 60.0)];
    [path addLineToPoint:CGPointMake(130.0, 90.0)];
    [path addLineToPoint:CGPointMake(190.0, 60.0)];
    [path addLineToPoint:CGPointMake(250.0, 90.0)];
    [path addLineToPoint:CGPointMake(310.0, 60.0)];
    path.lineWidth = 2;
    [path stroke];
    
    
    
    
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    CGContextSetLineWidth(context, 3);
    CGContextSetLineDash(context, 0, 0, 0);
     //画一个椭圆或者圆
    CGContextAddEllipseInRect(context, CGRectMake(10,30, 60, 60));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //根据中心点，半径，起始的弧度，最后的弧度，是否顺时针画一个圆弧

    CGContextAddArc(context, 140, 60, 30, M_PI/2, M_PI, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPoint p[3]={
        CGPointMake(210, 30),
        CGPointMake(210, 60),
        CGPointMake(240, 60),
    };
    
    //先移到p1点
    CGContextMoveToPoint(context, p[0].x, p[0].y);
    //从p1点开始画弧线，圆弧和p1-p2相切;p2-p3和弧线相切,圆弧的半径是20
    //zk p1->p2, 是 p2-》p3圆弧的切线
    CGContextAddArcToPoint(context, p[1].x, p[1].y, p[2].x, p[2].y, 20);
    CGContextStrokePath(context);
    
    
    //画一个圆角矩形
    CGRect rrect = CGRectMake(210.0, 70.0, 60.0, 60.0);
    CGFloat radius = 10.0;
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    //210，100
    CGContextMoveToPoint(context, minx, midy);
    //210，70，240，70
    //从左中－》左上－》上中 ，半径为10，画了个圆角的直角
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //贝塞尔曲线一,两个控制点
    CGPoint s = CGPointMake(30.0, 120.0); //起始点
    CGPoint e = CGPointMake(300.0, 120.0);//终点
    CGPoint cp1 = CGPointMake(120.0, 30.0);//控制点1 ,一个在上，一个在下，拉成八卦
    CGPoint cp2 = CGPointMake(210.0, 210.0);//控制点2
    //画笔先到起点，
    CGContextMoveToPoint(context, s.x, s.y);
    //贝塞尔曲线，起始，控制点，终点
    CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    CGContextStrokePath(context);
    
    //贝塞尔曲线二,一个控制点
    s = CGPointMake(30.0, 300.0);
    e = CGPointMake(270.0, 300.0);
    cp1 = CGPointMake(150.0, 180.0);
    CGContextMoveToPoint(context, s.x, s.y);
    //二次方的，抛物线，一个控制点，cocos2d 捕鱼达人，可以做完一个曲线，再做一个曲线么。
    CGContextAddQuadCurveToPoint(context, cp1.x, cp1.y, e.x, e.y);
    CGContextStrokePath(context);
    
    
    /*  封装CG
    path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    CGPoint s = CGPointMake(30.0, 120.0);
    CGPoint e = CGPointMake(300.0, 120.0);
    CGPoint cp1 = CGPointMake(120.0, 30.0);
    CGPoint cp2 = CGPointMake(210.0, 210.0);
    [path moveToPoint:s];
    [path addCurveToPoint:e controlPoint1:cp1 controlPoint2:cp2];
    [path stroke];
    
    path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    s = CGPointMake(30.0, 300.0);
    e = CGPointMake(270.0, 300.0);
    cp1 = CGPointMake(150.0, 180.0);
    [path moveToPoint:s];
    [path addQuadCurveToPoint:e controlPoint:cp1];
    [path stroke];  
     */
    
    
    
    //UIKit，Core Animation 左上角起点系统，CoreGraphics左下角起点系统
    
    CGContextSaveGState(context);
    //翻转起来---上下颠倒
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    ////假设想在10,30,80,80的地方绘制,颠倒过来后的Rect应该是 10, self.bounds.size.height - 110, 80, 80，还是按翻转之前的y。反过来正好，
    CGRect imageRect = CGRectMake(10, self.bounds.size.height - 730, 80, 80);
    CGContextDrawImage(context, imageRect, [UIImage imageNamed:@"20141203111310747"].CGImage);
    CGContextRestoreGState(context);
    
    
    
    
    //ImageContext，可以保存画布
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextSaveGState(context);
    
    //翻转起来---上下颠倒
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    imageRect = CGRectMake(0, self.bounds.size.height - 500, 80, 80);
    
    //drawimage，context，rect，cgimage
    CGContextDrawImage(context, imageRect, [UIImage imageNamed:@"20141203111310747"].CGImage);
    CGContextRestoreGState(context);

    NSString* xx=  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //从当前图像画布获取image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[xx stringByAppendingString:@"xx.png"] atomically:YES];
    
    //关闭image画布
    UIGraphicsEndImageContext();
    
    
    
    
    
    
    //创建一个RGB的颜色空间
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //定义渐变颜色数组
    CGFloat colors[] =
    {
        204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
        29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
        0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
    };
    
    //创建一个渐变的色值 1:颜色空间 2:渐变的色数组 3:位置数组,如果为NULL,则为平均渐变,否则颜色和位置一一对应 4:位置的个数
    //渐变颜色数组，创建渐变
    CGGradientRef _gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    //获得一个CGRect
    //减去边20的的rect
//    CGRect clip = CGRectInset(CGContextGetClipBoundingBox(context), 20.0, 20.0);
//    //剪切到合适的大小
    //zk如果做条状图，可以画一条裁剪一条的frame
    //先保存状态再撤销，复制了，不管切割了啥，都回复保存的
    CGContextSaveGState(context);

    CGContextClipToRect(context, CGRectMake(0, 0, 100, 200));
    //定义起始点和终止点
    //上下渐变，从y20-》100
    CGPoint start = CGPointMake(20, 20);
    CGPoint end = CGPointMake(20, 100);
    
    //绘制渐变, 颜色的0对应start点,颜色的1对应end点,第四个参数是定义渐变是否超越起始点和终止点
    //绘制渐变，越来越黑
    CGContextDrawLinearGradient(context, _gradient, start, end, kCGGradientDrawsBeforeStartLocation);
    
    //辐射渐变
    start = CGPointMake(100, 80);//起始点
    end = CGPointMake(100, 140); //终结点
    //辐射渐变 start:起始点 20:起始点的半径 end:终止点 40: 终止点的半径 这个辐射渐变
    //start半径为0，则中间是开始颜色，最外边为结束颜色，扩散
    CGContextDrawRadialGradient(context, _gradient, start, 0, end, 100, 0);
    
    CGContextRestoreGState(context);

    
    for (int i = 0; i < 4; i ++) {
        
        CGContextSetRGBStrokeColor(context, 0, 0, 0.5, 1);
        CGContextSetLineWidth(context, 2);
        //画一个椭圆或者圆
        CGContextStrokeEllipseInRect(context, CGRectMake(0+100*i,500, 60, 60));
        
        //stroke画线就用这个，填充就用DrawPath(context, kCGPathFillStroke);
        
        CGContextSetLineWidth(context, 0);
        CGContextSetRGBFillColor(context, 0, 0, 0.5, 1);
        //偏移量，虚化
        CGContextSetShadowWithColor(context, CGSizeMake(10.0f, 10.0f), 2.0f, [[UIColor grayColor] CGColor]); //compare as below

        //画笔起始位置
        CGContextMoveToPoint(context, 100*i+30, 500+30);
        //这是画弧的
        CGContextAddArc(context, 100*i+30, 500+30, 26, 0, M_PI*(i+1)/3, NO);
        //画弧和切线
        //CGContextAddArcToPoint
        CGContextDrawPath(context, kCGPathFillStroke);

    }
    
    
    
    //1.UIGraphicsGetCurrentContext，取得画布
    //2.设置画笔，填充色，线宽，线型
    //3.设置路径，画的方式，填充否，CGContextAddLines，添加折线，起始端连接端样式，线型，画
    //4.画椭圆，圆，弧，CGContextAddEllipseInRect，    CGContextAddArcToPoint(context, p[1].x, p[1].y, p[2].x, p[2].y, 20);
    //先CGContextMoveToPoint
    
    //5. 贝塞尔曲线，CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    //UIKit，Core Animation 左上角起点系统，CoreGraphics左下角起点系统
    //6. 画图形，UIGraphicsBeginImageContext ，CGContextDrawImage(context, imageRect, [UIImage imageNamed:@"20141203111310747"].CGImage);
    //7.创建渐变，用颜色数组， CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    //CGContextDrawLinearGradient 线性变化，CGContextDrawRadialGradient，辐射变化
    //8.CGContextStrokeEllipseInRect，先画圆，
    //zk，你么的这不是可以画饼状图么。矩形可以画柱状图，还能渐变
    //再画扇形，CGContextMoveToPoint(context, 100*i+30, 500+30);
    //CGContextAddArc(context, 100*i+30, 500+30, 26, 0, M_PI*(i+1)/3, NO);
    //CGContextDrawPath(context, kCGPathFillStroke);填充扇形
    //9.        //偏移量，虚化
    //CGContextSetShadowWithColor(context, CGSizeMake(10.0f, 10.0f), 2.0f, [[UIColor grayColor] CGColor]); //compare as below
}




//如果要点击，可以touch判断 frame都存数组里， cgrectcontainpoint，处理

@end
