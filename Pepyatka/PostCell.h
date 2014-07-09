#import <UIKit/UIKit.h>


@interface PostCell : UITableViewCell {
    UILabel *titleL;
    UILabel *bodyL;

    BOOL didSetupConstraints;
}


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;

- (void)updateFonts;

+ (NSString *)reuseID;

@end
