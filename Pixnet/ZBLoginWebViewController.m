//
//  ZBLoginWebViewController.m
//  PartRetard
//

#import "ZBLoginWebViewController.h"


@implementation ZBLoginWebViewController

- (void)removeOutletsAndControls_ZBLoginWebViewController
{
	self.webView = nil;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_ZBLoginWebViewController];
}

- (void)dealloc 
{
	[self removeOutletsAndControls_ZBLoginWebViewController];
	delegate = nil;
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *aView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	aView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view = aView;
	[aView release];
	
	webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.title = @"Login";

	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doneAction:)];
	self.navigationItem.leftBarButtonItem = doneItem;
	[doneItem release];

	UIBarButtonItem *retryItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStyleBordered target:self action:@selector(retryAction:)];
	self.navigationItem.rightBarButtonItem = retryItem;
	[retryItem release];
	

}
- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Instance methods

- (void)openURL:(NSURL *)URL
{
	self.loginURL = URL;
	[webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

#pragma mark -
#pragma mark Interface Builder actions

- (IBAction)doneAction:(id)sender
{
	if (delegate && [delegate respondsToSelector:@selector(loginWebViewControllerDidCancel:)]) {
		[delegate loginWebViewControllerDidCancel:self];
	}	
	[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)retryAction:(id)sender
{
	[webView loadRequest:[NSURLRequest requestWithURL:self.loginURL]];
}
	

#pragma mark -

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL *URL = [request URL];
	NSString *URLString = [URL absoluteString];
	if ([URLString hasPrefix:@"api://callback?"]) {
		URLString = [URLString substringFromIndex:[@"api://callback?" length]];
		NSString *aKey = nil;
		NSString *aVerifier = nil;
		NSArray *pairs = [URLString componentsSeparatedByString:@"&"];
		
		for (NSString *pair in pairs) {
			NSArray *elements = [pair componentsSeparatedByString:@"="];
			if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token"]) {
				aKey = [elements objectAtIndex:1];
			} else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
				aVerifier = [elements objectAtIndex:1];
			} 
		}
		if (delegate && [delegate respondsToSelector:@selector(loginWebViewController:didFetchKey:verifier:)]) {
			[delegate loginWebViewController:self didFetchKey:aKey verifier:aVerifier];
		}		
		[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
		return NO;
	}
	return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
}

#pragma mark -
#pragma mark Properties

@synthesize delegate;
@synthesize webView;
@synthesize loginURL;

@end
