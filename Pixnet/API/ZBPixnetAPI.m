#import "ZBPixnetAPI.h"
#import "APIKey.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"

static ZBPixnetAPI *sharedAPI;

static NSString *const kRequestTokenURL = @"http://emma.pixnet.cc/oauth/request_token";
static NSString *const kRequestAuthorizeURL = @"http://emma.pixnet.cc/oauth/authorize";
static NSString *const kAccessTokenURL = @"http://emma.pixnet.cc/oauth/access_token";

static NSString *const kPixetAPIURL = @"http://emma.pixnet.cc/";
static NSString *const kAccount = @"account";
static NSString *const kUserInfo = @"users/%@";

NSString *const ZBPixnetAPILoginNotification = @"ZBPixnetAPILoginNotification";
NSString *const ZBPixnetAPILogoutNotification = @"ZBPixnetAPILogoutNotification";

@interface ZBPixnetAPI (Private) <ZBLoginWebViewControllerDelegate>
- (void)fetchRequestToken;
- (void)fetchAccessTokenWithVerifier:(NSString *)inVerifier;
- (void)doFetchWithPath:(NSString *)path method:(NSString *)method delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector HTTPBody:(NSData *)HTTPBody;
@end

@implementation ZBPixnetAPI

+ (ZBPixnetAPI *)sharedAPI
{
	if (!sharedAPI) {
		sharedAPI = [[ZBPixnetAPI alloc] init];
	}
	return sharedAPI;
}

- (void)dealloc
{
	[consumer release];
	[requestToken release];
	[accessToken release];
	[currentViewController release];
	[fetchQueue release];
	
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		consumer = [[OAConsumer alloc] initWithKey:CONSUMER_KEY secret:CONSUMER_SECRET];
		NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
		NSString *appName = [appInfo valueForKey:@"CFBundleName"];
		NSString *appIdentifier = [appInfo valueForKey:@"CFBundleIdentifier"];		
		OAToken *aToken = [[[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:appName prefix:appIdentifier] autorelease];
		if (![aToken hasExpired]) {
			self.accessToken = aToken;
		}
		fetchQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}

#pragma mark -
#pragma mark Login and OAuth

- (void)logout
{
	self.accessToken = nil;
	self.requestToken = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:ZBPixnetAPILogoutNotification object:self];	
}

- (void)loginWithController:(UIViewController *)controller
{
	self.currentViewController = controller;
	[self fetchRequestToken];
}

#pragma mark -

- (void)fetchAccountInfoWithDelegate:(id)delegate
{
	[self doFetchWithPath:kAccount method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAccountInfo:) didFailSelector:@selector(API:didFailFetchingAccountInfo:) HTTPBody:nil];	
}

- (void)fetchUserInfoWithUserID:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSString *path = [NSString stringWithFormat:kUserInfo, [userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchUserInfo:) didFailSelector:@selector(API:didFailFetchingUserInfo:) HTTPBody:nil];	
}


#pragma mark -
#pragma mark Properties

- (BOOL)isLoggedIn
{
	if (self.accessToken) {
		return YES;
	}
	return NO;
}

@synthesize currentViewController;
@synthesize requestToken;
@synthesize accessToken;

@end

#pragma mark -

@implementation ZBPixnetAPI (Private)

