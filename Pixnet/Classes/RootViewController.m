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
//	[API fetchUserInfo:@"far" delegate:self];
//	[API fetchBlogCategoriesOfUser:@"zonble" password:nil delegate:self];	
//	[API createBlogCategorieWithCategoryName:@"Test" description:@"Just a test" type:0 visible:YES siteCategory:@"0" delegate:self];
//	[API editBlogCategory:@"1461659" categoryName:@"Test Editing 2" description:@"Just another test 2" type:0 visible:YES siteCategory:@"0" delegate:self];
//	[API deleteBlogCategory:@"1461659" type:0 delegate:self];
//	[API reorderBlogCategoriesWithIDArray:[NSArray arrayWithObjects:@"16138", @"1461661", @"1461663", nil] delegate:self];
//	[API fetchArticlesOfUser:@"zonble" password:nil page:1 articlesPerPage:100 category:nil hideAuthorInfo:NO delegate:self];
//	[API fetchArticle:@"25576745" user:@"zonble" password:nil articlePassword:nil delegate:self];
//	[API createArticleWithTitle:@"HI" body:@"Hallo?!" status:ZBPixnetBlogArticleStatusPublished publishDate:[NSDate date] category:nil siteCategory:nil useNL2BR:NO commentPermission:ZBPixnetCommentPermissionOpen hideComments:NO trackbackURLs:nil articlePassword:nil passwordHint:nil friendGroupIDs:nil notifyTwitter:NO notifyFacebook:NO delegate:self];
//	[API editArticle:@"27353373" title:@"Test Editing" body:@"The body is changed" status:ZBPixnetBlogArticleStatusPublished publishDate:[NSDate date] category:nil siteCategory:nil useNL2BR:NO commentPermission:ZBPixnetCommentPermissionOpen hideComments:NO trackbackURLs:nil articlePassword:nil passwordHint:nil friendGroupIDs:nil notifyTwitter:NO notifyFacebook:NO delegate:self];
//	[API deleteArticle:@"27353373" delegate:self];
//	[API deleteArticle:@"27353389" delegate:self];
//	[API deleteArticle:@"27338745" delegate:self];
//	[API deleteArticle:@"27338381" delegate:self];
//	[API deleteArticle:@"27336997" delegate:self];
//	[API createBlogCommentForArticle:@"27336975" body:@"Test" blogOwner:@"zonble" commenterNickname:@"zonble" title:@"Just a test" commenterURL:@"http://zonble.net" commenterEmail:nil publicComment:YES password:nil articlePassword:nil delegate:self];
//	[API fetchBlogCommentsWithUserID:@"zonble" article:@"27336975" password:nil articlePassword:nil filter:nil page:1 commentsPerPage:100 delegate:self];
//	[API replyBlogComment:@"29753763" body:@"Reply" delegate:self];
//	[API makeCommentPublic:@"29753763" delegate:self];
//	[API makeCommentPrivate:@"29753763" delegate:self];
//	[API markCommentAsSpam:@"29753763" delegate:self];	
//	[API unmarkCommentAsSpam:@"29753763" delegate:self];	
//	[API deleteComment:@"29753771" delegate:self];
	
//	[API fetchBlogSiteCategoriesIncludingGroups:YES containThumbnails:YES delegate:self];
//	[API fetchAlbumSetFoldersOfUser:nil hideUserInfo:NO page:0 albumSetsPerPage:0 delegate:self];
//	[API reorderAlbumSetFoldersWithIDArray:[NSArray arrayWithObjects: @"943632", @"943634",@"686752",@"14289459", nil] delegate:self];
//	[API fetchAlbumSetsOfUser:nil parent:nil hideUserInfo:NO page:1 albumSetsPerPage:100 delegate:self];
//	[API createAlbumSetWithTitle:@"Test" description:@"Test" permission:ZBPixnetAlbumSetPermissionPublic category:nil disableRightClick:NO useCCLicense:NO commentPermission:ZBPixnetCommentPermissionOpen password:nil passwordHint:nil friendGroupIDs:nil allowCommercialUse:NO allowDerivation:NO parent:nil delegate:self];
//	[API editAlbumSet:@"14459792" title:@"Test2" description:@"Test2" permission:ZBPixnetAlbumSetPermissionFriendsOnly category:nil disableRightClick:YES useCCLicense:YES commentPermission:ZBPixnetCommentPermissionClosed password:nil passwordHint:nil friendGroupIDs:nil allowCommercialUse:YES allowDerivation:YES parent:nil delegate:self];
//	[API deleteAlbumSet:@"14459792" delegate:self];
//	[API reorderAlbumSetsWithIDArray:[NSArray arrayWithObjects:@"14289459", @"946985", @"686752", @"943632", nil] delegate:self];
//	[API fetchAlbumFolderOfUser:@"far" hideUserInfo:NO page:1 albumFoldersPerPage:100 delegate:self];
//	[API fetchAlbumFolder:@"14444157" albumOwner:@"far" delegate:self];
//	[API createAlbumFolderWithTitle:@"Test" desciption:@"Test" delegate:self];
//	[API editAlbumFolder:@"14444157" title:@"Test" desciption:@"Test" delegate:self];
//	[API deleteAlbumFolder:@"14444157" delegate:self];
//	[API fetchElementsInAlbumSet:@"943632" elementOwner:@"zonble" page:1 elementsPerPage:100 delegate:self];
//	[API fetchElement:@"28992063" elementOwner:@"zonble" delegate:self];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"pix" ofType:@"jpg"];	
	[API uploadFile:path toTagetAlbumSet:@"14459791" title:@"Test" description:@"Test" videoThumbnailType:nil optimized:YES rotateByEXIF:YES rotateByMetadata:YES useSquareThumbnail:YES addWatermark:YES insertAtEngin:NO delegate:self];
}

