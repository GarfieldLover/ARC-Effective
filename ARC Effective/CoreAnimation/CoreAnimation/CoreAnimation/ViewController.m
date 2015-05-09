//
//  ViewController.m
//  CoreAnimation
//
//  Created by zhangke on 15/5/9.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"

#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)

@interface ViewController (){
    CALayer* imageLayer;
    
    UIBezierPath* pacmanOpenPath;
    UIBezierPath* pacmanClosedPath;

    CAShapeLayer* shapeLayer;
    
    CALayer* runImageLayer;
    NSMutableArray* _images;
    int _index;

}

@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) UIView* blueView;
@property (nonatomic,strong) UIView* greenView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self animationInit];

# if 0
    //框架架构
    //UIKit－》CoreAnimation－》OpenGLES，CoreGraphics－》GPU，CPU
    //GPUImage，毛玻璃效果
    
    //1.画图形，炫动画效果
    //2.轻量级，多个图层，显示不同效果
    //3.高效，对OpenGL ES的封装，高性能
    
    
    //OC语法
    //CALayer，图层类，所有layer的父类
    //－》anchorPoint、 position
    //就是cocos2d里的anchorPoint 安哥Point，锚点，图钉
    //在该示例中,anchorPoint 默认值为(0.5,0.5),位于图层的中心点。图层的 position 值为(100.0,100.0),bounds 为(0.0,0.0,120,80.0)。通过计算得到图层的 frame为(40.0,60.0,120.0,80.0)。
    //anchorPoint 属性值被设置为(0.0,0.0)，图层的 frame 值同样为(40.0,60.0,120.0,80.0),bounds 的值不变,但是图层的 position 值已经改变为(40.0,60.0)。
    //旋转，拉伸，position为锚点值，
    
    
//    anchorPoint	和中心点position重合的一个点，称为“锚点”，锚点的描述是相对于x、y位置比例而言的默认在图像中心点(0.5,0.5)的位置	是
//    backgroundColor	图层背景颜色	是
//    borderColor	边框颜色	是
//    borderWidth	边框宽度	是
//    bounds	图层大小	是
//    contents	图层显示内容，例如可以将图片作为图层内容显示	是
//    contentsRect	图层显示内容的大小和位置	是
//    cornerRadius	圆角半径	是
//    doubleSided	图层背面是否显示，默认为YES	否
//    frame	图层大小和位置，不支持隐式动画，所以CALayer中很少使用frame，通常使用bounds和position代替	否
//    hidden	是否隐藏	是
//    mask	图层蒙版	是
//    maskToBounds	子图层是否剪切图层边界，默认为NO	是
//    opacity	透明度 ，类似于UIView的alpha	是
//    position	图层中心点位置，类似于UIView的center	是
//    shadowColor	阴影颜色	是
//    shadowOffset	阴影偏移量	是
//    shadowOpacity	阴影透明度，注意默认为0，如果设置阴影必须设置此属性	是
//    shadowPath	阴影的形状	是
//    shadowRadius	阴影模糊半径	是
//    sublayers	子图层	是
//    sublayerTransform	子图层形变	是
//    transform	图层形变

    //CAAnimation，动画类父类，mediatiming和caaction协议，实现各种动画， 是cocoa动画的基础
    //CAMediaTiming，动画持续时间，速度，重复等 repeatCount, repeatDuration，speed，move到哪，时间，速度等
    //caaction，move，scale，opacity，等 group加在一起播放 CAAnimationGroup
    
    //CATransaction（事务）, 修改都需要事务，更新显示

    //CADisplayLink，定时器，界面显示帧更新
    //CAMediaTimingFUnction，动画执行步调，Linear，EaseIn，EaseOut，线性，缓入，缓出
    
    //CAAnimation接受CAMediaTiming协议，有CAAnimationGroup，CATransaction，CAPropertyAnimation 等基本动画类
    //CAPropertyAnimation 设置path
    //CABaseAnimation，设置fromValue，toValue
    
    //UIView都有一个根CALayer，UIView在layer上绘制，layer的属性
    //size，position，backcolor，context，radius，corner，shadow。
    
    //*****zk   定义时钟对象,添加到runloop中，1秒60次。判断1秒刷新10次， 到这一次时换layer的contents，感觉就是在轮播图片了
    //runImageLayer.contents=(id)image.CGImage;//更新图片

