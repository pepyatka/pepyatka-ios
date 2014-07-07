#import <UIKit/UIKit.h>
#import "RSSCell.h"


@protocol RSSTVCDelegate;

@interface RSSTVC : UITableViewController <UISearchBarDelegate>{
    UISearchBar *searchBar;
    UIBarButtonItem *plusB;

    
    NSMutableArray *resultRSS, *filteredRSS;
    
}
@property (nonatomic, weak) id<RSSTVCDelegate> delegate;
@property (nonatomic, strong) NSArray *resultRSS;

@end


@protocol RSSTVCDelegate
- (void)didCompleteModificationsInRSSTVC:(RSSTVC *)avc;
@end