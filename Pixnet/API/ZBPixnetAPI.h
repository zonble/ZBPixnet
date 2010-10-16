#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "ZBLoginWebViewController.h"
#import "ZBFetchOperation.h"

@class ZBPixnetAPI;

extern NSString *const ZBPixnetAPILoginNotification;
extern NSString *const ZBPixnetAPILogoutNotification;
extern NSString *const kPixetAPIURL;

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
#pragma mark Properties

@property (readonly, getter=isLoggedIn) BOOL loggedIn;
@property (retain, nonatomic) UIViewController <ZBPixnetAPILoginDelegate> *currentViewController;
@property (retain, nonatomic) OAToken *requestToken;
@property (retain, nonatomic) OAToken *accessToken; 

@end