//    CADisplayLink *displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
//    //添加时钟对象到主运行循环
//    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //layer也是调CoreGrapihcs画的，底层是CG
    self.view.layer.backgroundColor=[UIColor orangeColor].CGColor;
    self.view.layer.cornerRadius=100;
    
    CALayer* sublayer=[CALayer layer];
    //画个矩形，填充色是backgroundColor
    sublayer.backgroundColor=[UIColor purpleColor].CGColor;
    sublayer.shadowColor=[UIColor blackColor].CGColor;
    sublayer.shadowOffset=CGSizeMake(10, 10);
    sublayer.shadowRadius=5;
    sublayer.shadowOpacity=0.6;
    sublayer.frame=CGRectMake(30, 50, 200, 200);
    //我擦，全都能对应到CG里的函数，完全就是转换成CG画的
    //CGContextSetLineWidth
    //CGContextSetRGBStrokeColor
    //CGContextAddArcToPoint
    sublayer.borderWidth=2;
    sublayer.borderColor=[UIColor blackColor].CGColor;
    sublayer.cornerRadius=10.0;
    [self.view.layer addSublayer:sublayer];

    imageLayer=[CALayer layer];
    imageLayer.frame=sublayer.bounds;
    imageLayer.cornerRadius=10;
    //必须是cgimage，CG框架里的
    imageLayer.contents=(__bridge id)[UIImage imageNamed:@"A3DFC8D23566E7949F4CC392143A5469.png"].CGImage;
    imageLayer.masksToBounds=YES;
    [sublayer addSublayer:imageLayer];
    //应该是按照添加顺序绘制，后添加的后绘制，就在上边
    
    //必定是调coreGraphics画的啊，GPU一个像素一个像素设置色值吧
    //CGContextSetShadowWithColor(context, CGSizeMake(10.0f, 10.0f), 2.0f, [[UIColor grayColor] CGColor]); //compare as below
    
    
    CALayer *customDrawn = [CALayer layer];
    customDrawn.delegate = self;
    customDrawn.backgroundColor = [UIColor greenColor].CGColor;
    customDrawn.frame = CGRectMake(30, 250, 280, 200);
    customDrawn.shadowOffset = CGSizeMake(0, 3);
    customDrawn.shadowRadius = 5.0;
    customDrawn.shadowColor = [UIColor blackColor].CGColor;
    customDrawn.shadowOpacity = 0.8;
    customDrawn.cornerRadius = 10.0;
    customDrawn.borderColor = [UIColor blackColor].CGColor;
    customDrawn.borderWidth = 2.0;
    customDrawn.masksToBounds = YES;
    [self.view.layer addSublayer:customDrawn];
    
    //setNeedsDisplay 调才会drawLayer，通过layer调
    [customDrawn setNeedsDisplay];
    
    

#endif

    
    self.blueView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.blueView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.blueView];
    
    UIImageView* image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A3DFC8D23566E7949F4CC392143A5469.png"]];
    image1.frame = CGRectMake(0, 0, 300, 300);
    [self.blueView addSubview:image1];
    
    UIImageView* image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"照片.png"]];
    image2.frame = CGRectMake(0, 0, 300, 300);
    [self.blueView addSubview:image2];
    

}



-(IBAction)action1:(id)sender
{
    CGPoint fromPoint = imageLayer.position;
    
    //曲线
    UIBezierPath* move=[UIBezierPath bezierPath];
    [move moveToPoint:fromPoint];
    CGPoint toPoint=CGPointMake(300, 500);
    [move addQuadCurveToPoint:toPoint controlPoint:CGPointMake(300, 0)];
    
    
//    animationWithKeyPath的值：
//    
//    transform.scale = 比例轉換
//    transform.scale.x = 闊的比例轉換
//    transform.scale.y = 高的比例轉換
//    transform.rotation.z = 平面圖的旋轉
//    opacity = 透明度
//    margin
//    zPosition
//    backgroundColor
//    cornerRadius
//    borderWidth
//    bounds
//    contents
//    contentsRect
//    cornerRadius
//    frame
//    hidden
//    mask
//    masksToBounds
//    opacity
//    position
//    shadowColor
//    shadowOffset
//    shadowOpacity
//    shadowRadius
    
    //动画执行关键帧
    CAKeyframeAnimation* moveAni=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAni.path=move.CGPath;
    moveAni.duration=3;
    moveAni.removedOnCompletion=YES;
    
    //旋转变化
    CABasicAnimation* scale=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    scale.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scale.removedOnCompletion=YES;
    
    //透明度变化
    CABasicAnimation* opacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue=[NSNumber numberWithFloat:1];
    opacity.toValue=[NSNumber numberWithFloat:0.1];
    opacity.removedOnCompletion=YES;
    
    //组合动画
    CAAnimationGroup* group=[CAAnimationGroup animation];
    group.animations=@[moveAni,scale,opacity];
    group.duration=3;
    [imageLayer addAnimation:moveAni forKey:nil];
    
    //imageLayer anchorPointZ
}

