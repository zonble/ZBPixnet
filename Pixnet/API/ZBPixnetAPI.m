#import "ZBPixnetAPI.h"
#import "APIKey.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSScanner+BSJSONAdditions.h"
#import "NSMutableURLRequest+Parameters.h"
#import "OARequestParameter.h"

static ZBPixnetAPI *sharedAPI;

static NSString *const kRequestTokenURL = @"http://emma.pixnet.cc/oauth/request_token";
static NSString *const kRequestAuthorizeURL = @"http://emma.pixnet.cc/oauth/authorize";
static NSString *const kAccessTokenURL = @"http://emma.pixnet.cc/oauth/access_token";

static NSString *const kPixetAPIURL = @"http://emma.pixnet.cc/";
static NSString *const kPixnetAccount = @"account";
static NSString *const kPixnetUserInfo = @"users/%@";
static NSString *const kPixnetBlogCategories = @"blog/categories";
static NSString *const kPixnetBlogCategoriesPosition = @"blog/categories/position"; 
static NSString *const kPixnetBlogArticles = @"blog/articles";

NSString *const ZBPixnetAPILoginNotification = @"ZBPixnetAPILoginNotification";
NSString *const ZBPixnetAPILogoutNotification = @"ZBPixnetAPILogoutNotification";

@interface ZBPixnetAPI (Private) <ZBLoginWebViewControllerDelegate>
- (void)fetchRequestToken;
- (void)fetchAccessTokenWithVerifier:(NSString *)inVerifier;
- (void)doFetchWithPath:(NSString *)path method:(NSString *)method delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector parameters:(NSArray *)inParameters;
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
#pragma mark Account

- (void)fetchAccountInfoWithDelegate:(id)delegate
{
	[self doFetchWithPath:kPixnetAccount method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAccountInfo:) didFailSelector:@selector(API:didFailFetchingAccountInfo:) parameters:nil];	
}

- (void)fetchUserInfoWithUserID:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSString *path = [NSString stringWithFormat:kPixnetUserInfo, [userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchUserInfo:) didFailSelector:@selector(API:didFailFetchingUserInfo:) parameters:nil];	
}

#pragma mark Blog

- (void)fetchBlogCategoriesWithUserID:(NSString *)userID password:(NSString *)password delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if ([password length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"blog_password" value:password] autorelease]];
	}
	[self doFetchWithPath:kPixnetBlogCategories method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchBlogCategories:) didFailSelector:@selector(API:didFailFetchingBlogCategories:) parameters:parameters];	
}

- (void)createBlogCategorieWithCategoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"name" value:categoryName] autorelease]];
	if ([description length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"description" value:description] autorelease]];
	}

	if (type == ZBPixnetBlogCategoryTypeCategory) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"type" value:@"category"] autorelease]];
	}
	else if (type == ZBPixnetBlogCategoryTypeFolder) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"type" value:@"folder"] autorelease]];
	}		
	
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"show_index" value:[[NSNumber numberWithBool:visible] stringValue]] autorelease]];
	if (siteCategoryID) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"site_category_id" value:siteCategoryID] autorelease]];
	}
	[self doFetchWithPath:kPixnetBlogCategories method:@"POST" delegate:delegate didFinishSelector:@selector(API:didFetchBlogCategories:) didFailSelector:@selector(API:didFailCreatingBlogCategory:) parameters:parameters];	
}
- (void)editBlogCategoryWithID:(NSString *)categoryID categoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSString *path = [kPixnetBlogCategories stringByAppendingFormat:@"/%@", categoryID];
	
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"name" value:categoryName] autorelease]];
	if ([description length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"description" value:description] autorelease]];
	}
	
	if (type == ZBPixnetBlogCategoryTypeCategory) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"type" value:@"category"] autorelease]];
	}
	else if (type == ZBPixnetBlogCategoryTypeFolder) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"type" value:@"folder"] autorelease]];
	}		
	
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"show_index" value:[[NSNumber numberWithBool:visible] stringValue]] autorelease]];
	if (siteCategoryID) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"site_category_id" value:siteCategoryID] autorelease]];
	}
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didEditBlogCategory:) didFailSelector:@selector(API:didFailEditingBlogCategory:) parameters:parameters];	
}
- (void)deleteBlogCategoryWithID:(NSString *)categoryID type:(ZBPixnetBlogCategoryType)type delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSString *path = [kPixnetBlogCategories stringByAppendingFormat:@"/%@", categoryID];

	NSMutableArray *parameters = [NSMutableArray array];
	if (type == ZBPixnetBlogCategoryTypeCategory) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"type" value:@"category"] autorelease]];
	}
	else if (type == ZBPixnetBlogCategoryTypeFolder) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"type" value:@"folder"] autorelease]];
	}	
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didDeleteBlogCategory:) didFailSelector:@selector(API:didFailDeletingBlogCategory:) parameters:parameters];	
}
- (void)reoderBlogCategoriesWithIDArray:(NSArray *)categoryIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableString *ids = [NSMutableString string];
	for (NSString *categoryID in categoryIDArray) {
		if (![categoryID isKindOfClass:[NSString class]]) {
			if ([categoryID respondsToSelector:@selector(stringValue)]) {
				categoryID = [(id)categoryID stringValue];
			}
			else {
				continue;
			}
		}
		if (![categoryID length]) {
			continue;
		}
		[ids appendString:categoryID];
		if (![categoryID isEqual:[categoryIDArray lastObject]]) {
			[ids appendString:@","];
		}
	}
	NSArray *parameters = [NSArray arrayWithObjects:[[[OARequestParameter alloc] initWithName:@"ids" value:ids] autorelease], nil];	
	[self doFetchWithPath:kPixnetBlogCategoriesPosition method:@"POST" delegate:delegate didFinishSelector:@selector(API:didReorderBlogCategories:) didFailSelector:@selector(API:didFailReorderingBlogCategories:) parameters:parameters];	
}

