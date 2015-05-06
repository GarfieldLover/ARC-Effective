#import <UIKit/UIKit.h>

@class ConnectTestViewController;
@class GCDAsyncSocket;


@interface ConnectTestAppDelegate : NSObject <UIApplicationDelegate,UIWebViewDelegate>
{
	GCDAsyncSocket *asyncSocket;
    int tagnum;
    NSMutableString *log;

}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ConnectTestViewController *viewController;
-(IBAction)send:(id)sender;

@end
