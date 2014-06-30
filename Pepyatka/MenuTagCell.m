#import "MenuTagCell.h"

@implementation MenuTagCell

+ (NSString *)reuseID {
    static NSString *reuseID = @"MenuTagCell";
    return reuseID;
}


- (NSString *)tagName {
    return tagL.text;
}

- (void)setTagName:(NSString *)tn {
    tagL.text = tn;
}

@end

