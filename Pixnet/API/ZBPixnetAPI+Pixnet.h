#import <Foundation/Foundation.h>
#import "ZBPixnetAPI.h"

extern NSString *const ZBPixnetCommentFilterWhisper;
extern NSString *const ZBPixnetCommentFilterNoSpam;
extern NSString *const ZBPixnetCommentFilterNoReply;

@protocol ZBPixnetAPIDelegate <NSObject>
@optional
#pragma mark Account
- (void)API:(ZBPixnetAPI *)inAPI didFetchAccountInfo:(NSDictionary *)inAccountInfo;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingAccountInfo:(NSError *)inError;

- (void)API:(ZBPixnetAPI *)inAPI didFetchUserInfo:(NSDictionary *)inUserInfo;
- (void)API:(ZBPixnetAPI *)inAPI didFailFetchingUserInfo:(NSError *)inError;

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


@end

#pragma mark -

@interface ZBPixnetAPI(Pixnet)

#pragma mark Account

- (void)fetchAccountInfoWithDelegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)fetchUserInfoWithUserID:(NSString *)userID delegate:(id <ZBPixnetAPIDelegate>)delegate;

#pragma mark Blog categories

- (void)fetchBlogCategoriesOfUser:(NSString *)userID password:(NSString *)password delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)createBlogCategorieWithCategoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)editBlogCategory:(NSString *)categoryID categoryName:(NSString *)categoryName description:(NSString *)description type:(ZBPixnetBlogCategoryType)type visible:(BOOL)visible siteCategory:(NSString *)siteCategoryID delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)deleteBlogCategory:(NSString *)categoryID type:(ZBPixnetBlogCategoryType)type delegate:(id <ZBPixnetAPIDelegate>)delegate;
- (void)reoderBlogCategoriesWithIDArray:(NSArray *)categoryIDArray delegate:(id <ZBPixnetAPIDelegate>)delegate;

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
@end
