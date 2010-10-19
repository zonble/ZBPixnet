#import "ZBPixnetAPI+Pixnet.h"
#import "ZBPixnetAPI+Private.h"

// Comment filters

NSString *const ZBPixnetCommentFilterWhisper = @"whisper";
NSString *const ZBPixnetCommentFilterNoSpam = @"nospam";
NSString *const ZBPixnetCommentFilterNoReply = @"noreply";

// Video Thumbnail Position

NSString *const ZBPixnetVideoThumbnailPositionBeginning = @"beginning";
NSString *const ZBPixnetVideoThumbnailPositionMiddle = @"middle";
NSString *const ZBPixnetVideoThumbnailPositionEnd = @"end";

// API Paths

static NSString *const kPixnetAccount = @"account";
static NSString *const kPixnetUserInfo = @"users";
static NSString *const kPixnetBlogCategories = @"blog/categories";
static NSString *const kPixnetBlogCategoriesPosition = @"blog/categories/position"; 
static NSString *const kPixnetBlogArticles = @"blog/articles";
static NSString *const kPixnetBlogComments = @"blog/comments";
static NSString *const kPixnetBlogSiteCategories = @"blog/site_categories";
static NSString *const kPixnetAlbumSetFolders = @"album/setfolders";
static NSString *const kPixnetAlbumSetFoldersPosition = @"album/setfolders/position";
static NSString *const kPixnetAlbumSets = @"album/sets";
static NSString *const kPixnetAlbumSetsPosition = @"album/sets/position";
static NSString *const kPixnetAlbumFolders = @"album/folders";
static NSString *const kPixnetAlbumFoldersPosition = @"album/folders/position";
static NSString *const kPixnetAlbumElements = @"album/elements";
static NSString *const kPixnetAlbumElementsPosition = @"album/elements/position";



@implementation ZBPixnetAPI(Pixnet)

#pragma mark Account

- (void)fetchAccountInfoWithDelegate:(id)delegate
{
	[self doFetchWithPath:kPixnetAccount method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAccountInfo:) didFailSelector:@selector(API:didFailFetchingAccountInfo:) parameters:nil];	
}

- (void)fetchUserInfo:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSString *path = [kPixnetUserInfo stringByAppendingFormat:@"/%@", [userID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchUserInfo:) didFailSelector:@selector(API:didFailFetchingUserInfo:) parameters:nil];	
}

#pragma mark -
#pragma mark Blog

