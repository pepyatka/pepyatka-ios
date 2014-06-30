#import <UIKit/UIKit.h>

@interface MenuTagCell : UITableViewCell {
    __weak IBOutlet UILabel *tagL;
}

@property (nonatomic, strong) NSString *tagName;

+ (NSString *)reuseID;

@end
