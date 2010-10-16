#import "ZBPixnetAPI.h"
#import "ZBPixnetAPI+Private.h"
#import "APIKey.h"

static ZBPixnetAPI *sharedAPI;

NSString *const kPixetAPIURL = @"http://emma.pixnet.cc/";

NSString *const ZBPixnetAPILoginNotification = @"ZBPixnetAPILoginNotification";
NSString *const ZBPixnetAPILogoutNotification = @"ZBPixnetAPILogoutNotification";


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
		NSDictionary *appInfo = [[NSBundle bundleForClass:[self class]] infoDictionary];
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
#pragma mark Properties

- (BOOL)isLoggedIn
{
	if (self.accessToken) {
		return ![self.accessToken hasExpired];
	}
	return NO;
}

@synthesize currentViewController;
@synthesize requestToken;
@synthesize accessToken;

@end
