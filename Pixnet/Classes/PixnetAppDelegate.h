@interface PixnetAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
}

+ (PixnetAppDelegate *)sharedDelegate;
- (NSString *)applicationDocumentsDirectory;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

