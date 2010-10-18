#import "ZBPixnetAPI+Pixnet.h"
#import "ZBPixnetAPI+Private.h"

static NSString *const kPixnetAccount = @"account";
static NSString *const kPixnetUserInfo = @"users/%@";
static NSString *const kPixnetBlogCategories = @"blog/categories";
static NSString *const kPixnetBlogCategoriesPosition = @"blog/categories/position"; 
static NSString *const kPixnetBlogArticles = @"blog/articles";

@implementation ZBPixnetAPI(Pixnet)

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

- (NSArray *)_articleParametersWithTitle:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook
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
				if (![friendGroupID isEqual:[friendGroupIDs lastObject]]) {
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
	return parameters;
}
- (void)createArticleWithTitle:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSArray *parameters = [self _articleParametersWithTitle:title body:body status:status publishDate:publishDate category:categoryID siteCategory:siteCategoryID useNL2BR:useNL2BR commentPermission:commentPermission hideComments:hideComments trackbackURLs:trackbackURLs articlePassword:articlePassword passwordHint:hint friendGroupIDs:friendGroupIDs notifyTwitter:notifyTwitter notifyFacebook:notifyFacebook];	
	[self doFetchWithPath:kPixnetBlogArticles method:@"POST" delegate:delegate didFinishSelector:@selector(API:didCreateArticle:) didFailSelector:@selector(API:didFailCreatingArticle:) parameters:parameters];
}
- (void)editArticleWithID:(NSString *)articleID title:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (![articleID isKindOfClass:[NSString class]]) {
		if ([articleID respondsToSelector:@selector(stringValue)]) {
			articleID = [(id)articleID stringValue];
		}
	}	
	NSString *path = [kPixnetBlogArticles stringByAppendingFormat:@"/%@", articleID];
	NSArray *parameters = [self _articleParametersWithTitle:title body:body status:status publishDate:publishDate category:categoryID siteCategory:siteCategoryID useNL2BR:useNL2BR commentPermission:commentPermission hideComments:hideComments trackbackURLs:trackbackURLs articlePassword:articlePassword passwordHint:hint friendGroupIDs:friendGroupIDs notifyTwitter:notifyTwitter notifyFacebook:notifyFacebook];	
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didEditArticle:) didFailSelector:@selector(API:didFailEditingArticle:) parameters:parameters];
}
- (void)deleteArticleWithID:(NSString *)articleID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (![articleID isKindOfClass:[NSString class]]) {
		if ([articleID respondsToSelector:@selector(stringValue)]) {
			articleID = [(id)articleID stringValue];
		}
	}	
	NSString *path = [kPixnetBlogArticles stringByAppendingFormat:@"/%@", articleID];
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didEditArticle:) didFailSelector:@selector(API:didFailEditingArticle:) parameters:nil];
}


@end
