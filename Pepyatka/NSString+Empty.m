#import "NSString+Empty.h"

@implementation NSString (Empty)

- (NSString *)trimmedString {
    NSCharacterSet *trimset = [NSCharacterSet characterSetWithCharactersInString:@"\n\r\t "];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:trimset];
    return trimmed;
}

- (BOOL)isEmpty {
    if(self.length == 0) {
        return YES;
    } else {
        NSString *trimmed = self.trimmedString;
        return trimmed.length == 0;
    }
}

- (BOOL)isNotEmpty {
    return !self.isEmpty;
}

@end
