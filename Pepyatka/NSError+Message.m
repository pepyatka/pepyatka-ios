#import "NSError+Message.h"

static NSString *kMessageKey = @"ErrorMessage";

@implementation NSError (Message)

+ (NSError *)errorWithMessage:(NSString *)aMessage {
    NSDictionary *userInfo = @{ kMessageKey: (aMessage? aMessage: @"") };
    return [NSError errorWithDomain:@"DefaultDomain" code:0
                           userInfo:userInfo];
}

- (NSString *)message {
    return [self.userInfo objectForKey:kMessageKey];
}


@end
