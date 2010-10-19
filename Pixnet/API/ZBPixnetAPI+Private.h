#import <Foundation/Foundation.h>
#import "ZBPixnetAPI.h"

@interface ZBPixnetAPI (Private) <ZBLoginWebViewControllerDelegate>
- (void)fetchRequestToken;
- (void)fetchAccessTokenWithVerifier:(NSString *)inVerifier;
- (void)doFetchWithPath:(NSString *)path method:(NSString *)method delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector parameters:(NSArray *)inParameters;
- (void)doUploadWithPath:(NSString *)path filepath:(NSString *)filepath delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector didFailSelector:(SEL)didFailSelector didSendDataSelector:(SEL)didSendDataSelector parameters:(NSArray *)inParameters;


@end
