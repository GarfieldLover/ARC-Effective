#import "ConnectTestAppDelegate.h"
#import "ConnectTestViewController.h"
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_INFO;

#define USE_SECURE_CONNECTION 0
#define ENABLE_BACKGROUNDING  0

#if USE_SECURE_CONNECTION
  #define HOST @"www.paypal.com"
  #define PORT 443
#else
  #define HOST @"192.168.2.22"
  #define PORT 1234
#endif
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

@implementation ConnectTestAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Application Lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
	if ((self = [super init]))
	{
		// Setup logging framework
		[DDLog addLogger:[DDTTYLogger sharedInstance]];
	}
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	DDLogInfo(@"%@", THIS_METHOD);
	
	// Setup our socket (GCDAsyncSocket).
	// The socket will invoke our delegate methods using the usual delegate paradigm.
	// However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
	// 
	// Now we can configure the delegate dispatch queue however we want.
	// We could use a dedicated dispatch queue for easy parallelization.
	// Or we could simply use the dispatch queue for the main thread.
	// 
	// The best approach for your application will depend upon convenience, requirements and performance.
	// 
	// For this simple example, we're just going to use the main thread.
	
	dispatch_queue_t mainQueue = dispatch_get_main_queue();
	
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    [asyncSocket setAutoDisconnectOnClosedReadStream:NO];

	#if USE_SECURE_CONNECTION
	{
		NSString *host = HOST;
		uint16_t port = PORT;
		
		DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
		self.viewController.label.text = @"Connecting...";
		
		NSError *error = nil;
		if (![asyncSocket connectToHost:@"www.paypal.com" onPort:port error:&error])
		{
			DDLogError(@"Error connecting: %@", error);
			self.viewController.label.text = @"Oops";
		}
	}
	#else
	{
		NSString *host = HOST;
		uint16_t port = PORT;
		
		DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
		self.viewController.label.text = @"Connecting...";
		
		NSError *error = nil;
		if (![asyncSocket connectToHost:host onPort:port error:&error])
		{
			DDLogError(@"Error connecting: %@", error);
			self.viewController.label.text = @"Oops";
		}

		// You can also specify an optional connect timeout.
		
	//	NSError *error = nil;
	//	if (![asyncSocket connectToHost:host onPort:80 withTimeout:5.0 error:&error])
	//	{
	//		DDLogError(@"Error connecting: %@", error);
	//	}
		
	}
	#endif
	
	// Add the view controller's view to the window and display.
	[self.window addSubview:self.viewController.view];
	[self.window makeKeyAndVisible];
    
    [self.viewController.button addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    log=[NSMutableString string];
	return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)sender
{
    NSString *scrollToBottom = @"window.scrollTo(document.body.scrollWidth, document.body.scrollHeight);";
    
    [sender stringByEvaluatingJavaScriptFromString:scrollToBottom];
}

- (void)logError:(NSString *)msg
{
    NSString *prefix = @"<font color=\"#B40404\">";
    NSString *suffix = @"</font><br/>";
    
    [log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
    
    NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
    [self.viewController.webView loadHTMLString:html baseURL:nil];
    
}

- (void)logInfo:(NSString *)msg
{
    NSString *prefix = @"<font color=\"#6A0888\">";
    NSString *suffix = @"</font><br/>";
    
    [log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
    
    NSString *html = [NSString stringWithFormat:@"<html><body>\n%@\n</body></html>", log];
    [self.viewController.webView loadHTMLString:html baseURL:nil];
}

- (void)logMessage:(NSString *)msg
{
    self.viewController.webView.delegate=self;

    NSString *prefix = @"<font color=\"#000000\">";
    NSString *suffix = @"</font><br/>";
    
    [log appendFormat:@"%@%@%@\n", prefix, msg, suffix];
    
    NSString *html = [NSString stringWithFormat:@"<html><body>%@</body></html>", log];
    [self.viewController.webView loadHTMLString:html baseURL:nil];
}


-(IBAction)send:(id)sender
{
    
//    if([self.viewController.label.text isEqualToString: @"Connected"]){
    NSString *requestStr =[NSString stringWithFormat:@"%@\r\n",self.viewController.textField.text] ;
        NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // 可以在这里处理接受到的头部信息,tag
        [asyncSocket writeData:requestData withTimeout:-1 tag:tagnum];
    
        tagnum++;
        
        [self logMessage:FORMAT(@"SENT (%i): %@", (int)tagnum, self.viewController.textField.text)];

//    }
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
	DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
	self.viewController.label.text = @"Connected";
    

    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
    
    
    //zk,传字符串没问题，传你么的图片就根本穿不过去，只能传一点
	
//	DDLogInfo(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
	
	#if USE_SECURE_CONNECTION
	{
		// Connected to secure server (HTTPS)
		 
		#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{	
			// Backgrounding doesn't seem to be supported on the simulator yet
			
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					DDLogInfo(@"Enabled backgrounding on socket");
				else
					DDLogWarn(@"Enabling backgrounding failed!");
			}];
		}	
		#endif
		
		// Configure SSL/TLS settings
		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
		
		// If you simply want to ensure that the remote host's certificate is valid,
		// then you can use an empty dictionary.
		
		// If you know the name of the remote host, then you should specify the name here.
		// 
		// NOTE:
		// You should understand the security implications if you do not specify the peer name.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
		
		[settings setObject:@"www.paypal.com"
					 forKey:(NSString *)kCFStreamSSLPeerName];
		
		// To connect to a test server, with a self-signed certificate, use settings similar to this:
		
	//	// Allow expired certificates
	//	[settings setObject:[NSNumber numberWithBool:YES]
	//				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
	//	
	//	// Allow self-signed certificates
	//	[settings setObject:[NSNumber numberWithBool:YES]
	//				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	//	
	//	// In fact, don't even validate the certificate chain
	//	[settings setObject:[NSNumber numberWithBool:NO]
	//				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
		
		DDLogInfo(@"Starting TLS with settings:\n%@", settings);
		
		[sock startTLS:settings];
		
		// You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
		// Again, you should understand the security implications of doing so.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
		
	}
	#else
	{
		// Connected to normal server (HTTP)
		
		#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{
			// Backgrounding doesn't seem to be supported on the simulator yet
			
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					DDLogInfo(@"Enabled backgrounding on socket");
				else
					DDLogWarn(@"Enabling backgrounding failed!");
			}];
		}
		#endif
	}
	#endif
}


- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	DDLogInfo(@"socketDidSecure:%p", sock);
	self.viewController.label.text = @"Connected + Secure";
	
	NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	DDLogInfo(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
//    if(tag==0){
//        [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];

//    }

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	DDLogInfo(@"socket:%p didReadData:withTag:%ld", sock, tag);
	
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (msg)
        {
            [self logMessage:FORMAT(@"从服务端RECV: %@", msg)];
        }
    });
 // 等待接受服务器返回回来的数据 （以换行符为标志）
    [asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];

//    [sock writeData:data withTimeout:-1 tag:11111];

}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	DDLogInfo(@"socketDidDisconnect:%p withError: %@", sock, err);
	self.viewController.label.text = @"Disconnected";
}

@end
