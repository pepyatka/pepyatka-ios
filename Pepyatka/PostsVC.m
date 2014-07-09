#import "PostsVC.h"


@implementation PostsVC

- (instancetype)initWithAPIClient:(APIClient *)aClient timelineName:(NSString *)aTimelineName {
    self = [super init];
    if (self) {
        self.title = aTimelineName;
        imc = [[PostsIMC alloc] initWithAPIClient:aClient timelineName:aTimelineName];
        offscreenCells = @{}.mutableCopy;
    }
    return self;

}

- (instancetype)initWithAPIClient:(APIClient *)aClient searchText:(NSString *)aSearchText {
    self = [super init];
    if (self) {
        self.title = aSearchText;
        imc = [[PostsIMC alloc] initWithAPIClient:aClient searchText:aSearchText];
        offscreenCells = @{}.mutableCopy;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets insets = contentTV.contentInset;
    insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    contentTV.contentInset = insets;
    contentTV.scrollIndicatorInsets = insets;
    

    
    [contentTV registerClass:[PostCell class] forCellReuseIdentifier:[PostCell reuseID]];
    contentTV.estimatedRowHeight = UITableViewAutomaticDimension;
    contentTV.allowsSelection = NO;
    
    contentTV.alwaysBounceVertical = YES;
    [contentTV addPullToRefreshWithActionHandler:^{
        [imc asyncLoadNextWithClear:YES completion:^(NSError *err, NSUInteger newPostsCount) {
            if(err) {
                [contentTV.pullToRefreshView stopAnimating];
            } else {
                [contentTV reloadData];
                [contentTV.pullToRefreshView stopAnimating];
            }
        }];
    } position:SVPullToRefreshPositionTop];
    
    [contentTV addInfiniteScrollingWithActionHandler:^{
        if(contentTV.contentSize.height < contentTV.height) {
            [contentTV.infiniteScrollingView stopAnimating];
            return;
        }
        
        BOOL isProgress = [imc asyncLoadNextWithClear:NO completion:^(NSError *err, NSUInteger newPostsCount) {
            if(err) {
                [contentTV.infiniteScrollingView stopAnimating];
            } else {
                [contentTV.infiniteScrollingView stopAnimating];
                if(newPostsCount) {
                    [contentTV reloadData];
                }
            }
        }];
        
        if(!isProgress) {
            [contentTV.infiniteScrollingView stopAnimating];
        }
    }];
    
    
    [imc asyncLoadNextWithClear:YES completion:^(NSError *err, NSUInteger newPostsCount) {
        if(err) {
            return;
        }
        [contentTV reloadData];
    }];
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return imc.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [contentTV dequeueReusableCellWithIdentifier:[PostCell reuseID]];
    [cell updateFonts];
    
    ServerPost *post = [imc postAtIndex:indexPath.row];
    cell.title = post.createdBy.screenName;
    cell.body = post.body;
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = offscreenCells[[PostCell reuseID]];
    if(!cell) {
        cell = [PostCell new];
        offscreenCells[[PostCell reuseID]] = cell;
    }
    
    [cell updateFonts];
    
    ServerPost *post = [imc postAtIndex:indexPath.row];
    cell.title = post.createdBy.screenName;
    cell.body = post.body;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, contentTV.width, cell.height);
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1;
    
    return height;
}



@end
