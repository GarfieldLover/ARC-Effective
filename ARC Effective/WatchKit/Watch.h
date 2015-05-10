//
//  Watch.h
//  ARC Effective
//
//  Created by zhangke on 15/5/10.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//


//明天看lister，就明白很大一部分了，看下glances吧
//再看看真机


//WatchKit 结构体系
//1.iOS app里安装了Extension，Extension包含了WatchKit app，watchkit被安装在了watch中，只负责显示和输入
//wk app 和 extension 交互，是通过wk进行，wkapp只有 storyboard和 resources，所有执行的事都要extension处理

//appid Group，extension 也要选择刚才的group，extension设置AppBundleIdentifier， wk app 设置CompanionAppBundleIdentifier

//开始开发，分成3种类型：glances，Notifications，Watch App

//Watch App的UI都在storyboard里，代码在extension，
//Controller都继承与WKInterfaceController，WKInterfaceButton xxx都继承于WKInterfaceObject，相当于UIView

//WatchKit
//UIKit
//WKInterfaceController
//UIViewController
//WKUserNotificationInterfaceController
//UIApplicationDelegate + UIAlertController
//WKInterfaceDevice
//UIDevice
//WKInterfaceObject
//UIView
//WKInterfaceButton
//UIButton
//WKInterfaceDate
//UILabel + NSDateFormatter
//WKInterfaceGroup
//UIScrollView
//WKInterfaceImage
//UIImageView
//WKInterfaceLabel
//UILabel
//WKInterfaceMap
//MKMapView
//WKInterfaceSeparator
//UITableView.separatorColor / .separatorStyle
//WKInterfaceSlider
//UIStepper + UISlider
//WKInterfaceSwitch
//UISwitch
//WKInterfaceTable
//UITableView
//WKInterfaceTimer
//UILabel + NSDateFormatter + NSTimer


//1.图片资源在WatchKit App中。 对于这种情况， Extension和WatchApp之间只需要传输很少量的数据：传输的是图片资源的名字而已。 在WatchApp中的WatchKit收到这个名字后会在包中寻找同名文件并自动加载显示。
//[_watchImage setImageNamed:@"AppleImage.png"];
//zk  调用只是传输给watchkit名字


//2.如果图片在Extension中，那流程会稍微复杂些，一行代码变成了两行：
//UIImage* image = [UIImage imageNamed:@"AppleRainbow.png"];
//[_watchImage setImage:image];
//传输的是图片过去


//－－－－－－》通信
//3.从iOS App中拿到一系列的图片资源并在WatchKit App中播放动画。
//由Extension发起请求，在代码中发起 openParentApplication，和iosapp 通信，+ (BOOL)openParentApplication:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo, NSError *error)) reply;
//
//ios app handleExtensionRequest，返回imageData
//- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
//NSData* imageData = [NSKeyedArchiver archivedDataWithRootObject:marray];
//
//wk app setimage ------------> 但是extension和wk app通信用的蓝牙，速度很慢
//[_watchImage setImage:image];

//setImageNamed，在可以实现组，startAnimatingWithImagesInRange可以播放帧动画
[self.glanceBadgeImage startAnimatingWithImagesInRange:glanceBadge.imageRange duration:glanceBadge.animationDuration repeatCount:1];
//[_WatchImage startAnimatingWithImagesInRange:range duration:4.0f repeatCount:1];
//可以放到wk app里一些缓存图片
addCachedImage: name:


//openParentApplication，只能主动获取数据，
//－－－－－》使用CFNotificationCenter 互相lister
//extension和ios app互相lister，就是addobserver， 需要__bridge转化

CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
CFStringRef str = (__bridge CFStringRef)identifier;
CFNotificationCenterAddObserver(center,
                                (__bridge const void *)(self),
                                wormholeNotificationCallback,
                                str,
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
//如果有数据变化，再解析，就能得到数据
CFNotificationCenterPostNotification(center, str, NULL, userInfo, deliverImmediately);


//UI, table（里用group），image，separator，button，switch，slider，label，date，map等
//布局：才用行布局，用Group也可以水平布局，也可以通过（relative to container）width或height，实现水平布局，

menu
//[self addMenuItemWithItemIcon:WKMenuItemIconDecline title:@"取消" action:@selector(cancel)];

//导航，还是push和present
- (void)pushControllerWithName:(NSString *)name context:(id)context;  //
- (void)presentControllerWithName:(NSString *)name context:(id)context; //

//生命周期，awake，activate，deactivate，－》didiload，willapper，diddisapaer
- (void)awakeWithContext:(id)context
- (void)willActivate;      // Called when watch interface is visible to user
- (void)didDeactivate;     // Called when watch interface is no longer



//glances，也和app差不多吧，请求数据去

//浏览页面，放点头条啥的，启动页面
//创建Watch App 的时候可以直接勾选上Glance，也可以在之后的开发中创建一个Glance 界面
//在登陆watch app 的登陆序列中去寻找actionForUserActivity:context:这个方法去找到具体是哪一个controller去显示内容，会根据这个控制器唯一的名字去找，然后呈现



//Notifications，远程和本地
长版本，分为，appcontent，app cation， dismiss

//添加action，注册按钮

//func registerSettingsAndCategories() {
//    var categories = NSMutableSet()
//    
//    var acceptAction = UIMutableUserNotificationAction()
//    acceptAction.title = NSLocalizedString("Accept", comment: "Accept invitation")
//    acceptAction.identifier = "accept"
//    acceptAction.activationMode = UIUserNotificationActivationMode.Background
//    acceptAction.authenticationRequired = false
//    
//    var declineAction = UIMutableUserNotificationAction()
//    declineAction.title = NSLocalizedString("Decline", comment: "Decline invitation")
//    declineAction.identifier = "decline"
//    declineAction.activationMode = UIUserNotificationActivationMode.Background
//    declineAction.authenticationRequired = false
//    
//    var inviteCategory = UIMutableUserNotificationCategory()
//    inviteCategory.setActions([acceptAction, declineAction],
//                              forContext: UIUserNotificationActionContext.Default)
//    inviteCategory.identifier = "invitation"
//    
//    categories.addObject(inviteCategory)
//    
//    // Configure other actions and categories and add them to the set...
//    var settings = UIUserNotificationSettings(forTypes: (.Alert | .Badge | .Sound),
//                                              categories: categories)
//    
//    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//}


//获取到通知，设置显示的内容
//application:handleActionWithIdentifier:forRemoteNotification:completionHandler:
//
//[self.notesLabel setText:notesString];


//handle 就会调 自定义的通知界面，Default 就是静态，静态好像也能设置，娘的
//completionHandler(WKUserNotificationInterfaceTypeCustom);
//看到最后调用的是WKUserNotificationInterfaceTypeCustom这个实例，如果采用 WKUserNotificationInterfaceTypeDefault则会呈现静态的通知界面。





