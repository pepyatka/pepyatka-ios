#import <Foundation/Foundation.h>
#import "AFNetworking/AFHTTPSessionManager.h"

@interface APIClient : NSObject {
    AFHTTPSessionManager *sessionManager;
}

@property (nonatomic, readonly) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)aBaseURL;

+ (instancetype)defaultClient;
+ (void)setDefaultClient:(APIClient *)aClient;

- (void)removeAllCookies;

@end


@interface APIClient (Dictionary)
+ (NSDictionary *)clientsDictionary;
+ (NSArray *)allClients;

+ (instancetype)withBaseURL:(NSURL *)URL;

- (void)saveClient;
- (void)removeClient;
@end


@interface APIClient (Requests)

- (NSURLSessionDataTask *)get:(NSString *)method params:(NSDictionary *)params completion:(void (^)(NSError *err, id res))completion;
- (NSURLSessionDataTask *)post:(NSString *)method params:(NSDictionary *)params completion:(void (^)(NSError *err, id res))completion;
- (NSURLSessionDataTask *)patch:(NSString *)method params:(NSDictionary *)params completion:(void (^)(NSError *err, id res))completion;

@end


