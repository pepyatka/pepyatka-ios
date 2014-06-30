#import <Foundation/Foundation.h>

//2013-02-13

@interface NSError (Message)

+ (NSError *)errorWithMessage:(NSString *)aMessage;
- (NSString *)message;

@end