-(IBAction)action2:(id)sender
{
    CGPoint fromPoint = imageLayer.position;
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    CGPoint toPoint = CGPointMake(fromPoint.x +100 , fromPoint.y ) ;
    [movePath addLineToPoint:toPoint];
    
    //不更新position，就变回去了
    imageLayer.position = toPoint;
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    
    CABasicAnimation *TransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    //当前rotation
    TransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //沿Z轴旋转
    TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,0,1)];
    
//    //沿Y轴旋转
//    TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,1.0,0)];
//    //沿X轴旋转
//    TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,1.0,0,0)];
    
    TransformAnim.cumulative = YES;
    TransformAnim.duration =3;
    //旋转2遍，360度
    TransformAnim.repeatCount =2;
    TransformAnim.removedOnCompletion = YES;
    
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, TransformAnim, nil];
    animGroup.duration = 6;
    
    [imageLayer addAnimation:animGroup forKey:nil];
}

-(IBAction)action3:(id)sender
{
    //图片旋转360度
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1.0) ];
    animation.duration = 3;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    //累计旋转，pi只是180，
    animation.cumulative = YES;
    animation.repeatCount = 2;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [self.imageView.image drawInRect:CGRectMake(1,1,self.imageView.frame.size.width-2,self.imageView.frame.size.height-2)];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //把图像缩小了，边上是透明的，应该就渲染不出锯齿
    
    [self.imageView.layer addAnimation:animation forKey:nil];
}

-(IBAction)run:(id)sender
{
    runImageLayer=[CALayer layer];
    runImageLayer.frame=CGRectMake(0, 500, 98/2, 146/2);
    runImageLayer.contents=(__bridge id)[UIImage imageNamed:@"deliveryStaff0.png"].CGImage;
    [self.view.layer addSublayer:runImageLayer];
    
    _images=[NSMutableArray array];
    for (int i=1; i<4; i++) {
        NSString *imageName=[NSString stringWithFormat:@"deliveryStaff%i.png",i];
        UIImage *image=[UIImage imageNamed:imageName];
        [_images addObject:image];
    }
    
    //定义时钟对象
    CADisplayLink *displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    //添加时钟对象到主运行循环
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    CGPoint fromPoint = runImageLayer.position;
    
    UIBezierPath* move=[UIBezierPath bezierPath];
    [move moveToPoint:fromPoint];
    CGPoint toPoint=CGPointMake(400, 500+146/4);
    [move addLineToPoint:toPoint];
    
    CAKeyframeAnimation* moveAni=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAni.path=move.CGPath;
    moveAni.duration=5;
    moveAni.removedOnCompletion=YES;
    
    [runImageLayer addAnimation:moveAni forKey:nil];
}


#pragma mark 每次屏幕刷新就会执行一次此方法(每秒接近60次)
-(void)step{
    //定义一个变量记录执行次数
    static int s=0;
    //每秒执行6次
    if (++s%6==0) {
        UIImage *image=_images[_index];
        runImageLayer.contents=(id)image.CGImage;//更新图片
        _index=(_index+1)%3;
    }
}

- (void)animationInit
{
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat radius = 30.0f;
    CGFloat diameter = radius * 2;
    CGPoint arcCenter = CGPointMake(radius, radius);
    // Create a UIBezierPath for Pacman's open state
    //创建吃豆人张口的path
    pacmanOpenPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                    radius:radius
                                                startAngle:DEGREES_TO_RADIANS(35)
                                                  endAngle:DEGREES_TO_RADIANS(315)
                                                 clockwise:YES];
    
    [pacmanOpenPath addLineToPoint:arcCenter];
    [pacmanOpenPath closePath];
    
    //创建吃豆人闭口的path

    // Create a UIBezierPath for Pacman's close state
    pacmanClosedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                      radius:radius
                                                  startAngle:DEGREES_TO_RADIANS(1)
                                                    endAngle:DEGREES_TO_RADIANS(359)
                                                   clockwise:YES];
    [pacmanClosedPath addLineToPoint:arcCenter];
    [pacmanClosedPath closePath];
    
    // Create a CAShapeLayer for Pacman, fill with yellow
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    shapeLayer.path = pacmanClosedPath.CGPath;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    shapeLayer.position = CGPointMake(0, 0);
    [self.view.layer addSublayer:shapeLayer];
    //创建shapeLayer，填充，路径，画笔移某个点，然后画弧，画笔颜色，线宽，线型，
//    CGContextMoveToPoint(context, 100*i+30, 500+30);
//    CGContextAddArc
    
    SEL startSelector = @selector(startAnimation);
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:startSelector];
    [self.view addGestureRecognizer:recognizer];
}

