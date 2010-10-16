//
//  RootViewController.m
//  PartRetard
//

#import "RootViewController.h"

@implementation RootViewController

- (void)removeOutletsAndControls_RootViewController
{
    // remove and clean outlets and controls here
}

- (void)dealloc 
{
	[self removeOutletsAndControls_RootViewController];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_RootViewController];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/*
// The designated initializer.  Override if you create the controller
// programmatically and want to perform customization that is not appropriate 
// for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark -
#pragma mark UIViewContoller Methods

/*
// Implement loadView to create a view hierarchy programmatically, without
// using a nib.
- (void)loadView 
{
}
*/
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	if ([ZBPixnetAPI sharedAPI].loggedIn) {		
		UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
		self.navigationItem.rightBarButtonItem = logoutItem;
		[logoutItem release];		
		[self doFetch];
	}
	else {
		UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
		self.navigationItem.rightBarButtonItem = loginItem;
		[loginItem release];		
	}
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (IBAction)login:(id)sender
{
	[[ZBPixnetAPI sharedAPI] loginWithController:self];
}
- (IBAction)logout:(id)sender
{
	[[ZBPixnetAPI sharedAPI] logout];
	
	UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
	self.navigationItem.rightBarButtonItem = loginItem;
	[loginItem release];	
}

- (void)APIUserDidCancelLoggingin:(ZBPixnetAPI *)inAPI
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)APIDidLogin:(ZBPixnetAPI *)inAPI
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
	self.navigationItem.rightBarButtonItem = logoutItem;
	[logoutItem release];	
	
	[self doFetch];
}

- (void)doFetch
{
	ZBPixnetAPI *API = [ZBPixnetAPI sharedAPI];
	
//	[API fetchAccountInfoWithDelegate:self];
//	[API fetchUserInfoWithUserID:@"far" delegate:self];
//	[API fetchBlogCategoriesWithUserID:@"far" password:nil delegate:self];	
	[API createBlogCategorieWithCategoryName:@"Test" description:@"Just a test" type:0 visible:YES siteCategoryID:@"0" delegate:self];
}

- (void)API:(ZBPixnetAPI *)inAPI didFetchAccountInfo:(NSDictionary *)accountInfo
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, accountInfo);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAccountInfo:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didFetchUserInfo:(NSDictionary *)userInfo
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, userInfo);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingUserInfo:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didFetchBlogCategories:(NSDictionary *)inBlogCategories
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategories);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingBlogCategories:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didCreateBlogCategory:(NSDictionary *)inBlogCategory
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategory);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingBlogCategoriy:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)aCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Remenber to redraw the cell if you used a customized one.
	[aCell setNeedsDisplay];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/
/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end

