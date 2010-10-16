//
//  RootViewController.h
//  PartRetard
//

#import "ZBPixnetAPI.h"

@interface RootViewController : UITableViewController <ZBPixnetAPILoginDelegate, ZBPixnetAPIDelegate>
{
}

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (void)doFetch;

@end
