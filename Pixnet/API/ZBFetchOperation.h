#import <Foundation/Foundation.h>
#import "OAMutableURLRequest.h"

@interface ZBFetchOperation : NSOperation 
{
    OAMutableURLRequest *request;
    NSURLResponse *response;
    NSURLConnection *connection;
    NSMutableData *responseData;
	id userInfo;
    id delegate;
    SEL didFinishSelector;
    SEL didFailSelector;
	BOOL running;
}

- (id)init:(OAMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector userInfo:(id)inuserInfo;

@end
