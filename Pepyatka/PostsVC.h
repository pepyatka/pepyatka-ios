#import <UIKit/UIKit.h>
#import "PostsIMC.h"
#import "PostCell.h"

@interface PostsVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *contentTV;
    NSMutableDictionary *offscreenCells;
    
    PostsIMC *imc;
    
}

- (instancetype)initWithAPIClient:(APIClient *)aClient timelineName:(NSString *)aTimelineName;
- (instancetype)initWithAPIClient:(APIClient *)aClient searchText:(NSString *)aSearchText;

@end
