#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "ZBLoginWebViewController.h"
#import "ZBFetchOperation.h"

@class ZBPixnetAPI;

extern NSString *const ZBPixnetAPILoginNotification;
extern NSString *const ZBPixnetAPILogoutNotification;
extern NSString *const kPixetAPIURL;

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
	NSString *prefix;
}

+ (ZBPixnetAPI *)sharedAPI;

#pragma mark -
#pragma mark Login

- (id)initWithPrefix:(NSString *)inPrefix consumerKey:(NSString *)inKey secret:(NSString *)inSecret;
- (void)setConsumerKey:(NSString *)inKey secret:(NSString *)inSecret;

- (void)loginWithController:(UIViewController <ZBPixnetAPILoginDelegate> *)controller;
- (void)logout;

#pragma mark -
#pragma mark Properties

@property (readonly, getter=isLoggedIn) BOOL loggedIn;
@property (retain, nonatomic) UIViewController <ZBPixnetAPILoginDelegate> *currentViewController;
@property (retain, nonatomic) OAToken *requestToken;
@property (retain, nonatomic) OAToken *accessToken; 

@end
