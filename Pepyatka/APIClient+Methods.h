#import "APIClient.h"
#import "ServerUser.h"

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


@end
