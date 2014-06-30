#import <UIKit/UIKit.h>
#import "MenuTagCell.h"

@protocol MenuTVCDelegate;

@interface MenuTVC : UITableViewController {
    NSArray *tags;
}
@property (nonatomic, weak) id<MenuTVCDelegate> delegate;
@end

@protocol MenuTVCDelegate
- (void)menuTVCWantsToShowSignIn:(MenuTVC *)tvc;
- (void)menuTVCWantsToShowSettings:(MenuTVC *)tvc;
- (void)menuTVCWantsToShowMainFeed:(MenuTVC *)tvc;
- (void)menuTVC:(MenuTVC *)tvc wantsToShowResultsByTag:(NSString *)aTag;
- (void)menuTVC:(MenuTVC *)tvc wantsToShowSearchResultWithText:(NSString *)aText;
@end