- (void)fetchBlogCategoriesOfUser:(NSString *)userID password:(NSString *)password delegate:(id <ZBPixnetAPIDelegate>)delegate
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
- (void)editBlogCategory:(NSString *)categoryID categoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate
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
- (void)deleteBlogCategory:(NSString *)categoryID type:(ZBPixnetBlogCategoryType)type delegate:(id <ZBPixnetAPIDelegate>)delegate
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
- (void)reorderBlogCategoriesWithIDArray:(NSArray *)categoryIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableString *ids = [NSMutableString string];
	for (NSString *categoryID in categoryIDArray) {
		if (![categoryID isKindOfClass:[NSString class]]) {
			if ([categoryID respondsToSelector:@selector(stringValue)]) {
				categoryID = [(id)categoryID stringValue];
			}
			else {
				categoryID = nil;
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

#pragma mark Blog Articles

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
			else {
				categoryID = nil;
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
- (void)fetchArticle:(NSString *)articleID user:(NSString *)userID password:(NSString *)password articlePassword:(NSString *)articlePassword delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (articleID) {
		if (![articleID isKindOfClass:[NSString class]]) {
			if ([articleID respondsToSelector:@selector(stringValue)]) {
				articleID = [(id)articleID stringValue];
			}
			else {
				articleID = nil;
			}
		}
	}	
	NSString *path = [kPixnetBlogArticles stringByAppendingFormat:@"/%@", [articleID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
- (void)editArticle:(NSString *)articleID title:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (![articleID isKindOfClass:[NSString class]]) {
		if ([articleID respondsToSelector:@selector(stringValue)]) {
			articleID = [(id)articleID stringValue];
		}
	}	
	NSString *path = [kPixnetBlogArticles stringByAppendingFormat:@"/%@", [articleID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSArray *parameters = [self _articleParametersWithTitle:title body:body status:status publishDate:publishDate category:categoryID siteCategory:siteCategoryID useNL2BR:useNL2BR commentPermission:commentPermission hideComments:hideComments trackbackURLs:trackbackURLs articlePassword:articlePassword passwordHint:hint friendGroupIDs:friendGroupIDs notifyTwitter:notifyTwitter notifyFacebook:notifyFacebook];	
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didEditArticle:) didFailSelector:@selector(API:didFailEditingArticle:) parameters:parameters];
}
- (void)deleteArticle:(NSString *)articleID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (![articleID isKindOfClass:[NSString class]]) {
		if ([articleID respondsToSelector:@selector(stringValue)]) {
			articleID = [(id)articleID stringValue];
		}
	}	
	NSString *path = [kPixnetBlogArticles stringByAppendingFormat:@"/%@", [articleID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didEditArticle:) didFailSelector:@selector(API:didFailEditingArticle:) parameters:nil];
}

#pragma mark Blog Comments

- (void)fetchBlogCommentsWithUserID:(NSString *)userID article:(NSString *)articleID password:(NSString *)password articlePassword:(NSString *)articlePassword filter:(NSString *)filter page:(NSUInteger)page commentsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if ([articleID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"article_id" value:articleID] autorelease]];
	}
	if ([password length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"blog_password" value:password] autorelease]];
	}
	if ([articlePassword length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"article_password" value:articlePassword] autorelease]];
	}	
	if ([filter length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"filter" value:filter] autorelease]];
	}	
	if (page > 1) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"page" value:[[NSNumber numberWithUnsignedInteger:page] stringValue]] autorelease]];
	}
	if (perPage && perPage != 100) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"per_page" value:[[NSNumber numberWithUnsignedInteger:perPage] stringValue]] autorelease]];
	}
	
	[self doFetchWithPath:kPixnetBlogComments method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchComments:) didFailSelector:@selector(API:didFailFetchingComments:) parameters:parameters];
}
- (void)createBlogCommentForArticle:(NSString *)articleID body:(NSString *)body blogOwner:(NSString *)ownerUserID commenterNickname:(NSString *)nickname title:(NSString *)title commenterURL:(NSString *)URLString commenterEmail:(NSString *)email publicComment:(BOOL)publicComment password:(NSString *)password articlePassword:(NSString *)articlePassword delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if (articleID) {
		if (![articleID isKindOfClass:[NSString class]]) {
			if ([articleID respondsToSelector:@selector(stringValue)]) {
				articleID = [(id)articleID stringValue];
			}
			else {
				articleID = nil;
			}
		}
	}	
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"article_id" value:articleID] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"body" value:body] autorelease]];
	if ([ownerUserID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:ownerUserID] autorelease]];
	}
	if ([nickname length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"author" value:nickname] autorelease]];
	}
	if ([title length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"title" value:title] autorelease]];
	}
	if ([URLString length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"url" value:URLString] autorelease]];
	}
	if ([email length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"email" value:email] autorelease]];
	}	
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"is_open" value:[[NSNumber numberWithBool:publicComment] stringValue]] autorelease]];	
	if ([password length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"blog_password" value:password] autorelease]];
	}	
	if ([password length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"article_password" value:articlePassword] autorelease]];
	}	
	[self doFetchWithPath:kPixnetBlogComments method:@"POST" delegate:delegate didFinishSelector:@selector(API:didCreateComment:) didFailSelector:@selector(API:didFailCreatingComment:) parameters:parameters];
}
- (void)fetchBlogComment:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchComment:) didFailSelector:@selector(API:didFailFetchingComment:) parameters:nil];	
}
- (void)replyBlogComment:(NSString *)commentID body:(NSString *)body delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}	
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@/reply", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"body" value:body] autorelease]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didReplyComment:) didFailSelector:@selector(API:didFailReplyingComment:) parameters:parameters];	
}
- (void)makeCommentPublic:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@/open", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didMakeCommentPublic:) didFailSelector:@selector(API:didFailMakingCommentPublic:) parameters:nil];	
}
- (void)makeCommentPrivate:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@/close", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didMakeCommentPrivate:) didFailSelector:@selector(API:didFailMakingCommentPrivate:) parameters:nil];
}
- (void)markCommentAsSpam:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@/mark_spam", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didMarkCommentAsSpam:) didFailSelector:@selector(API:didFailMarkingCommentAsSpam:) parameters:nil];
}
- (void)unmarkCommentAsSpam:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@/mark_ham", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didUnmarkCommentAsSpam:) didFailSelector:@selector(API:didFailUnmarkingCommentAsSpam:) parameters:nil];
}
- (void)deleteComment:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (commentID) {
		if (![commentID isKindOfClass:[NSString class]]) {
			if ([commentID respondsToSelector:@selector(stringValue)]) {
				commentID = [(id)commentID stringValue];
			}
			else {
				commentID = nil;
			}
		}
	}
	NSString *path = [kPixnetBlogComments stringByAppendingFormat:@"/%@", [commentID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didDeleteComment:) didFailSelector:@selector(API:didFailDeletingComment:) parameters:nil];
	
}