- (void)startAnimation {
    // 创建咬牙动画
    CABasicAnimation *chompAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    chompAnimation.duration = 0.25;
    chompAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    chompAnimation.repeatCount = HUGE_VALF;
    chompAnimation.autoreverses = YES;
    // Animate between the two path values
    chompAnimation.fromValue = (id)pacmanClosedPath.CGPath;
    chompAnimation.toValue = (id)pacmanOpenPath.CGPath;
    [shapeLayer addAnimation:chompAnimation forKey:@"chompAnimation"];
    
    //路径动画，从张口到闭口，重复无数次，线性时间变化，间隔
    
    // Create digital '2'-shaped path
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    [path addLineToPoint:CGPointMake(300, 200)];
    [path addLineToPoint:CGPointMake(0, 200)];
    [path addLineToPoint:CGPointMake(0, 300)];
    [path addLineToPoint:CGPointMake(300, 300)];
    
    shapeLayer.position = CGPointMake(300, 300);
    //移动path
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = path.CGPath;
    moveAnimation.duration = 8.0f;
    // Setting the rotation mode ensures Pacman's mouth is always forward.  This is a very convenient CA feature.
    moveAnimation.rotationMode = kCAAnimationRotateAuto;
    [shapeLayer addAnimation:moveAnimation forKey:@"moveAnimation"];
    //关键动画，基本都是move，addAnimation就行了

}


-(IBAction)Transition:(id)sender
{
    //转场动画
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type =@"pageCurl";
    animation.subtype = kCATransitionFromLeft;
    //2个view交换
    animation.fillMode = kCAFillModeForwards;

    [self.blueView.layer addAnimation:animation forKey:@"animation"];

    [self.blueView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    
    
//    1.#define定义的常量
//    kCATransitionFade   交叉淡化过渡
//    kCATransitionMoveIn 新视图移到旧视图上面
//    kCATransitionPush   新视图把旧视图推出去
//    kCATransitionReveal 将旧视图移开,显示下面的新视图
//    
//    2.用字符串表示
//    pageCurl            向上翻一页
//    pageUnCurl          向下翻一页
//    rippleEffect        滴水效果
//    suckEffect          收缩效果，如一块布被抽走
//    cube                立方体效果
//    oglFlip             上下翻转效果
    
    
    //粒子效果layer，发射器
    
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);//设置发射位置，这个和emitterMode有关
    snowEmitter.emitterZPosition=50;//发射点z的位置，这个和emitterMode有关
    snowEmitter.emitterSize     = CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);//发射点的范围，这个和emitterMode有关
    snowEmitter.emitterDepth=100;
    //从线上发射
    //    snowEmitter.emitterMode        = kCAEmitterLayerOutline;
    //   snowEmitter.emitterShape    = kCAEmitterLayerLine;
    //从一个立方体内发射出，这样的话雪花会有不同的大小在3D的情况下
    snowEmitter.emitterMode      = kCAEmitterLayerVolume;
    snowEmitter.emitterShape    = kCAEmitterLayerCuboid;
    
    //设置发射单元
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    snowflake.birthRate     = 3.0;//每秒发生1个
    snowflake.lifetime      = 120.0;//生存时间为120秒
    snowflake.velocity      = 20;               //初始速度
    snowflake.velocityRange = 10;//初始速度的随机范围
    snowflake.yAcceleration = 10;//y轴加速度，当然还有z,x轴
    
    //snowflake.emissionRange = -0.5 * M_PI;        // 发射角度范围 ,这个参数一设置，似乎方向只能朝屏幕内，就是z的负轴
    
    snowflake.spin=0.0;
    snowflake.spinRange     =- 0.25 * M_PI;     // 自旋转范围
    
    snowflake.contents      = (id) [[UIImage imageNamed:@"54089B1C-C782-461A-9A87-EE520969BB8C.png"] CGImage];
    snowflake.color         = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    //snowflake.emissionLatitude=-M_PI_2;//按照Z轴旋转
    snowEmitter.preservesDepth=YES;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/300.0f;
    self.view.layer.transform=transform;
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view.layer insertSublayer:snowEmitter atIndex:11];
}


static inline double radians (double degrees) { return degrees * M_PI/180; }

void MyDrawColoredPattern (void *info, CGContextRef context) {
    
    CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
    
    CGContextSetFillColorWithColor(context, dotColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
    
    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    CGColorRef bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, layer.bounds);
    
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    //背景样式模式，按照xStep，yStep处理
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           layer.bounds,
                                           CGAffineTransformIdentity,
                                           24,
                                           24,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, layer.bounds);
    CGContextRestoreGState(context);
}









@end
