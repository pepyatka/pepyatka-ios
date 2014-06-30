#import "APIClient.h"

static APIClient *defaultAPIClient = nil;

@interface NSError (APIClient)

@property (nonatomic, readonly) NSError *failureError;

@end

@implementation NSError (APIClient)

- (NSError *)failureError {
    NSError *error = [NSError errorWithMessage:error.description];
    return error;
}

@end

@implementation APIClient

- (NSURL *)baseURL {
    return sessionManager.baseURL;
}

- (instancetype)initWithBaseURL:(NSURL *)aBaseURL {
    self = [super init];
    if (self) {
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:aBaseURL];
        [sessionManager.requestSerializer setValue:@"application/json"
                                forHTTPHeaderField:@"ACCEPT"];
        sessionManager.responseSerializer.acceptableContentTypes
        = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    }
    return self;
}


+ (instancetype)defaultClient {
    return defaultAPIClient;
}


+ (void)setDefaultClient:(APIClient *)aClient {
    defaultAPIClient = aClient;
}


@end


@implementation APIClient (Requests)

- (NSURLSessionDataTask *)get:(NSString *)method params:(NSDictionary *)params completion:(void (^)(NSError *err, id res))completion {
    NSURLSessionDataTask *t
    = [sessionManager GET:method parameters:params
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if(completion) {
                          completion(nil, responseObject);
                      }
                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                      if(completion) {
                          
                      }
                  }];
    return t;
}

@end
