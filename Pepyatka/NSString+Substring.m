#import "NSString+Substring.h"

@implementation NSString (Substring)

- (BOOL)isContentsSubstring:(NSString *)aSubstring {
    BOOL isContents = [self rangeOfString:aSubstring].location != NSNotFound;
    return isContents;
}

@end
