
#import "RSSCell.h"

@implementation RSSCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (NSString *)rssURL {
    return rssL.text;
}

- (void)setRssURL:(NSString *)url {
    rssL.text = url;
}

@end
