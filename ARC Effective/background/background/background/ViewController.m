//
//  ViewController.m
//  background
//
//  Created by zhangke on 15/5/18.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>{
    CLLocationManager* managerxx;
}

-(void)setxxxxx;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    managerxx=[[CLLocationManager  alloc] init];
//    [manager startMonitoringSignificantLocationChanges];
    [managerxx startUpdatingLocation];
    managerxx.delegate=self;
    managerxx.pausesLocationUpdatesAutomatically = NO;
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
//        
//    {
//        [managerxx requestAlwaysAuthorization];
//    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status

{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            //取得授权
            if ([managerxx respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [managerxx requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@",locations.firstObject);
    
    //搞不懂为什么，每秒就调一次，
    
    CLLocation* location=locations.firstObject;
    NSString* xxx=[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"111" message:xxx preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"111" style:UIAlertActionStyleCancel handler:nil]];
    [self showViewController:alert sender:nil];


}

-(void)setxxxxx
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
