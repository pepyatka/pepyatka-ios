#import <UIKit/UIKit.h>
#import "MenuTagCell.h"
#import "MenuProfileCell.h"
#import "APIClient.h"

@protocol MenuTVCDelegate;

@interface MenuTVC : UITableViewController <MenuProfileCellDelegate> {
    NSArray *tags;
    
}
@property (nonatomic, weak) id<MenuTVCDelegate> delegate;
@end

@protocol MenuTVCDelegate

- (void)menuTVC:(MenuTVC *)tvc wantsToShowSignInWithAPIClient:(__weak APIClient *)anAPIClient;
- (void)menuTVC:(MenuTVC *)tvc wantsToShowSettingsWithAPIClient:(__weak APIClient *)anAPIClient;
- (void)menuTVC:(MenuTVC *)tvc didTapPointWithAPIClient:(__weak APIClient *)anAPIClient;

- (void)menuTVC:(MenuTVC *)tvc wantsToShowResultsByTag:(NSString *)aTag;
- (void)menuTVC:(MenuTVC *)tvc wantsToShowSearchResultWithText:(NSString *)aText;
@end
