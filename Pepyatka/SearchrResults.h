#import <Foundation/Foundation.h>
#import "ServerPost.h"

@interface SearchrResults : NSObject {
    NSMutableArray *orderedPosts;
    NSMutableDictionary *postsMap;
}

@property (nonatomic, readonly) NSArray *orderedPosts;

- (void)fillWithRAWServerPosts:(NSArray *)aRawServerPosts;
- (void)clearAllPosts;
- (NSUInteger)refreshAndReturnNewPostsWithSearchResults:(SearchrResults *)r;

@end
