#import "ZBFetchOperation.h"
#import "OAServiceTicket.h"

@implementation ZBFetchOperation

- (void)dealloc 
{
	[connection release];
	[response release];
	[responseData release];
	[request release];
	[userInfo release];
	[super dealloc];
}

- (id)init:(OAMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector userInfo:(id)inuserInfo
{
	self = [super init];
	if (self != nil) {
		request = [aRequest retain];
		delegate = aDelegate;
		didFinishSelector = finishSelector;
		didFailSelector = failSelector;	
		userInfo = [inuserInfo retain];
		responseData = [[NSMutableData alloc] init];
	}
	return self;
}

- (id)init:(OAMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector didSendDataSelector:(SEL)sendDataSelector userInfo:(id)inuserInfo
{
	self = [super init];
	if (self != nil) {
		request = [aRequest retain];
		delegate = aDelegate;
		didFinishSelector = finishSelector;
		didFailSelector = failSelector;	
		didSendDataSelector = sendDataSelector;
		userInfo = [inuserInfo retain];
		responseData = [[NSMutableData alloc] init];
	}
	return self;
}

- (BOOL)isConcurrent
{
	return YES;
}

- (BOOL)isExecuting
{
	return running;
}
- (BOOL)isFinished
{
	return !running;
}

- (void)main 
{
	@try {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		[request prepare];
		running = YES;
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
		while (running && ![self isCancelled]) {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
		}
		
		[pool release];
	}
	@catch(...) {
		OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:request response:response data:responseData didSucceed:NO];
		ticket.userInfo = userInfo;
		[delegate performSelector:didFailSelector withObject:ticket withObject:nil];
	}
}

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)aResponse 
{
	[response release];
	response = [aResponse retain];
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}

- (void)_doPerformingDelegateOnMainThreadWithArgs:(NSArray *)args
{
	SEL action = NSSelectorFromString([args objectAtIndex:0]);
	id obj1 = [args objectAtIndex:1];
	id obj2 = [args objectAtIndex:2];
	[delegate performSelector:action withObject:obj1 withObject:obj2];
}

- (void)performDelegateSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2
{
	NSArray *args = [NSArray arrayWithObjects:NSStringFromSelector(aSelector), obj1, obj2, nil];
	[self performSelectorOnMainThread:@selector(_doPerformingDelegateOnMainThreadWithArgs:) withObject:args waitUntilDone:NO];
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)error 
{
	if (didFailSelector != NULL) {
		OAServiceTicket *ticket = [[[OAServiceTicket alloc] initWithRequest:request response:response data:responseData didSucceed:NO] autorelease];
		ticket.userInfo = userInfo;
		[self performDelegateSelector:didFailSelector withObject:ticket withObject:error];
	}
	running = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection 
{
	if (didFinishSelector != NULL) {
		OAServiceTicket *ticket = [[[OAServiceTicket alloc] initWithRequest:request response:response data:responseData didSucceed:[(NSHTTPURLResponse *)response statusCode] < 400] autorelease];
		ticket.userInfo = userInfo;
		[self performDelegateSelector:didFinishSelector withObject:ticket withObject:responseData];
	}
	running = NO;
}

- (void)connection:(NSURLConnection *)inConnection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	if (didSendDataSelector == NULL) {
		return;
	}
	NSMutableDictionary *process = [NSMutableDictionary dictionary];
	[process setObject:[NSNumber numberWithInteger:totalBytesWritten] forKey:@"totalBytesWritten"];
	[process setObject:[NSNumber numberWithInteger:totalBytesExpectedToWrite] forKey:@"totalBytesExpectedToWrite"];
	[self performDelegateSelector:didSendDataSelector withObject:process withObject:userInfo];
}

@synthesize userInfo;

@end
