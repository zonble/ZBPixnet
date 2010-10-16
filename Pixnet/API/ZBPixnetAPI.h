#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "ZBLoginWebViewController.h"
#import "ZBFetchOperation.h"

@class ZBPixnetAPI;

extern NSString *const ZBPixnetAPILoginNotification;
extern NSString *const ZBPixnetAPILogoutNotification;

typedef enum {
	ZBPixnetBlogCategoryTypeCategory = 0,
	ZBPixnetBlogCategoryTypeFolder = 1
} ZBPixnetBlogCategoryType;

typedef enum {
	ZBPixnetBlogArticleStatusDeleted = 0,
	ZBPixnetBlogArticleStatusDraft = 1,
	ZBPixnetBlogArticleStatusPublished = 2,
	ZBPixnetBlogArticleStatusRequirePassword = 3,
	ZBPixnetBlogArticleStatusHidden = 4,
	ZBPixnetBlogArticleStatusFriendsOnly = 5,
	ZBPixnetBlogArticleStatusCoauthor = 7	
} ZBPixnetBlogArticleStatus;

typedef enum {
	ZBPixnetCommentPermissionDefault = -1,
	ZBPixnetCommentPermissionClosed = 0,
	ZBPixnetCommentPermissionOpen = 1,
	ZBPixnetCommentPermissionMembersOnly = 2,
	ZBPixnetCommentPermissionFriendsOnly = 3
} ZBPixnetCommentPermission;


#pragma mark -

@protocol ZBPixnetAPILoginDelegate <NSObject>
@required
- (void)APIUserDidCancelLoggingin:(ZBPixnetAPI *)inAPI;
- (void)APIDidLogin:(ZBPixnetAPI *)inAPI;
@optional
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingRequestToken:(NSError *)inError;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAccessToken:(NSError *)inError;
@end

@protocol ZBPixnetAPIDelegate <NSObject>

- (void)API:(ZBPixnetAPI *)inAPI didFetchAccountInfo:(NSDictionary *)inAccountInfo;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAccountInfo:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchUserInfo:(NSDictionary *)inUserInfo;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingUserInfo:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchBlogCategories:(NSDictionary *)inBlogCategories;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingBlogCategories:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateBlogCategory:(NSDictionary *)inBlogCategory;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingBlogCategory:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didEditBlogCategory:(NSDictionary *)inBlogCategory;
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingBlogCategory:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didDeleteBlogCategory:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingBlogCategory:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didReorderBlogCategories:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingBlogCategories:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchArticles:(NSDictionary *)inArticles;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticles:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchArticle:(NSDictionary *)inArticle;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticle:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateArticle:(NSDictionary *)inArticle;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingArticle:(NSError *)inError;



@end

#pragma mark -

@interface ZBPixnetAPI : NSObject
{
	OAConsumer *consumer;
	OAToken *requestToken;
	OAToken *accessToken;
	
	UIViewController <ZBPixnetAPILoginDelegate> *currentViewController;
	NSOperationQueue *fetchQueue;
}

+ (ZBPixnetAPI *)sharedAPI;

#pragma mark -
#pragma mark Login

- (void)logout;
- (void)loginWithController:(UIViewController <ZBPixnetAPILoginDelegate> *)controller;

#pragma mark -
#pragma mark Pixnet
#pragma mark Account

- (void)fetchAccountInfoWithDelegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchUserInfoWithUserID:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Blog categories

- (void)fetchBlogCategoriesWithUserID:(NSString *)userID password:(NSString *)password delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createBlogCategorieWithCategoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)editBlogCategoryWithID:(NSString *)categoryID categoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteBlogCategoryWithID:(NSString *)categoryID type:(ZBPixnetBlogCategoryType)type delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)reoderBlogCategoriesWithIDArray:(NSArray *)categoryIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Articles

- (void)fetchArticlesOfUser:(NSString *)userID password:(NSString *)password page:(NSUInteger)page articlesPerPage:(NSUInteger)perPage category:(NSString *)categoryID hideAuthorInfo:(BOOL)hideAuthorInfo delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchArticleWithID:(NSString *)articleID user:(NSString *)userID password:(NSString *)password articlePassword:(NSString *)articlePassword delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createArticleWithTitle:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark -
#pragma mark Properties

@property (readonly, getter=isLoggedIn) BOOL loggedIn;
@property (retain, nonatomic) UIViewController <ZBPixnetAPILoginDelegate> *currentViewController;
@property (retain, nonatomic) OAToken *requestToken;
@property (retain, nonatomic) OAToken *accessToken; 

@end
