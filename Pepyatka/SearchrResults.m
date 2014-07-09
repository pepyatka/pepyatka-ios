#import "SearchrResults.h"

@implementation SearchrResults
@synthesize orderedPosts;


- (instancetype)init {
    self = [super init];
    if (self) {
        orderedPosts = @[].mutableCopy;
        postsMap = @{}.mutableCopy;
    }
    return self;
}

- (void)clearAllPosts {
    [orderedPosts removeAllObjects];
    [postsMap removeAllObjects];
}


- (void)fillWithRAWServerPosts:(NSArray *)rawPosts {
    [self clearAllPosts];
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

- (NSUInteger)refreshAndReturnNewPostsWithSearchResults:(SearchrResults *)r {
    __block NSUInteger result = 0;
    
    [r.orderedPosts apply:^(ServerPost *newPost) {
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
