#import "MenuTVC.h"

static const NSUInteger pointsSectionIndex = 1;
static const NSUInteger tagsSectionIndex = 2;

@implementation MenuTVC


- (APIClient *)currentClient {
    APIClient *client = [APIClient allClients][0];
    return client;
}

- (void)refreshTagsWithCompletion:(void (^)(NSError *err, NSArray *tags))completion {
    [[self currentClient] getTagsWithCompletion:completion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[MenuTagCell nib] forCellReuseIdentifier:[MenuTagCell reuseID]];
    [self.tableView registerNib:[MenuProfileCell nib] forCellReuseIdentifier:[MenuProfileCell reuseID]];

    tags = [self currentClient].server.tags;
    [self.tableView reloadData];
    [self refreshTagsWithCompletion:^(NSError *err, NSArray *aTags) {
        if(!err) {
            [[self currentClient] dbMergeTags:aTags save:YES];
            tags = aTags;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == tagsSectionIndex) {
        return tags.count;
    }
    
    if(section == pointsSectionIndex) {
        return [APIClient allClients].count;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == tagsSectionIndex) {
        MenuTagCell *cell = [tableView dequeueReusableCellWithIdentifier:[MenuTagCell reuseID]];
        cell.tagName = tags[indexPath.row];
        return cell;
    }
    
    if(indexPath.section == pointsSectionIndex) {
        MenuProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[MenuProfileCell reuseID]];
        cell.delegate = self;
        cell.apiClient = [APIClient allClients][indexPath.row];
        [cell asyncWhoAmI];
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
        [self.delegate menuTVC:self wantsToShowResultsByTag:tagName APIClient:[self currentClient]];
    }
    
    if(indexPath.section == pointsSectionIndex) {
        [self.delegate menuTVC:self didTapPointWithAPIClient:[APIClient allClients][indexPath.row]];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == tagsSectionIndex) {
        return 44.;
    }
    
    if(indexPath.section == pointsSectionIndex) {
        return 44.;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - @protocol MenuProfileCellDelegate
- (void)wantsShowSignInInMenuProfileCell:(MenuProfileCell *)aCell {
    [self.delegate menuTVC:self wantsToShowSignInWithAPIClient:aCell.apiClient];
}

- (void)wantsShowSettingsInMenuProfileCell:(MenuProfileCell *)aCell {
    [self.delegate menuTVC:self wantsToShowSettingsWithAPIClient:aCell.apiClient];
}


#pragma mark - @protocol UISearchBarDelegate <UIBarPositioningDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.delegate menuTVC:self wantsToShowSearchResultWithText:searchBar.text APIClient:[self currentClient]];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(!searchText.length) {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0.1];
    }
}

@end