#pragma mark Blog Site Categories

- (void)fetchBlogSiteCategoriesIncludingGroups:(BOOL)includeGroups containThumbnails:(BOOL)containThumbnails delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if (includeGroups) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"include_groups" value:@"true"] autorelease]];
	}
	if (containThumbnails) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"include_thumbs" value:@"true"] autorelease]];
	}
	[self doFetchWithPath:kPixnetBlogSiteCategories method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchBlogSiteCategories:) didFailSelector:@selector(API:didFailFetchingBlogSiteCategories:) parameters:parameters];	
}

#pragma mark -
#pragma mark Album Set Folders

- (void)fetchAlbumSetFoldersOfUser:(NSString *)userID hideUserInfo:(BOOL)hideUserInfo page:(NSUInteger)page albumSetsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	if (hideUserInfo) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"trim_user" value:@"1"] autorelease]];
	}
	if (page > 1) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"page" value:[[NSNumber numberWithUnsignedInt:page] stringValue]] autorelease]];
	}
	if (perPage && perPage != 100) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"per_page" value:[[NSNumber numberWithUnsignedInt:perPage] stringValue]] autorelease]];
	}
	
	[self doFetchWithPath:kPixnetAlbumSetFolders method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAlbumSetFolders:) didFailSelector:@selector(API:didFailFetchingAlbumSetFolders:) parameters:parameters];		
}
- (void)reorderAlbumSetFoldersWithIDArray:(NSArray *)albumSetFolderIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	NSMutableString *s = [NSMutableString string];
	for (NSString *albumSetFolderID in albumSetFolderIDArray) {
		[s appendString:albumSetFolderID];
		if (![albumSetFolderID isEqual:[albumSetFolderIDArray lastObject]]) {
			[s appendString:@","];
		}
	}
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"ids" value:s] autorelease]];
	[self doFetchWithPath:kPixnetAlbumSetFoldersPosition method:@"POST" delegate:delegate didFinishSelector:@selector(API:didReorderAlbumSetFolders:) didFailSelector:@selector(API:didFailReorderingAlbumSetFolders:) parameters:parameters];
}

#pragma mark Album Sets

- (void)fetchAlbumSetsOfUser:(NSString *)userID parent:(NSString *)parentID hideUserInfo:(BOOL)hideUserInfo page:(NSUInteger)page albumSetsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if (hideUserInfo) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"trim_user" value:@"1"] autorelease]];
	}
	if (page > 1) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"page" value:[[NSNumber numberWithUnsignedInt:page] stringValue]] autorelease]];
	}
	if (perPage && perPage != 20) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"per_page" value:[[NSNumber numberWithUnsignedInt:perPage] stringValue]] autorelease]];
	}	
	[self doFetchWithPath:kPixnetAlbumSets method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAlbumSets:) didFailSelector:@selector(API:didFailFetchingAlbumSets:) parameters:parameters];
}
- (NSArray *)_albumSetParametersWithTitle:(NSString *)title description:(NSString *)description permission:(ZBPixnetAlbumSetPermission)permission category:(NSString *)categoryID disableRightClick:(BOOL)disableRightClick useCCLicense:(BOOL)useCCLicense commentPermission:(ZBPixnetCommentPermission)commentPermission password:(NSString *)password passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parent:(NSString *)parentID
{
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"title" value:title] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"description" value:description] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"permission" value:[[NSNumber numberWithUnsignedInt:permission] stringValue]] autorelease]];
	if ([categoryID length] && [categoryID integerValue]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"category_id" value:categoryID] autorelease]];		
	}
	if (disableRightClick) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"is_lockright" value:@"1"] autorelease]];
	}
	if (useCCLicense) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"allow_cc" value:@"1"] autorelease]];
	}
	if (allowCommercialUse) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"allow_commercial_usr" value:@"1"] autorelease]];
	}
	if (allowDerivation) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"allow_derivation" value:@"1"] autorelease]];
	}
	if ([parentID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"parent_id" value:parentID] autorelease]];
	}
	if (commentPermission > ZBPixnetCommentPermissionDefault) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"cancomment" value:[[NSNumber numberWithUnsignedInteger:commentPermission] stringValue]] autorelease]];
	}	
	
	if (permission) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"permission" value:[[NSNumber numberWithUnsignedInteger:permission] stringValue]] autorelease]];
		if (permission == ZBPixnetAlbumSetPermissionRequirePassword) {
			[parameters addObject:[[[OARequestParameter alloc] initWithName:@"password" value:password] autorelease]];
			[parameters addObject:[[[OARequestParameter alloc] initWithName:@"password_hint" value:hint] autorelease]];
		}
		else if (permission == ZBPixnetAlbumSetPermissionFriendGroupsOnly) {
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
	return parameters;
}

