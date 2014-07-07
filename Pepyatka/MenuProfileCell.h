#import <UIKit/UIKit.h>
#import "APIClient.h"
#import "User+Utils.h"


@protocol MenuProfileCellDelegate;

@interface MenuProfileCell : UITableViewCell {
    __weak IBOutlet UILabel *pointL;
    __weak IBOutlet UILabel *usernameL;
    __weak IBOutlet UIButton *profileB;
    __weak IBOutlet UIActivityIndicatorView *indicatorV;
    __weak APIClient *apiClient;
    
    __weak NSURLSessionDataTask *task;
    
    User *user;
}

@property (nonatomic, weak) id<MenuProfileCellDelegate> delegate;
@property (nonatomic, weak) APIClient *apiClient;

- (void)asyncWhoAmI;

+ (NSString *)reuseID;

@end

@protocol MenuProfileCellDelegate
- (void)wantsShowSignInInMenuProfileCell:(MenuProfileCell *)aCell;
- (void)wantsShowSettingsInMenuProfileCell:(MenuProfileCell *)aCell;
@end


