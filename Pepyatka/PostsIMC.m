#import "PostsIMC.h"
#import "APIClient+Methods.h"


#define DefaultLimit 25

@implementation PostsIMC


- (instancetype)initWithAPIClient:(__weak APIClient *)aClient timelineName:(NSString *)aTimelineName {
    self = [super init];
    if (self) {
        client = aClient;
        name = aTimelineName;
        timeline = [ServerTimeline new];
    }
    return self;
    
}

- (instancetype)initWithAPIClient:(APIClient *__weak)aClient searchText:(NSString *)aSearchText {
    self = [super init];
    if (self) {
        client = aClient;
        searchText = aSearchText;
        searchResults = [SearchrResults new];
    }
    return self;

}

- (NSUInteger)count {
    NSUInteger count = 0;
    if(timeline) {
        count = timeline.orderedPosts.count;
    } else {
        count = searchResults.orderedPosts.count;
    }
    return count;
}

- (ServerPost *)postAtIndex:(NSUInteger)i {
    ServerPost *post = nil;
    if(timeline) {
        post = timeline.orderedPosts[i];
    } else {
        post = searchResults.orderedPosts[i];
    }
    return post;
}

- (void)clear {
    [timeline clearAllPosts];
}

- (NSNumber *)newOffset {
    NSUInteger count = self.count;
    return count? @(count): nil;
}

- (NSNumber *)newLimit {
    return autoLimit;
}



- (void)loadNextTimelineWithClear:(BOOL)clear completion:(void (^)(NSError *err, NSUInteger newPostsCount))completion {
    currentTask =
    [client getTimelineWithName:name offset:(clear? nil: [self newOffset]) limit:[self newLimit] completion:^(NSError *err, ServerTimeline *t) {
        currentTask = nil;
        if(err) {
            CallIf(completion)(err, 0);
        } else {
            if(clear) {
                autoLimit = nil;
                [timeline clearAllPosts];
            }
            
            if(!autoLimit) {
                NSUInteger l = t.orderedPosts.count;
                autoLimit = @(l? l: DefaultLimit);
            }
            
            NSUInteger newPostsCount = [timeline refreshAndReturnNewPostsWithTimeline:t];
            
            CallIf(completion)(nil, newPostsCount);
        }
    }];

}

- (void)loadNextSearchResultsWithClear:(BOOL)clear completion:(void (^)(NSError *err, NSUInteger newPostsCount))completion {
    currentTask =
    [client getSearchResultsWithText:searchText offset:(clear? nil: [self newOffset]) limit:[self newLimit] completion:^(NSError *err, SearchrResults *r) {
        currentTask = nil;
        if(err) {
            CallIf(completion)(err, 0);
        } else {
            if(clear) {
                autoLimit = nil;
                [searchResults clearAllPosts];
            }
            
            if(!autoLimit) {
                NSUInteger l = r.orderedPosts.count;
                autoLimit = @(l? l: DefaultLimit);
            }
            
            NSUInteger newPostsCount = [searchResults refreshAndReturnNewPostsWithSearchResults:r];
            
            CallIf(completion)(nil, newPostsCount);
        }
    }];
    
}

- (BOOL)asyncLoadNextWithClear:(BOOL)clear completion:(void (^)(NSError *err, NSUInteger newPostsCount))completion {
    if(currentTask) {
        return NO;
    }
    
    if(timeline) {
        [self loadNextTimelineWithClear:clear completion:completion];
    } else {
        [self loadNextSearchResultsWithClear:clear completion:completion];
    }
    return YES;
}

- (void)cancel {
    [currentTask cancel];
}


@end
