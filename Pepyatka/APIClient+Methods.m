#import "APIClient+Methods.h"
#import "NSError+Message.h"


#define Call(completion) if(completion) completion

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
        Call(completion)(err, nil);
    } else {
        NSError *JSONError = [NSError JSONErrorFromResponse:res];
        if(JSONError) {
            Call(completion)(JSONError, nil);
        } else {
            ServerUser *user = [ServerUser new];
            [user fillFromDictionary:res];
            
            Call(completion)(nil, user);
        }
    }
}

- (void)processUserContainedResponse:(NSDictionary *)res error:(NSError *)err
                          completion:(void (^)(NSError *err, ServerUser *user))completion
{
    if(err) {
        Call(completion)(err, nil);
    } else {
        NSError *JSONError = [NSError JSONErrorFromResponse:res];
        if(JSONError) {
            Call(completion)(JSONError, nil);
        } else {
            if(![res isKindOfClass:[NSDictionary class]]) {
                Call(completion)([NSError errorWithMessage:NSLocalizedString(@"login/register: the response is not a dictionary with `user` field", nil)], nil);
            } else {
                NSDictionary *rawUser = [res[@"user"] noNullObject];
                ServerUser *user = [ServerUser new];
                [user fillFromDictionary:rawUser];
                Call(completion)(nil, user);
            }
        }
    }

}


- (NSURLSessionDataTask *)getTagsWithCompletion:(void (^)(NSError *err, NSArray *rawTags))completion {
    return
    [self get:@"/v1/tags" params:nil completion:^(NSError *err, id res) {
        Call(completion)(err, [res isKindOfClass:[NSArray class]]? res: nil);
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
    Call(completion)(nil);
    return nil;
}


@end
