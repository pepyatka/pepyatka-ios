#import <Foundation/Foundation.h>

@interface NSURL (NSNotification)

- (void)notify;

@end

@interface NSObject (NSURLNotifications)

- (void)addObserverForURL:(NSURL *)URL selector:(SEL)aSel;
- (void)removeObserverForURL:(NSURL *)URL;

@end
