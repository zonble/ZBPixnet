
#import "PixnetAppDelegate.h"
#import "RootViewController.h"


@implementation PixnetAppDelegate

+ (PixnetAppDelegate *)sharedDelegate
{
	return (PixnetAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[navigationController release];
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	RootViewController *rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	[rootViewController release];
	
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return NO;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}
- (void)applicationSignificantTimeChange:(UIApplication *)application
{
}

#pragma mark -
#pragma mark Application's Documents directory

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@synthesize window;
@synthesize navigationController;

@end

