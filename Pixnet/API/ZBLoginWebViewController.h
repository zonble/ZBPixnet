//
//  ZBLoginWebViewController.h
//  PartRetard
//

@class ZBLoginWebViewController;

@protocol ZBLoginWebViewControllerDelegate <NSObject>
@required
- (void)loginWebViewController:(ZBLoginWebViewController *)inController didFetchKey:(NSString *)inKey verifier:(NSString *)inVerifier;
- (void)loginWebViewControllerDidCancel:(ZBLoginWebViewController *)inController;
@end

@interface ZBLoginWebViewController : UIViewController <UIWebViewDelegate>
{
	id <ZBLoginWebViewControllerDelegate> delegate;
	UIWebView *webView;
	NSURL *loginURL;
}

- (void)openURL:(NSURL *)URL;
- (IBAction)doneAction:(id)sender;
- (IBAction)retryAction:(id)sender;

@property (assign, nonatomic) id <ZBLoginWebViewControllerDelegate> delegate;
@property (retain, nonatomic) UIWebView *webView;
@property (retain, nonatomic) NSURL *loginURL;

@end
