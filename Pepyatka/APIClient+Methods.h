#import "APIClient.h"

@interface APIClient (Methods)

- (NSURLSessionDataTask *)getTagsWithCompletion:(void (^)(NSError *err, NSArray *rawTags))completion;


@end
