#import <UIKit/UIKit.h>


@interface ViewController : UIViewController
{
	IBOutlet UITextField *addrField;
	IBOutlet UITextField *portField;
	IBOutlet UITextField *messageField;
	IBOutlet UIWebView *webView;
    IBOutlet UIImageView *imageView;

}

- (IBAction)send:(id)sender;

@end
