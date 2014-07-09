#import "ServerTimeline.h"

@implementation ServerTimeline
@synthesize orderedPosts = orderedPosts;



- (void)clearAllPosts {
    [orderedPosts removeAllObjects];
    [postsMap removeAllObjects];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        orderedPosts = @[].mutableCopy;
        postsMap = @{}.mutableCopy;
    }
    return self;
}

- (void)fillWithDictionary:(NSDictionary *)d {
    if(!d) {
        return;
    }
    
    self.timelineID = [d[@"id"] noNullObject];
    self.name = [d[@"name"] noNullObject];
    
    
    NSDictionary *rawUser = [d[@"user"] noNullObject];
    ServerUser *user = [ServerUser new];
    if([rawUser isKindOfClass:[NSDictionary class]]) {
        [user fillFromDictionary:rawUser];
    }
    self.user = user;
    
#warning todo: statistics
#warning todo: subscribers
#warning todo: subscriptions
    
    [self clearAllPosts];
    NSArray *rawPosts = [d[@"posts"] noNullObject];
    if([rawPosts isKindOfClass:[NSArray class]]) {
        [rawPosts apply:^(NSDictionary *rawPost) {
            if([rawPost isKindOfClass:[NSDictionary class]]) {
                ServerPost *post = [ServerPost new];
                [post fillFromDictionary:rawPost];
                [orderedPosts addObject:post];
                postsMap[post.postID] = post;
            }
        }];
    }
    
}


- (NSUInteger)refreshAndReturnNewPostsWithTimeline:(ServerTimeline *)t {
    __block NSUInteger result = 0;
    self.statistics = t.statistics;
    self.subscribers = t.subscribers;
    self.subscriptions = t.subscriptions;
    
    [t.orderedPosts apply:^(ServerPost *newPost) {
        ServerPost *oldPost = postsMap[newPost.postID];
        if(oldPost) {
            [oldPost refreshWithPost:newPost];
        } else {
            [orderedPosts addObject:newPost];
            postsMap[newPost.postID] = newPost;
            result ++;
        }
    }];
    
    
    return result;
}

@end
