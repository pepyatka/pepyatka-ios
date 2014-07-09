#import "APIClient+Methods.h"
#import "NSError+Message.h"

@interface NSError (JSONError)

+ (NSError *)JSONErrorFromResponse:(id)res;

@end

@implementation NSError (JSONError)

/* {"err":"user mibori doesn't exist","status":"fail"} */
+ (NSError *)JSONErrorFromResponse:(id)res {
    if([res isKindOfClass:[NSDictionary class]]) {
        NSString *message = [((NSDictionary *)res)[@"err"] noNullObject];
        return message? [NSError errorWithMessage:message.description]: nil;
    }
    return nil;
}

@end



@implementation APIClient (Methods)

- (void)processServerUserWithError:(NSError *)err response:(id)res
                        completion:(void (^)(NSError *err, ServerUser *user))completion
{
    if(err) {
        CallIf(completion)(err, nil);
    } else {
        NSError *JSONError = [NSError JSONErrorFromResponse:res];
        if(JSONError) {
            CallIf(completion)(JSONError, nil);
        } else {
            ServerUser *user = [ServerUser new];
            [user fillFromDictionary:res];
            
            CallIf(completion)(nil, user);
        }
    }
}

- (void)processUserContainedResponse:(NSDictionary *)res error:(NSError *)err
                          completion:(void (^)(NSError *err, ServerUser *user))completion
{
    if(err) {
        CallIf(completion)(err, nil);
    } else {
        NSError *JSONError = [NSError JSONErrorFromResponse:res];
        if(JSONError) {
            CallIf(completion)(JSONError, nil);
        } else {
            if(![res isKindOfClass:[NSDictionary class]]) {
                CallIf(completion)([NSError errorWithMessage:NSLocalizedString(@"login/register: the response is not a dictionary with `user` field", nil)], nil);
            } else {
                NSDictionary *rawUser = [res[@"user"] noNullObject];
                ServerUser *user = [ServerUser new];
                [user fillFromDictionary:rawUser];
                CallIf(completion)(nil, user);
            }
        }
    }

}


- (NSURLSessionDataTask *)getTagsWithCompletion:(void (^)(NSError *err, NSArray *rawTags))completion {
    return
    [self get:@"/v1/tags" params:nil completion:^(NSError *err, id res) {
        CallIf(completion)(err, [res isKindOfClass:[NSArray class]]? res: nil);
    }];
}


- (NSURLSessionDataTask *)loginWithUser:(NSString *)aUser passsword:(NSString *)aPassword
                             completion:(void (^)(NSError *err, ServerUser *user))completion
{
    return
    [self post:@"/v1/session"
        params:@{@"username": aUser, @"password": aPassword}
    completion:^(NSError *err, NSDictionary *res) {
        [self processUserContainedResponse:res error:err completion:completion];
    }];
}


- (NSURLSessionDataTask *)registerWithUser:(NSString *)aUser passsword:(NSString *)aPassword
                                completion:(void (^)(NSError *err, ServerUser *user))completion
{
    return
    [self post:@"/v1/signup"
        params:@{@"username": aUser, @"password": aPassword}
    completion:^(NSError *err, NSDictionary *res) {
        [self processUserContainedResponse:res error:err completion:completion];
    }];
}

- (NSURLSessionDataTask *)whoamiWithCompletion:(void (^)(NSError *err, ServerUser *user))completion {
    return
    [self get:@"/v1/whoami" params:nil completion:^(NSError *err, id res) {
        [self processServerUserWithError:err response:res completion:completion];
    }];
}

- (NSURLSessionDataTask *)getUserInfoWithUserID:(NSString *)userID
                                     completion:(void (^)(NSError *err, ServerUser *user))completion
{
    return
    [self get:[NSString stringWithFormat:@"/v1/users/%@", userID]
       params:nil
   completion:^(NSError *err, id res) {
       [self processServerUserWithError:err response:res completion:completion];
   }];
}

