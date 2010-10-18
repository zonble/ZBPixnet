#import "ZBPixnetAPI.h"
#import "ZBPixnetAPI+Private.h"

static ZBPixnetAPI *sharedAPI;

NSString *const kPixetAPIURL = @"http://emma.pixnet.cc/";

NSString *const ZBPixnetAPILoginNotification = @"ZBPixnetAPILoginNotification";
NSString *const ZBPixnetAPILogoutNotification = @"ZBPixnetAPILogoutNotification";


@implementation ZBPixnetAPI

+ (ZBPixnetAPI *)sharedAPI
{
	if (!sharedAPI) {
		sharedAPI = [[ZBPixnetAPI alloc] initWithPrefix:nil consumerKey:nil secret:nil];
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
	[prefix release];
	
	[super dealloc];
}

- (id)initWithPrefix:(NSString *)inPrefix consumerKey:(NSString *)inKey secret:(NSString *)inSecret
{
	self = [super init];
	if (self != nil) {
		prefix = [inPrefix retain];
		fetchQueue = [[NSOperationQueue alloc] init];
		[self setConsumerKey:inKey secret:inSecret];
	}
	return self;
}
- (void)setConsumerKey:(NSString *)inKey secret:(NSString *)inSecret
{
	id tmp = consumer;
	consumer = [[OAConsumer alloc] initWithKey:inKey secret:inSecret];
	NSDictionary *appInfo = [[NSBundle bundleForClass:[self class]] infoDictionary];
	NSString *appName = [appInfo valueForKey:@"CFBundleName"];
	NSString *appIdentifier = [appInfo valueForKey:@"CFBundleIdentifier"];
	if ([prefix length]) {
		appIdentifier = prefix;
	}
	OAToken *aToken = [[[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:appName prefix:appIdentifier] autorelease];
	if (![aToken hasExpired]) {
		self.accessToken = aToken;
	}
	[tmp release];
}

#pragma mark -
#pragma mark Login and OAuth

- (void)loginWithController:(UIViewController *)controller
{
	self.currentViewController = controller;
	[self fetchRequestToken];
}

- (void)logout
{
	self.accessToken = nil;
	self.requestToken = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:ZBPixnetAPILogoutNotification object:self];	
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