#pragma mark Articles

- (void)fetchArticlesOfUser:(NSString *)userID password:(NSString *)password page:(NSUInteger)page articlesPerPage:(NSUInteger)perPage category:(NSString *)categoryID hideAuthorInfo:(BOOL)hideAuthorInfo delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if ([password length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"blog_password" value:password] autorelease]];
	}
	if (page > 1) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"page" value:[[NSNumber numberWithUnsignedInteger:page] stringValue]] autorelease]];
	}
	if (perPage && perPage != 100) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"per_page" value:[[NSNumber numberWithUnsignedInteger:perPage] stringValue]] autorelease]];
	}
	if (categoryID) {
		if (![categoryID isKindOfClass:[NSString class]]) {
			if ([categoryID respondsToSelector:@selector(stringValue)]) {
				categoryID = [(id)categoryID stringValue];
			}
		}
		if ([categoryID isKindOfClass:[NSString class]]) {
			[parameters addObject:[[[OARequestParameter alloc] initWithName:@"category_id" value:categoryID] autorelease]];
		}
	}
	if (hideAuthorInfo) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"trim_user" value:@"1"] autorelease]];		
	}
	[self doFetchWithPath:kPixnetBlogArticles method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchArticles:) didFailSelector:@selector(API:didFailFetchingArticles:) parameters:parameters];		
}
- (void)fetchArticleWithID:(NSString *)articleID user:(NSString *)userID password:(NSString *)password articlePassword:(NSString *)articlePassword delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (articleID) {
		if (![articleID isKindOfClass:[NSString class]]) {
			if ([articleID respondsToSelector:@selector(stringValue)]) {
				articleID = [(id)articleID stringValue];
			}
		}
	}	
	NSString *path = [kPixnetBlogArticles stringByAppendingFormat:@"/%@", articleID];
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if ([password length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"blog_password" value:password] autorelease]];		
	}
	if ([articlePassword length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"article_password" value:articlePassword] autorelease]];		
	}
	
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchArticle:) didFailSelector:@selector(API:didFailFetchingArticle:) parameters:parameters];
}
- (void)createArticleWithTitle:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"title" value:title] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"body" value:body] autorelease]];
	if (status) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"status" value:[[NSNumber numberWithUnsignedInteger:status] stringValue]] autorelease]];
		if (status == ZBPixnetBlogArticleStatusRequirePassword) {
			[parameters addObject:[[[OARequestParameter alloc] initWithName:@"password" value:articlePassword] autorelease]];
			[parameters addObject:[[[OARequestParameter alloc] initWithName:@"password_hint" value:hint] autorelease]];
		}
		else if (status == ZBPixnetBlogArticleStatusFriendsOnly) {
			NSMutableString *ids = [NSMutableString string];
			for (NSString *friendGroupID in friendGroupIDs) {
				if (![friendGroupID isKindOfClass:[NSString class]]) {
					if ([friendGroupID respondsToSelector:@selector(stringValue)]) {
						friendGroupID = [(id)friendGroupID stringValue];
					}
					else {
						continue;
					}
				}
				if (![friendGroupID length]) {
					continue;
				}
				[ids appendString:categoryID];
				if (![friendGroupID isEqual:[friendGroupID lastObject]]) {
					[ids appendString:@","];
				}
			}
			[parameters addObject:[[[OARequestParameter alloc] initWithName:@"friend_group_ids" value:ids] autorelease]];
		}
	}
	
	if (publishDate) {
		NSString *timestamp = [NSString stringWithFormat:@"%f", [publishDate timeIntervalSince1970]];
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"public_at" value:timestamp] autorelease]];
	}
	if ([categoryID integerValue]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"category_id" value:categoryID] autorelease]];
	}
	if ([siteCategoryID integerValue]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"site_category_id" value:siteCategoryID] autorelease]];
	}
	if (useNL2BR) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"use_nl2br" value:@"1"] autorelease]];
	}
	if (commentPermission > ZBPixnetCommentPermissionDefault) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"comment_perm" value:[[NSNumber numberWithUnsignedInteger:commentPermission] stringValue]] autorelease]];
	}
	if (hideComments) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"comment_hidden" value:@"1"] autorelease]];		
	}
	if (notifyTwitter) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"notify_twitter" value:@"1"] autorelease]];		
	}
	if (notifyFacebook) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"notify_facebook" value:@"1"] autorelease]];
	}
	if ([trackbackURLs count]) {
		NSMutableString *URLString = [NSMutableString string];
		for (NSString *URL in trackbackURLs) {
			[URLString appendString:URL];
			if (![URL isEqual:[trackbackURLs lastObject]]) {
				[URLString appendString:@" "];
			}
		}
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"trackback" value:URLString] autorelease]];		
	}
	
	[self doFetchWithPath:kPixnetBlogArticles method:@"POST" delegate:delegate didFinishSelector:@selector(API:didCreateArticle:) didFailSelector:@selector(API:didFailCreatingArticle:) parameters:parameters];
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
