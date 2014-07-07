#import "APIClient.h"

static APIClient *defaultAPIClient = nil;
static NSMutableDictionary *APIClients = nil;

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
        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};

        
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:aBaseURL /*sessionConfiguration:configuration */];
        [sessionManager.requestSerializer setValue:@"application/json"
                                forHTTPHeaderField:@"ACCEPT"];
        sessionManager.responseSerializer.acceptableContentTypes
        = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

//        sessionManager.responseSerializer.acceptableContentTypes
//        = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];

//        application/json

    }
    return self;
}


+ (instancetype)defaultClient {
    return defaultAPIClient;
}


+ (void)setDefaultClient:(APIClient *)aClient {
    defaultAPIClient = aClient;
}


- (void)removeAllCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:self.baseURL];
    [cookies apply:^(NSHTTPCookie *cookie) {
        [cookieStorage deleteCookie:cookie];
    }];
}


@end

@implementation APIClient (Dictionary)

+ (NSDictionary *)clientsDictionary {
    if(!APIClients) {
        APIClients = @{}.mutableCopy;
    }
    return APIClients;
}

+ (NSArray *)allClients {
    return
    [self.clientsDictionary.allValues sortedArrayUsingComparator:^NSComparisonResult(APIClient *c1, APIClient *c2) {
        return [c1.baseURL.absoluteString compare:c2.baseURL.absoluteString];
    }];
}

+ (instancetype)withBaseURL:(NSURL *)URL {
    return self.clientsDictionary[URL.absoluteString];
}

- (void)saveClient {
    ((NSMutableDictionary *)[APIClient clientsDictionary])[self.baseURL.absoluteString] = self;
}


- (void)removeClient {
    [(NSMutableDictionary *)[APIClient clientsDictionary] removeObjectForKey:self.baseURL.absoluteString];
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
                          completion(error.failureError, nil);
                      }
                  }];
    return t;
}

- (NSURLSessionDataTask *)post:(NSString *)method params:(NSDictionary *)params completion:(void (^)(NSError *err, id res))completion {
    NSURLSessionDataTask *t
    = [sessionManager POST:method parameters:params
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       if(completion) {
                           completion(nil, responseObject);
                       }
                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                       if(completion) {
                           completion(error.failureError, nil);
                       }
                   }];
    return t;
}

- (NSURLSessionDataTask *)patch:(NSString *)method params:(NSDictionary *)params completion:(void (^)(NSError *err, id res))completion {
    NSURLSessionDataTask *t
    = [sessionManager PATCH:method parameters:params
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       if(completion) {
                           completion(nil, responseObject);
                       }
                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                       if(error) {
                           NSLog(@"%@ %@ -> %@", method, params, error);
                       }
                       
                       
                       if(completion) {
                           completion(error.failureError, nil);
                       }
                   }];
    return t;
}


@end
