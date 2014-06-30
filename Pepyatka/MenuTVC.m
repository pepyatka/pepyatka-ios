#import "MenuTVC.h"
#import "APIClient+Methods.h"


static const NSUInteger tagsSectionIndex = 2;

@implementation MenuTVC


- (void)refreshTagsWithCompletion:(void (^)(NSError *err, NSArray *tags))completion {
    [[APIClient defaultClient] getTagsWithCompletion:completion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[MenuTagCell nib] forCellReuseIdentifier:[MenuTagCell reuseID]];

    [self refreshTagsWithCompletion:^(NSError *err, NSArray *aTags) {
        if(!err) {
            tags = aTags;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)tapToUser:(UIButton *)b {
    if(0) { // signed in
        [self.delegate menuTVCWantsToShowSettings:self];
    } else { // not signed in
        [self.delegate menuTVCWantsToShowSignIn:self];
    }
}

- (IBAction)tapToService:(UIButton *)b {
    [self.delegate menuTVCWantsToShowMainFeed:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == tagsSectionIndex) {
        return tags.count;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == tagsSectionIndex) {
        MenuTagCell *cell = [tableView dequeueReusableCellWithIdentifier:[MenuTagCell reuseID]];
        cell.tagName = tags[indexPath.row];
        return cell;
    }
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == tagsSectionIndex) {
        NSString *tagName = tags[indexPath.row];
        [self.delegate menuTVC:self wantsToShowResultsByTag:tagName];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == tagsSectionIndex) {
        return 44.;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


@end
