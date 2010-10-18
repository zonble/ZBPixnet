//
//  RootViewController.m
//  PartRetard
//

#import "RootViewController.h"

@implementation RootViewController

- (void)removeOutletsAndControls_RootViewController
{
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
}

#pragma mark -
#pragma mark UIViewContoller Methods


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
//	[API fetchBlogCategoriesWithUserID:@"zonble" password:nil delegate:self];	
//	[API createBlogCategorieWithCategoryName:@"Test" description:@"Just a test" type:0 visible:YES siteCategory:@"0" delegate:self];
//	[API editBlogCategoryWithID:@"1461659" categoryName:@"Test Editing 2" description:@"Just another test 2" type:0 visible:YES siteCategory:@"0" delegate:self];
//	[API deleteBlogCategoryWithID:@"1461659" type:0 delegate:self];
//	[API reoderBlogCategoriesWithIDArray:[NSArray arrayWithObjects:@"16138", @"1461661", @"1461663", nil] delegate:self];
//	[API fetchArticlesOfUser:@"zonble" password:nil page:1 articlesPerPage:100 category:nil hideAuthorInfo:NO delegate:self];
//	[API fetchArticleWithID:@"25576745" user:@"zonble" password:nil articlePassword:nil delegate:self];
//	[API createArticleWithTitle:@"HI" body:@"Hallo?!" status:ZBPixnetBlogArticleStatusPublished publishDate:[NSDate date] category:nil siteCategory:nil useNL2BR:NO commentPermission:ZBPixnetCommentPermissionOpen hideComments:NO trackbackURLs:nil articlePassword:nil passwordHint:nil friendGroupIDs:nil notifyTwitter:NO notifyFacebook:NO delegate:self];
//	[API editArticleWithID:@"27353373" title:@"Test Editing" body:@"The body is changed" status:ZBPixnetBlogArticleStatusPublished publishDate:[NSDate date] category:nil siteCategory:nil useNL2BR:NO commentPermission:ZBPixnetCommentPermissionOpen hideComments:NO trackbackURLs:nil articlePassword:nil passwordHint:nil friendGroupIDs:nil notifyTwitter:NO notifyFacebook:NO delegate:self];
	[API deleteArticleWithID:@"27353373" delegate:self];
	[API deleteArticleWithID:@"27353389" delegate:self];
	[API deleteArticleWithID:@"27338745" delegate:self];
	[API deleteArticleWithID:@"27338381" delegate:self];
	[API deleteArticleWithID:@"27336997" delegate:self];
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
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingBlogCategory:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didEditBlogCategory:(NSDictionary *)inBlogCategory
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategory);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingBlogCategory:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didDeleteBlogCategory:(NSDictionary *)inBlogCategory
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategory);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingBlogCategory:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didReorderBlogCategories:(NSDictionary *)inMessage
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inMessage);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingBlogCategories:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didFetchArticles:(NSDictionary *)inArticles
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticles);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticles:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didFetchArticle:(NSDictionary *)inArticle
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticle:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didCreateArticle:(NSDictionary *)inArticle
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingArticle:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didEditArticle:(NSDictionary *)inArticle
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingArticle:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didDeleteArticle:(NSDictionary *)inArticle
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingArticle:(NSError *)inError
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