#pragma mark -

//- (void)API:(ZBPixnetAPI *)inAPI didFetchAccountInfo:(NSDictionary *)accountInfo
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, accountInfo);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAccountInfo:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchUserInfo:(NSDictionary *)userInfo
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, userInfo);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingUserInfo:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchBlogCategories:(NSDictionary *)inBlogCategories
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategories);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingBlogCategories:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didCreateBlogCategory:(NSDictionary *)inBlogCategory
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategory);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingBlogCategory:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didEditBlogCategory:(NSDictionary *)inBlogCategory
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategory);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailEditingBlogCategory:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didDeleteBlogCategory:(NSDictionary *)inBlogCategory
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogCategory);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingBlogCategory:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didReorderBlogCategories:(NSDictionary *)inMessage
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inMessage);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingBlogCategories:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchArticles:(NSDictionary *)inArticles
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticles);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticles:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchArticle:(NSDictionary *)inArticle
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticle:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didCreateArticle:(NSDictionary *)inArticle
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingArticle:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didEditArticle:(NSDictionary *)inArticle
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailEditingArticle:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didDeleteArticle:(NSDictionary *)inArticle
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inArticle);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingArticle:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchComments:(NSDictionary *)inComments
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComments);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingComments:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didCreateComment:(NSDictionary *)inComment
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComment);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingComment:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didReplyComment:(NSDictionary *)inComment
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComment);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailReplyingComment:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didMakeCommentPublic:(NSDictionary *)inComment
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComment);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailMakingCommentPublic:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didMakeCommentPrivate:(NSDictionary *)inComment
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComment);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailMakingCommentPrivate:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didMarkCommentAsSpam:(NSDictionary *)inComment
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComment);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailMarkingCommentAsSpam:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didUnmarkCommentAsSpam:(NSDictionary *)inComment
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inComment);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailUnmarkingCommentAsSpam:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didDeleteComment:(NSDictionary *)inMessage
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inMessage);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingComment:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchBlogSiteCategories:(NSDictionary *)inBlogSiteCategories
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inBlogSiteCategories);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingBlogSiteCategories:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumSetFolders:(NSDictionary *)inAlbumSetFolders
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumSetFolders);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumSetFolders:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didReorderAlbumSetFolders:(NSDictionary *)inAlbumSetFolders
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumSetFolders);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingAlbumSetFolders:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumSets:(NSDictionary *)inAlbumSets
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumSets);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumSets:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didCreateAlbumSet:(NSDictionary *)inAlbumSet
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumSet);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingAlbumSet:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didEditAlbumSet:(NSDictionary *)inAlbumSet
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumSet);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailEditingAlbumSet:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didDeleteAlbumSet:(NSDictionary *)inMessage
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inMessage);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingAlbumSet:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didReorderAlbumSets:(NSDictionary *)inAlbumSet
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumSet);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingAlbumSets:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumFolders:(NSDictionary *)inAlbumFolders
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumFolders);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumFolders:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumFolder:(NSDictionary *)inAlbumFolder
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumFolder);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumFolder:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didCreateAlbumFolder:(NSDictionary *)inAlbumFolder
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumFolder);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingAlbumFolder:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didEditAlbumFolder:(NSDictionary *)inAlbumFolder
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumFolder);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailEditingAlbumFolder:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didDeleteAlbumFolder:(NSDictionary *)inMessage
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inMessage);
//}
//- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingAlbumFolder:(NSError *)inError
//{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
//}
- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumElements:(NSDictionary *)inAlbumElements
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumElements);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumElements:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumElement:(NSDictionary *)inAlbumElement
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumElement);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumElement:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didProcessUploadingAlbumElement:(NSDictionary *)inProcess
{
//	NSLog(@"%s %@", __PRETTY_FUNCTION__, inProcess);
}
- (void)API:(ZBPixnetAPI *)inAPI didUploadAlbumElement:(NSDictionary *)inAlbumElement
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumElement);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailUploadingAlbumElement:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didEditAlbumElement:(NSDictionary *)inAlbumElement
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumElement);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingAlbumElement:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didDeleteAlbumElement:(NSDictionary *)inAlbumElement
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumElement);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingAlbumElement:(NSError *)inError
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inError);
}
- (void)API:(ZBPixnetAPI *)inAPI didReorderAlbumElement:(NSDictionary *)inAlbumElements
{
	NSLog(@"%s %@", __PRETTY_FUNCTION__, inAlbumElements);
}
- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingAlbumElement:(NSError *)inError
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

