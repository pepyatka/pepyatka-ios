#import <Foundation/Foundation.h>
#import "ServerTimeline.h"
#import "SearchrResults.h"
#import "ServerPost.h"


/* Timeline/Search results in-memory collector  */

@interface PostsIMC : NSObject {
    __weak APIClient *client;
    NSString *name;
    NSString *searchText;
    
    ServerTimeline *timeline;
    SearchrResults *searchResults;
    
    NSURLSessionDataTask *currentTask;


    NSNumber *autoLimit;
}

@property (readonly) NSUInteger count;
- (ServerPost *)postAtIndex:(NSUInteger)i;
- (void)clear;
- (BOOL)asyncLoadNextWithClear:(BOOL)clear completion:(void (^)(NSError *err, NSUInteger newPostsCount))completion;

- (void)cancel;

- (instancetype)initWithAPIClient:(__weak APIClient *)aClient timelineName:(NSString *)aTimelineName;
- (instancetype)initWithAPIClient:(APIClient *__weak)aClient searchText:(NSString *)aSearchText;


@end