- (void)createAlbumSetWithTitle:(NSString *)title description:(NSString *)description permission:(ZBPixnetAlbumSetPermission)permission category:(NSString *)categoryID disableRightClick:(BOOL)disableRightClick useCCLicense:(BOOL)useCCLicense commentPermission:(ZBPixnetCommentPermission)commentPermission password:(NSString *)password passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parent:(NSString *)parentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSArray *parameters = [self _albumSetParametersWithTitle:title description:description permission:permission category:categoryID disableRightClick:disableRightClick useCCLicense:useCCLicense commentPermission:commentPermission password:password passwordHint:hint friendGroupIDs:friendGroupIDs allowCommercialUse:allowDerivation allowDerivation:allowDerivation parent:parentID];	
	[self doFetchWithPath:kPixnetAlbumSets method:@"POST" delegate:delegate didFinishSelector:@selector(API:didCreateAlbumSet:) didFailSelector:@selector(API:didFailCreatingAlbumSet:) parameters:parameters];
}
- (void)editAlbumSet:(NSString *)albumSetID title:(NSString *)title description:(NSString *)description permission:(ZBPixnetAlbumSetPermission)permission category:(NSString *)categoryID disableRightClick:(BOOL)disableRightClick useCCLicense:(BOOL)useCCLicense commentPermission:(ZBPixnetCommentPermission)commentPermission password:(NSString *)password passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parent:(NSString *)parentID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (albumSetID) {
		if (![albumSetID isKindOfClass:[NSString class]]) {
			if ([albumSetID respondsToSelector:@selector(stringValue)]) {
				albumSetID = [(id)albumSetID stringValue];
			}
			else {
				albumSetID = nil;
			}
		}
	}	
	NSString *path = [kPixnetAlbumSets stringByAppendingFormat:@"/%@", [albumSetID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSArray *parameters = [self _albumSetParametersWithTitle:title description:description permission:permission category:categoryID disableRightClick:disableRightClick useCCLicense:useCCLicense commentPermission:commentPermission password:password passwordHint:hint friendGroupIDs:friendGroupIDs allowCommercialUse:allowDerivation allowDerivation:allowDerivation parent:parentID];	
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didEditAlbumSet:) didFailSelector:@selector(API:didFailEditingAlbumSet:) parameters:parameters];
}
- (void)deleteAlbumSet:(NSString *)albumSetID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (albumSetID) {
		if (![albumSetID isKindOfClass:[NSString class]]) {
			if ([albumSetID respondsToSelector:@selector(stringValue)]) {
				albumSetID = [(id)albumSetID stringValue];
			}
			else {
				albumSetID = nil;
			}
		}
	}	
	NSString *path = [kPixnetAlbumSets stringByAppendingFormat:@"/%@", [albumSetID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didDeleteAlbumSet:) didFailSelector:@selector(API:didFailDeletingAlbumSet:) parameters:nil];
}
- (void)reorderAlbumSetsWithIDArray:(NSArray *)albumSetIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	NSMutableString *s = [NSMutableString string];
	for (NSString *albumSetID in albumSetIDArray) {
		[s appendString:albumSetID];
		if (![albumSetID isEqual:[albumSetIDArray lastObject]]) {
			[s appendString:@","];
		}
	}
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"ids" value:s] autorelease]];	
	[self doFetchWithPath:kPixnetAlbumSetsPosition method:@"POST" delegate:delegate didFinishSelector:@selector(API:didReorderAlbumSets:) didFailSelector:@selector(API:didFailReorderingAlbumSets:) parameters:parameters];
}

