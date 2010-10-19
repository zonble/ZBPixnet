#import "ZBPixnetAPI+Private.h"
#import "ZBPixnetAPI+Pixnet.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"
#import "NSMutableURLRequest+Parameters.h"
#import "OARequestParameter.h"

static NSString *const kRequestTokenURL = @"http://emma.pixnet.cc/oauth/request_token";
static NSString *const kRequestAuthorizeURL = @"http://emma.pixnet.cc/oauth/authorize";
static NSString *const kAccessTokenURL = @"http://emma.pixnet.cc/oauth/access_token";

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
		
		NSDictionary *appInfo = [[NSBundle bundleForClass:[self class]] infoDictionary];
		NSString *appName = [appInfo valueForKey:@"CFBundleName"];
		NSString *appIdentifier = [appInfo valueForKey:@"CFBundleIdentifier"];		
		if ([prefix length]) {
			appIdentifier = prefix;
		}		
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

- (void)doFetchWithPath:(NSString *)path method:(NSString *)method delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector parameters:(NSArray *)inParameters
{
	NSString *URLString = [NSString stringWithFormat:@"%@%@", kPixetAPIURL, path];
	NSURL *URL = [NSURL URLWithString:URLString];
	OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:URL consumer:consumer token:self.accessToken realm:nil signatureProvider:nil] autorelease];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromSelector(didFinishSelector), @"didFinishSelector", NSStringFromSelector(didFailSelector), @"didFailSelector", delegate, @"delegate", nil];
	[request setHTTPMethod:method];
	if ([inParameters count]) {
		[request setParameters:inParameters];
	}
	ZBFetchOperation *operation = [[ZBFetchOperation alloc] init:request delegate:self didFinishSelector:@selector(pixnetAPITicket:didFinishWithData:) didFailSelector:@selector(pixnetAPITicket:didFailWithError:) userInfo:userInfo];
	[fetchQueue addOperation:operation];
	[operation autorelease];	
}
- (void)doUploadWithPath:(NSString *)path filepath:(NSString *)filepath delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector didSendDataSelector:(SEL)didSendDataSelector parameters:(NSArray *)inParameters
{
	NSString *URLString = [NSString stringWithFormat:@"%@%@", kPixetAPIURL, path];
	NSURL *URL = [NSURL URLWithString:URLString];
	OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:URL consumer:consumer token:self.accessToken realm:nil signatureProvider:nil] autorelease];
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromSelector(didFinishSelector), @"didFinishSelector", NSStringFromSelector(didFailSelector), @"didFailSelector", NSStringFromSelector(didSendDataSelector), @"didSendDataSelector", delegate, @"delegate", filepath, @"filepath", nil];
	[request setHTTPMethod:@"POST"];
	if ([inParameters count]) {
		[request setParameters:inParameters];
	}
	NSData *data = [NSData dataWithContentsOfFile:filepath];
	[request attachFileWithName:[path lastPathComponent]  filename:[path lastPathComponent] contentType:@"image/jpeg" data:data];
	ZBFetchOperation *operation = [[ZBFetchOperation alloc] init:request delegate:self didFinishSelector:@selector(pixnetAPITicket:didFinishWithData:) didFailSelector:@selector(pixnetAPITicket:didFailWithError:) didSendDataSelector:@selector(pixnetAPIUploadProccess:userInfo:) userInfo:userInfo];
	[fetchQueue addOperation:operation];
	[operation autorelease];
}

- (void)pixnetAPITicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	NSDictionary *userInfo = ticket.userInfo;
	id <ZBPixnetAPIDelegate> delegate = [userInfo valueForKey:@"delegate"];

	NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *d = [NSDictionary dictionaryWithJSONString:s];
	if ([[d valueForKey:@"error"] boolValue]) {
		NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:[d valueForKey:@"message"], NSLocalizedDescriptionKey, nil];
		NSError *error = [NSError errorWithDomain:@"ZBPixnetErrorDomain" code:0 userInfo:errorInfo];
		SEL didFailSelector = NSSelectorFromString([userInfo valueForKey:@"didFailSelector"]);
		NSLog(@"didFailSelector:%@", [userInfo valueForKey:@"didFailSelector"]);
		if ([delegate respondsToSelector:didFailSelector]) {
			[delegate performSelector:didFailSelector withObject:self withObject:error];
		}		
		return;
	}

	SEL didFinishSelector = NSSelectorFromString([userInfo valueForKey:@"didFinishSelector"]);
	if ([delegate respondsToSelector:didFinishSelector]) {
		[delegate performSelector:didFinishSelector withObject:self withObject:d];
	}
}

- (void)pixnetAPITicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSDictionary *userInfo = ticket.userInfo;
	id <ZBPixnetAPIDelegate> delegate = [userInfo valueForKey:@"delegate"];
	SEL didFailSelector = NSSelectorFromString([userInfo valueForKey:@"didFailSelector"]);
	if ([delegate respondsToSelector:didFailSelector]) {
		[delegate performSelector:didFailSelector withObject:self withObject:error];
	}	
}
- (void)pixnetAPIUploadProccess:(NSDictionary *)process userInfo:(NSDictionary *)userInfo
{
	id <ZBPixnetAPIDelegate> delegate = [userInfo valueForKey:@"delegate"];
	SEL didSendDataSelector = NSSelectorFromString([userInfo valueForKey:@"didSendDataSelector"]);
	if ([delegate respondsToSelector:didSendDataSelector]) {
		[delegate performSelector:didSendDataSelector withObject:self withObject:process];
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