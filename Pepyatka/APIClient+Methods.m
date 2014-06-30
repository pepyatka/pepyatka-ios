#import "APIClient+Methods.h"

@implementation APIClient (Methods)

- (NSURLSessionDataTask *)getTagsWithCompletion:(void (^)(NSError *err, NSArray *rawTags))completion {
    return
    [self get:@"/v1/tags" params:nil completion:^(NSError *err, id res) {
        if(completion) {
            completion(err, [res isKindOfClass:[NSArray class]]? res: nil);
        }
    }];
}


@end
