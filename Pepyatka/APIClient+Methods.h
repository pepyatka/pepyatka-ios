#import "APIClient.h"
#import "ServerUser.h"
#import "ServerTimeline.h"
#import "SearchrResults.h"

@interface APIClient (Methods)

- (NSURLSessionDataTask *)getTagsWithCompletion:(void (^)(NSError *err, NSArray *rawTags))completion;

- (NSURLSessionDataTask *)loginWithUser:(NSString *)aUser passsword:(NSString *)aPassword
                             completion:(void (^)(NSError *err, ServerUser *user))completion;

- (NSURLSessionDataTask *)registerWithUser:(NSString *)aUser passsword:(NSString *)aPassword
                             completion:(void (^)(NSError *err, ServerUser *user))completion;

- (NSURLSessionDataTask *)whoamiWithCompletion:(void (^)(NSError *err, ServerUser *user))completion;

- (NSURLSessionDataTask *)getUserInfoWithUserID:(NSString *)userID
                                     completion:(void (^)(NSError *err, ServerUser *user))completion;

- (NSURLSessionDataTask *)updateServerUser:(ServerUser *)aServerUser
                                completion:(void (^)(NSError *err, ServerUser *user))completion;

- (NSURLSessionDataTask *)pseudoLogoutWithCompletion:(void (^)(NSError *err))completion;

- (NSURLSessionDataTask *)getTimelineWithName:(NSString *)aName offset:(NSNumber *)anOffest limit:(NSNumber *)aLimit
                                   completion:(void (^)(NSError *err, ServerTimeline *timeline))completion;

- (NSURLSessionDataTask *)getSearchResultsWithText:(NSString *)aText offset:(NSNumber *)anOffset limit:(NSNumber *)aLimit
                                   completion:(void (^)(NSError *err, SearchrResults *searchResults))completion;




@end