#pragma mark Album Folders (VIP)

- (void)fetchAlbumFolderOfUser:(NSString *)userID hideUserInfo:(BOOL)hideUserInfo page:(NSUInteger)page albumFoldersPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if (hideUserInfo) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"trim_user" value:@"1"] autorelease]];
	}
	if (page > 1) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"page" value:[[NSNumber numberWithUnsignedInt:page] stringValue]] autorelease]];
	}
	if (perPage && perPage != 20) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"per_page" value:[[NSNumber numberWithUnsignedInt:perPage] stringValue]] autorelease]];
	}	
	[self doFetchWithPath:kPixnetAlbumFolders method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAlbumFolders:) didFailSelector:@selector(API:didFailFetchingAlbumFolders:) parameters:parameters];
}

- (void)fetchAlbumFolder:(NSString *)albumFolderID albumOwner:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (albumFolderID) {
		if (![albumFolderID isKindOfClass:[NSString class]]) {
			if ([albumFolderID respondsToSelector:@selector(stringValue)]) {
				albumFolderID = [(id)albumFolderID stringValue];
			}
			else {
				albumFolderID = nil;
			}
		}
	}
	NSString *path = [kPixnetAlbumFolders stringByAppendingFormat:@"/%@", [albumFolderID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableArray *parameters = [NSMutableArray array];
	if (userID) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAlbumFolder:) didFailSelector:@selector(API:didFailFetchingAlbumFolder:) parameters:parameters];
	
}
- (void)createAlbumFolderWithTitle:(NSString *)title desciption:(NSString *)desciption delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"title" value:title] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"desciption" value:desciption] autorelease]];
	[self doFetchWithPath:kPixnetAlbumFolders method:@"POST" delegate:delegate didFinishSelector:@selector(API:didCreateAlbumFolder:) didFailSelector:@selector(API:didFailCreatingAlbumFolder:) parameters:parameters];
}
- (void)editAlbumFolder:(NSString *)albumFolderID title:(NSString *)title desciption:(NSString *)desciption delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (albumFolderID) {
		if (![albumFolderID isKindOfClass:[NSString class]]) {
			if ([albumFolderID respondsToSelector:@selector(stringValue)]) {
				albumFolderID = [(id)albumFolderID stringValue];
			}
			else {
				albumFolderID = nil;
			}
		}
	}
	NSString *path = [kPixnetAlbumFolders stringByAppendingFormat:@"/%@", [albumFolderID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"title" value:title] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"desciption" value:desciption] autorelease]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didEditAlbumFolder:) didFailSelector:@selector(API:didFailEditingAlbumFolder:) parameters:parameters];	
}
- (void)deleteAlbumFolder:(NSString *)albumFolderID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (albumFolderID) {
		if (![albumFolderID isKindOfClass:[NSString class]]) {
			if ([albumFolderID respondsToSelector:@selector(stringValue)]) {
				albumFolderID = [(id)albumFolderID stringValue];
			}
			else {
				albumFolderID = nil;
			}
		}
	}	
	NSString *path = [kPixnetAlbumFolders stringByAppendingFormat:@"/%@", [albumFolderID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didDeleteAlbumFolder:) didFailSelector:@selector(API:didFailDeletingAlbumFolder:) parameters:nil];		
}

#pragma mark Album Elements (Media Files)