- (void)fetchRequestToken
{
	NSURL *URL = [NSURL URLWithString:kRequestTokenURL];
	
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:URL consumer:consumer token:nil realm:nil signatureProvider:nil] autorelease];
    [request setHTTPMethod:@"POST"];
	ZBFetchOperation *operation = [[ZBFetchOperation alloc] init:request delegate:self didFinishSelector:@selector(requestTokenTicket:didFinishWithData:) didFailSelector:@selector(requestTokenTicket:didFailWithError:) userInfo:nil];
	[fetchQueue addOperation:operation];
	[operation autorelease];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) {
		NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		OAToken *token = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
		self.requestToken = token;
		NSArray *parts = [responseBody componentsSeparatedByString:@"&"];
		NSString *authURLString = nil;
		for (NSString *part in parts) {
			if ([part hasPrefix:@"xoauth_request_auth_url="]) {
				authURLString = [[part substringFromIndex:[@"xoauth_request_auth_url=" length]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				break;
			}
		}
		
		if (self.currentViewController && authURLString) {
			ZBLoginWebViewController *webController = [[ZBLoginWebViewController alloc] init];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webController];
			[self.currentViewController presentModalViewController:navController animated:YES];
			webController.delegate = self;
			[webController openURL:[NSURL URLWithString:authURLString]];
			[webController release];
			[navController release];
		}
	}
	else {
		NSError *error = nil;
		if (self.currentViewController && [self.currentViewController respondsToSelector:@selector(API:didFailFetchingRequestToken:)]) {
			[self.currentViewController API:self didFailFetchingRequestToken:error];
		}		
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	if (self.currentViewController && [self.currentViewController respondsToSelector:@selector(API:didFailFetchingRequestToken:)]) {
		[self.currentViewController API:self didFailFetchingRequestToken:error];
	}
}

#pragma mark -

- (void)fetchAccessTokenWithVerifier:(NSString *)inVerifier
{
	NSString *URLString = [NSString stringWithFormat:@"%@?oauth_verifier=%@", kAccessTokenURL, inVerifier];
	NSURL *URL = [NSURL URLWithString:URLString];
	
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:URL consumer:consumer token:self.requestToken realm:nil signatureProvider:nil] autorelease];
    [request setHTTPMethod:@"GET"];
	ZBFetchOperation *operation = [[ZBFetchOperation alloc] init:request delegate:self didFinishSelector:@selector(accessTokenTicket:didFinishWithData:) didFailSelector:@selector(accessTokenTicket:didFailWithError:) userInfo:nil];
	[fetchQueue addOperation:operation];
	[operation autorelease];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) {
		NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		OAToken *token = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
		self.accessToken = token;
		
		NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
		NSString *appName = [appInfo valueForKey:@"CFBundleName"];
		NSString *appIdentifier = [appInfo valueForKey:@"CFBundleIdentifier"];		
		[accessToken storeInUserDefaultsWithServiceProviderName:appName prefix:appIdentifier];
		
		if (self.currentViewController && [self.currentViewController respondsToSelector:@selector(APIDidLogin:)]) {
			[self.currentViewController APIDidLogin:self];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:ZBPixnetAPILoginNotification object:self];
	}
	else {
		NSError *error = nil;
		if (self.currentViewController && [self.currentViewController respondsToSelector:@selector(API:didFailFetchingAccessToken:)]) {
			[self.currentViewController API:self didFailFetchingAccessToken:error];
		}		
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	if (self.currentViewController && [self.currentViewController respondsToSelector:@selector(API:didFailFetchingAccessToken:)]) {
		[self.currentViewController API:self didFailFetchingAccessToken:error];
	}	
}

#pragma mark -

- (void)doFetchWithPath:(NSString *)path method:(NSString *)method delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector HTTPBody:(NSData *)HTTPBody
{
	NSString *URLString = [NSString stringWithFormat:@"%@%@", kPixetAPIURL, path];
	NSURL *URL = [NSURL URLWithString:URLString];
	OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:URL consumer:consumer token:self.accessToken realm:nil signatureProvider:nil] autorelease];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromSelector(didFinishSelector), @"didFinishSelector", NSStringFromSelector(didFailSelector), @"didFailSelector", delegate, @"delegate", nil];
	[request setHTTPMethod:method];
	[request setHTTPBody:HTTPBody];
	ZBFetchOperation *operation = [[ZBFetchOperation alloc] init:request delegate:self didFinishSelector:@selector(pixnetAPITicket:didFinishWithData:) didFailSelector:@selector(pixnetAPITicket:didFailWithError:) userInfo:userInfo];
	[fetchQueue addOperation:operation];
	[operation autorelease];	
}

- (void)pixnetAPITicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	NSDictionary *userInfo = ticket.userInfo;
	id <ZBPixnetAPIDelegate> delegate = [userInfo valueForKey:@"delegate"];
	SEL didFinishSelector = NSSelectorFromString([userInfo valueForKey:@"didFinishSelector"]);
	NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *d = [NSDictionary dictionaryWithJSONString:s];
	
	if ([delegate respondsToSelector:didFinishSelector]) {
		[delegate performSelector:didFinishSelector withObject:self withObject:d];
	}
}

- (void)pixnetAPITicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSDictionary *userInfo = ticket.userInfo;
	id <ZBPixnetAPIDelegate> delegate = [userInfo valueForKey:@"delegate"];
	SEL didFailSelector = NSSelectorFromString([userInfo valueForKey:@"didFailSelector"]);
	if ([delegate respondsToSelector:didFailSelector]) {
		[delegate performSelector:didFailSelector withObject:self withObject:error];
	}	
}

#pragma mark -
#pragma mark ZBWebView delegate methods

- (void)loginWebViewController:(ZBLoginWebViewController *)inController didFetchKey:(NSString *)inKey verifier:(NSString *)inVerifier
{
	[self fetchAccessTokenWithVerifier:inVerifier];
}
- (void)loginWebViewControllerDidCancel:(ZBLoginWebViewController *)inController
{
	if (self.currentViewController && [self.currentViewController respondsToSelector:@selector(APIUserDidCancelLoggingin:)]) {
		[self.currentViewController APIUserDidCancelLoggingin:self];
	}	
}


@end
