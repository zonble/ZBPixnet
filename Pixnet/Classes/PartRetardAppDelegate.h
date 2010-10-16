//
//  PartRetardAppDelegate.h
//  PartRetard
//

@interface PartRetardAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
}

+ (PartRetardAppDelegate *)sharedDelegate;
- (NSString *)applicationDocumentsDirectory;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

