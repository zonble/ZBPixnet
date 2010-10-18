#import <Foundation/Foundation.h>
#import "ZBPixnetAPI.h"

extern NSString *const ZBPixnetCommentFilterWhisper;
extern NSString *const ZBPixnetCommentFilterNoSpam;
extern NSString *const ZBPixnetCommentFilterNoReply;

typedef enum {
	ZBPixnetBlogCategoryTypeCategory = 0,
	ZBPixnetBlogCategoryTypeFolder = 1
} ZBPixnetBlogCategoryType;

typedef enum {
	ZBPixnetBlogArticleStatusDeleted = 0,
	ZBPixnetBlogArticleStatusDraft = 1,
	ZBPixnetBlogArticleStatusPublished = 2,
	ZBPixnetBlogArticleStatusRequirePassword = 3,
	ZBPixnetBlogArticleStatusHidden = 4,
	ZBPixnetBlogArticleStatusFriendsOnly = 5,
	ZBPixnetBlogArticleStatusCoauthor = 7	
} ZBPixnetBlogArticleStatus;

typedef enum {
	ZBPixnetCommentPermissionDefault = -1,
	ZBPixnetCommentPermissionClosed = 0,
	ZBPixnetCommentPermissionOpen = 1,
	ZBPixnetCommentPermissionMembersOnly = 2,
	ZBPixnetCommentPermissionFriendsOnly = 3
} ZBPixnetCommentPermission;

typedef enum {
	ZBPixnetAlbumSetPermissionPublic = 0,
	ZBPixnetAlbumSetPermissionFriendsOnly = 1,
	ZBPixnetAlbumSetPermissionClubsOnly = 2,
	ZBPixnetAlbumSetPermissionRequirePassword = 3,
	ZBPixnetAlbumSetPermissionHidden = 4,
	ZBPixnetAlbumSetPermissionFriendGroupsOnly = 5
} ZBPixnetAlbumSetPermission;

#pragma mark -

@protocol ZBPixnetAPIDelegate <NSObject>

@optional

#pragma mark Account

- (void)API:(ZBPixnetAPI *)inAPI didFetchAccountInfo:(NSDictionary *)inAccountInfo;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAccountInfo:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchUserInfo:(NSDictionary *)inUserInfo;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingUserInfo:(NSError *)inError;

#pragma mark -
#pragma mark Blog categories

- (void)API:(ZBPixnetAPI *)inAPI didFetchBlogCategories:(NSDictionary *)inBlogCategories;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingBlogCategories:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateBlogCategory:(NSDictionary *)inBlogCategory;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingBlogCategory:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didEditBlogCategory:(NSDictionary *)inBlogCategory;
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingBlogCategory:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didDeleteBlogCategory:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingBlogCategory:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didReorderBlogCategories:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingBlogCategories:(NSError *)inError;

#pragma mark Blog Articles

- (void)API:(ZBPixnetAPI *)inAPI didFetchArticles:(NSDictionary *)inArticles;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticles:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchArticle:(NSDictionary *)inArticle;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingArticle:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateArticle:(NSDictionary *)inArticle;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingArticle:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didEditArticle:(NSDictionary *)inArticle;
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingArticle:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didDeleteArticle:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingArticle:(NSError *)inError;

#pragma mark Blog Comments

- (void)API:(ZBPixnetAPI *)inAPI didFetchComments:(NSDictionary *)inComments;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingComments:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateComment:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingComment:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchComment:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingComment:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didReplyComment:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailReplyingComment:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didMakeCommentPublic:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailMakingCommentPublic:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didMakeCommentPrivate:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailMakingCommentPrivate:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didMarkCommentAsSpam:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailMarkingCommentAsSpam:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didUnmarkCommentAsSpam:(NSDictionary *)inComment;
- (void)API:(ZBPixnetAPI *)inAPI didFailUnmarkingCommentAsSpam:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didDeleteComment:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingComment:(NSError *)inError;

#pragma mark Blog Site Categories

- (void)API:(ZBPixnetAPI *)inAPI didFetchBlogSiteCategories:(NSDictionary *)inBlogSiteCategories;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingBlogSiteCategories:(NSError *)inError;

#pragma mark -
#pragma mark Album Set Folders

- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumSetFolders:(NSDictionary *)inAlbumSetFolders;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumSetFolders:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didReorderAlbumSetFolders:(NSDictionary *)inAlbumSetFolders;
- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingAlbumSetFolders:(NSError *)inError;

#pragma mark Album Sets

- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumSets:(NSDictionary *)inAlbumSets;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumSets:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateAlbumSet:(NSDictionary *)inAlbumSet;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingAlbumSet:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didEditAlbumSet:(NSDictionary *)inAlbumSet;
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingAlbumSet:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didDeleteAlbumSet:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingAlbumSet:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didReorderAlbumSets:(NSDictionary *)inAlbumSet;
- (void)API:(ZBPixnetAPI *)inAPI didFailReorderingAlbumSets:(NSError *)inError;

#pragma mark Album Folders

- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumFolders:(NSDictionary *)inAlbumFolders;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumFolders:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchAlbumFolder:(NSDictionary *)inAlbumFolder;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAlbumFolder:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didCreateAlbumFolder:(NSDictionary *)inAlbumFolder;
- (void)API:(ZBPixnetAPI *)inAPI didFailCreatingAlbumFolder:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didEditAlbumFolder:(NSDictionary *)inAlbumFolder;
- (void)API:(ZBPixnetAPI *)inAPI didFailEditingAlbumFolder:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didDeleteAlbumFolder:(NSDictionary *)inMessage;
- (void)API:(ZBPixnetAPI *)inAPI didFailDeletingAlbumFolder:(NSError *)inError;

@end

#pragma mark -

@interface ZBPixnetAPI(Pixnet)

#pragma mark Account

- (void)fetchAccountInfoWithDelegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchUserInfo:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark -
#pragma mark Blog categories

- (void)fetchBlogCategoriesOfUser:(NSString *)userID password:(NSString *)password delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createBlogCategorieWithCategoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)editBlogCategory:(NSString *)categoryID categoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteBlogCategory:(NSString *)categoryID type:(ZBPixnetBlogCategoryType)type delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)reorderBlogCategoriesWithIDArray:(NSArray *)categoryIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Blog Articles

- (void)fetchArticlesOfUser:(NSString *)userID password:(NSString *)password page:(NSUInteger)page articlesPerPage:(NSUInteger)perPage category:(NSString *)categoryID hideAuthorInfo:(BOOL)hideAuthorInfo delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchArticle:(NSString *)articleID user:(NSString *)userID password:(NSString *)password articlePassword:(NSString *)articlePassword delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createArticleWithTitle:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)editArticle:(NSString *)articleID title:(NSString *)title body:(NSString *)body status:(ZBPixnetBlogArticleStatus)status publishDate:(NSDate *)publishDate category:(NSString *)categoryID siteCategory:(NSString *)siteCategoryID useNL2BR:(BOOL)useNL2BR commentPermission:(ZBPixnetCommentPermission)commentPermission hideComments:(BOOL)hideComments trackbackURLs:(NSArray *)trackbackURLs articlePassword:(NSString *)articlePassword passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs notifyTwitter:(BOOL)notifyTwitter notifyFacebook:(BOOL)notifyFacebook delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteArticle:(NSString *)articleID delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Blog Comments

- (void)fetchBlogCommentsWithUserID:(NSString *)userID article:(NSString *)articleID password:(NSString *)password articlePassword:(NSString *)articlePassword filter:(NSString *)filter page:(NSUInteger)page commentsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createBlogCommentForArticle:(NSString *)articleID body:(NSString *)body blogOwner:(NSString *)ownerUserID commenterNickname:(NSString *)nickname title:(NSString *)title commenterURL:(NSString *)URLString commenterEmail:(NSString *)email publicComment:(BOOL)publicComment password:(NSString *)password articlePassword:(NSString *)articlePassword delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchBlogComment:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)replyBlogComment:(NSString *)commentID body:(NSString *)body delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)makeCommentPublic:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)makeCommentPrivate:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)markCommentAsSpam:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)unmarkCommentAsSpam:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteComment:(NSString *)commentID delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Blog Site Categories

- (void)fetchBlogSiteCategoriesIncludingGroups:(BOOL)includeGroups containThumbnails:(BOOL)containThumbnails delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark -
#pragma mark Album Set Folders

- (void)fetchAlbumSetFoldersOfUser:(NSString *)userID hideUserInfo:(BOOL)hideUserInfo page:(NSUInteger)page albumSetsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)reorderAlbumSetFoldersWithIDArray:(NSArray *)albumSetFolderIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Album Sets

- (void)fetchAlbumSetsOfUser:(NSString *)userID parent:(NSString *)parentID hideUserInfo:(BOOL)hideUserInfo page:(NSUInteger)page albumSetsPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createAlbumSetWithTitle:(NSString *)title description:(NSString *)description permission:(ZBPixnetAlbumSetPermission)permission category:(NSString *)categoryID disableRightClick:(BOOL)disableRightClick useCCLicense:(BOOL)useCCLicense commentPermission:(ZBPixnetCommentPermission)commentPermission password:(NSString *)password passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parent:(NSString *)parentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)editAlbumSet:(NSString *)albumSetID title:(NSString *)title description:(NSString *)description permission:(ZBPixnetAlbumSetPermission)permission category:(NSString *)categoryID disableRightClick:(BOOL)disableRightClick useCCLicense:(BOOL)useCCLicense commentPermission:(ZBPixnetCommentPermission)commentPermission password:(NSString *)password passwordHint:(NSString *)hint friendGroupIDs:(NSArray *)friendGroupIDs allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parent:(NSString *)parentID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteAlbumSet:(NSString *)albumSetID  delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)reorderAlbumSetsWithIDArray:(NSArray *)albumSetIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Album Folders

- (void)fetchAlbumFolderOfUser:(NSString *)userID hideUserInfo:(BOOL)hideUserInfo page:(NSUInteger)page albumFoldersPerPage:(NSUInteger)perPage delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchAlbumFolder:(NSString *)albumFolderID albumOwner:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createAlbumFolderWithTitle:(NSString *)title desciption:(NSString *)desciption delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)editAlbumFolder:(NSString *)albumFolderID title:(NSString *)title desciption:(NSString *)desciption delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteAlbumFolder:(NSString *)albumFolderID delegate:(id <ZBPixnetAPIDelegate>)delegate;



@end
