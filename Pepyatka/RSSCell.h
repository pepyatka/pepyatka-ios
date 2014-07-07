#import <UIKit/UIKit.h>

@interface RSSCell : UITableViewCell{
    __weak IBOutlet UILabel *rssL;
}

@property (nonatomic, strong) NSString *rssURL;

@end