- (void)fetchElementsInAlbumSet:(NSString *)albumSetID elementOwner:(NSString *)userID page:(NSUInteger)page elementsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (albumSetID) {
		if (![albumSetID isKindOfClass:[NSString class]]) {
			if ([albumSetID respondsToSelector:@selector(stringValue)]) {
				albumSetID = [(id)albumSetID stringValue];
			}
			else {
				albumSetID = nil;
			}
		}
	}	
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"set_id" value:albumSetID] autorelease]];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	if (page > 1) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"page" value:[[NSNumber numberWithUnsignedInt:page] stringValue]] autorelease]];
	}
	if (perPage && perPage != 100) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"per_page" value:[[NSNumber numberWithUnsignedInt:perPage] stringValue]] autorelease]];
	}	
	[self doFetchWithPath:kPixnetAlbumElements method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAlbumElements:) didFailSelector:@selector(API:didFailFetchingAlbumElements:) parameters:parameters];	
}
- (void)fetchElement:(NSString *)elementID elementOwner:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (elementID) {
		if (![elementID isKindOfClass:[NSString class]]) {
			if ([elementID respondsToSelector:@selector(stringValue)]) {
				elementID = [(id)elementID stringValue];
			}
			else {
				elementID = nil;
			}
		}
	}
	NSString *path = [kPixnetAlbumElements stringByAppendingFormat:@"/%@", [elementID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableArray *parameters = [NSMutableArray array];
	if ([userID length]) {
		[parameters addObject:[[[OARequestParameter alloc] initWithName:@"user" value:userID] autorelease]];
	}
	[self doFetchWithPath:path method:@"GET" delegate:delegate didFinishSelector:@selector(API:didFetchAlbumElement:) didFailSelector:@selector(API:didFailFetchingAlbumElement:) parameters:parameters];
}
- (void)uploadFile:(NSString *)filepath toTagetAlbumSet:(NSString *)albumSetID title:(NSString *)title description:(NSString *)description videoThumbnailType:(NSString *)videoThumbnailType optimized:(BOOL)optimized rotateByEXIF:(BOOL)rotateByEXIF rotateByMetadata:(BOOL)rotateByMetadata useSquareTHumbnail:(BOOL)useSquareTHumbnail addWatermark:(BOOL)addWatermark insertAtEngin:(BOOL)insertAtEngin delegate:(id <ZBPixnetAPIDelegate>)delegate
{
}
- (void)editElement:(NSString *)elementID title:(NSString *)title description:(NSString *)description videoThumbnailType:(NSString *)videoThumbnailType delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (elementID) {
		if (![elementID isKindOfClass:[NSString class]]) {
			if ([elementID respondsToSelector:@selector(stringValue)]) {
				elementID = [(id)elementID stringValue];
			}
			else {
				elementID = nil;
			}
		}
	}	
	NSString *path = [kPixnetAlbumElements stringByAppendingFormat:@"/%@", [elementID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableArray *parameters = [NSMutableArray array];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"title" value:title] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"description" value:description] autorelease]];
	[parameters addObject:[[[OARequestParameter alloc] initWithName:@"video_thumb_type" value:videoThumbnailType] autorelease]];
	[self doFetchWithPath:path method:@"POST" delegate:delegate didFinishSelector:@selector(API:didEditAlbumElement:) didFailSelector:@selector(API:didFailEditingAlbumElement:) parameters:parameters];	
}
- (void)deleteElement:(NSString *)elementID delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	if (elementID) {
		if (![elementID isKindOfClass:[NSString class]]) {
			if ([elementID respondsToSelector:@selector(stringValue)]) {
				elementID = [(id)elementID stringValue];
			}
			else {
				elementID = nil;
			}
		}
	}	
	NSString *path = [kPixnetAlbumElements stringByAppendingFormat:@"/%@", [elementID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[self doFetchWithPath:path method:@"DELETE" delegate:delegate didFinishSelector:@selector(API:didDeleteAlbumElement:) didFailSelector:@selector(API:didFailDeletingAlbumElement:) parameters:nil];	

}
- (void)reorderElementsWithIDArray:(NSArray *)elementIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate
{
	NSMutableString *ids = [NSMutableString string];
	for (NSString *elementID in elementIDArray) {
		if (![elementID isKindOfClass:[NSString class]]) {
			if ([elementID respondsToSelector:@selector(stringValue)]) {
				elementID = [(id)elementID stringValue];
			}
			else {
				elementID = nil;
			}
		}
		if (![elementID length]) {
			continue;
		}
		[ids appendString:elementID];
		if (![elementID isEqual:[elementIDArray lastObject]]) {
			[ids appendString:@","];
		}
	}
	NSArray *parameters = [NSArray arrayWithObjects:[[[OARequestParameter alloc] initWithName:@"ids" value:ids] autorelease], nil];	
	[self doFetchWithPath:kPixnetAlbumElementsPosition method:@"POST" delegate:delegate didFinishSelector:@selector(API:didReorderAlbumElement:) didFailSelector:@selector(API:didFailReorderingAlbumElement:) parameters:parameters];	
}

//static NSString *const kPixnetAlbumElements = @"album/elements";
//static NSString *const kPixnetAlbumElementsPosition = @"album/elements/position";

@end
