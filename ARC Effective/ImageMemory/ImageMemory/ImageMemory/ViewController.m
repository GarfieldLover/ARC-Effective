//
//  ViewController.m
//  ImageMemory
//
//  Created by zhangke on 15/5/19.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //在IOS上，图片会被自动缩放到2的N次方大小。比如一张1024*1025的图片，占用的内存与一张1024*2048的图片是一致的。图片占用内存大小的计算的公式是；长*宽*4。这样一张512*512 占用的内存就是 512*512*4 = 1M。其他尺寸以此类推。（ps:IOS上支持的最大尺寸为2048*2048）。
    
    //coreImage，bitmap研究
    
    //字面量语法应该没有引用计数，copy到堆上才会有计数，所以打印计数为超大值
    //只要是使用返回新值api，就会去判断是否是字面量语法，copy一份到堆上
    NSString* string=@"ddd";
    NSString* news= [string substringFromIndex:1];
    
    NSMutableArray* array=[NSMutableArray new];
    //没有计算的bitmap那么大，，，
    
    for(int i=0;i<10;i++){
        UIImage* image=[UIImage imageNamed:@"Snip20150503_2.png"];
        [array addObject:image];
        UIImageView* view=[UIImageView new];
        view.frame=CGRectMake(0, 0, image.size.width, image.size.height);
        view.image=image;
        [self.view addSubview:view];
        
        //只要渲染了 肯定就大了
        
//        UIImage* image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Snip20150503_2" ofType:@"png"]];
//        NSData* data=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Snip20150503_2" ofType:@"png"]];
//        UIImage* image=[UIImage imageWithData:data];
    }
    
//    NSData* jpgdata=UIImageJPEGRepresentation(image, 1.0);
//    
//    NSData* pngdata=UIImagePNGRepresentation(image);
    
    
    
    //width x height x 4
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