- (NSURLSessionDataTask *)updateServerUser:(ServerUser *)aServerUser
                                completion:(void (^)(NSError *err, ServerUser *user))completion
{
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = aServerUser.userID;
    
    if(aServerUser.email) {
        params[@"email"] = aServerUser.email;
    }
    
    if(aServerUser.screenName) {
        params[@"screenName"] = aServerUser.screenName;
    }
    
    if(aServerUser.receiveEmails) {
        params[@"receiveEmails"] = aServerUser.receiveEmails;
    }
    
    if(aServerUser.rss) {
        params[@"rss"] = aServerUser.rss;
    }
    
    return
    [self patch:@"/v1/users"
         params:@{@"params": params}
     completion:^(NSError *err, id res) {
         [self processServerUserWithError:err response:res completion:completion];
     }];
}


- (NSURLSessionDataTask *)pseudoLogoutWithCompletion:(void (^)(NSError *err))completion {
    [self removeAllCookies];
    CallIf(completion)(nil);
    return nil;
}


- (NSURLSessionDataTask *)getTimelineWithName:(NSString *)aName offset:(NSNumber *)anOffset limit:(NSNumber *)aLimit
                                   completion:(void (^)(NSError *err, ServerTimeline *timeline))completion
{
    NSString *method = [NSString stringWithFormat:@"/v1/timeline/%@", aName];
    NSMutableDictionary *params = @{}.mutableCopy;
    if(anOffset) {
        params[@"offset"] = anOffset;
    }
    
    if(aLimit) {
        params[@"limit"] = aLimit;
    }
    
    return
    [self get:method params:params completion:^(NSError *err, NSDictionary *res) {
        if(![res isKindOfClass:[NSDictionary class]]) {
            NSString *m = [NSString stringWithFormat:@"GET %@ -> %@\n Error, it must return an dictionary.", method, res];
            CallIf(completion)([NSError errorWithMessage:m], nil);
            return;
        }
        
        if(!res.count) {
            NSString *m = [NSString stringWithFormat:@"GET %@ -> %@\n Error, it must not be empty.", method, res];
            CallIf(completion)([NSError errorWithMessage:m], nil);
            return;
        }
        
        NSError *jsonErr = [NSError JSONErrorFromResponse:res];
        if(jsonErr) {
            CallIf(completion)(jsonErr, nil);
            return;
        }
        
        ServerTimeline *t = [ServerTimeline new];
        [t fillWithDictionary:res];
        
        CallIf(completion)(nil, t);
    }];
}


- (NSURLSessionDataTask *)getSearchResultsWithText:(NSString *)aText offset:(NSNumber *)anOffset limit:(NSNumber *)aLimit
                                        completion:(void (^)(NSError *err, SearchrResults *searchResults))completion
{
    NSString *method = [NSString stringWithFormat:@"/v1/search/%@", [aText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *params = @{}.mutableCopy;
    if(anOffset) {
        params[@"offset"] = anOffset;
    }
    
    if(aLimit) {
        params[@"limit"] = aLimit;
    }
    
    return
    [self get:method params:params completion:^(NSError *err, NSDictionary *res) {
        if(![res isKindOfClass:[NSDictionary class]]) {
            NSString *m = [NSString stringWithFormat:@"GET %@ -> %@\n Error, it must return an dictionary.", method, res];
            CallIf(completion)([NSError errorWithMessage:m], nil);
            return;
        }
        
        if(!res.count) {
            NSString *m = [NSString stringWithFormat:@"GET %@ -> %@\n Error, it must not be empty.", method, res];
            CallIf(completion)([NSError errorWithMessage:m], nil);
            return;
        }
        
        NSError *jsonErr = [NSError JSONErrorFromResponse:res];
        if(jsonErr) {
            CallIf(completion)(jsonErr, nil);
            return;
        }
        
        NSArray *rawPosts = [res[@"posts"] noNullObject];
        if(![rawPosts isKindOfClass:[NSArray class]]) {
            NSString *m = [NSString stringWithFormat:@"GET %@ -> %@\n Error, the `posts` must be an dictionary.", method, res];
            CallIf(completion)([NSError errorWithMessage:m], nil);
            return;
        }
        
        SearchrResults *r = [SearchrResults new];
        [r fillWithRAWServerPosts:rawPosts];
        
        
        CallIf(completion)(nil, r);
    }];

}



@end
