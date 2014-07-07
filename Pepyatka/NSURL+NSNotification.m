#import "NSURL+NSNotification.h"

@implementation NSURL (NSNotification)

- (void)notify {
    [[NSNotificationCenter defaultCenter] postNotificationName:self.absoluteString object:nil];
}

@end


@implementation NSObject (NSURLNotifications)

- (void)addObserverForURL:(NSURL *)URL selector:(SEL)aSel {
    if(URL) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:aSel name:URL.absoluteString object:nil];
    }
}

- (void)removeObserverForURL:(NSURL *)URL {
    if(URL) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:URL.absoluteString object:nil];
    }
}

@end

