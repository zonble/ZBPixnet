#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "ZBLoginWebViewController.h"
#import "ZBFetchOperation.h"

@class ZBPixnetAPI;

extern NSString *const ZBPixnetAPILoginNotification;
extern NSString *const ZBPixnetAPILogoutNotification;

@protocol ZBPixnetAPILoginDelegate <NSObject>
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

@end

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

- (void)logout;
- (void)loginWithController:(UIViewController <ZBPixnetAPILoginDelegate> *)controller;

#pragma mark -

- (void)fetchAccountInfoWithDelegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchUserInfoWithUserID:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate;


@property (readonly, getter=isLoggedIn) BOOL loggedIn;
@property (retain, nonatomic) UIViewController <ZBPixnetAPILoginDelegate> *currentViewController;
@property (retain, nonatomic) OAToken *requestToken;
@property (retain, nonatomic) OAToken *accessToken; 

@end
