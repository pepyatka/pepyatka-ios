
#import "RSSTVC.h"

@implementation RSSTVC
@synthesize resultRSS = resultRSS;


- (void)setupSearchBar {
    if(!searchBar) {
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        searchBar.delegate = self;
        searchBar.barTintColor = [UIColor navBgColor];
        self.navigationItem.titleView = searchBar;
    }
}

- (void)setupPlusButton {
    if(!plusB) {
        plusB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                              target:self action:@selector(tapPlus:)];

        self.navigationItem.rightBarButtonItem = plusB;
    }
}


- (void)setupSource {
    if(!resultRSS) {
        resultRSS = @[].mutableCopy;
    }
    
    if(!filteredRSS) {
        filteredRSS = @[].mutableCopy;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSource];
    
    
    [self setupSearchBar];
    [self setupPlusButton];

    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self makefilteredFromResultRSS];
    plusB.enabled = [self isPlusActive];
    [self.tableView reloadData];
    
}

- (void)makefilteredFromResultRSS {
    [filteredRSS removeAllObjects];
    
    NSString *text = searchBar.text.trimmedString;
    if(text.length) {
        [resultRSS apply:^(NSString *url) {
            if([url isContentsSubstring:text]) {
                [filteredRSS addObject:url];
            }
        }];
    } else {
        [filteredRSS addObjectsFromArray:resultRSS];
    }
}


- (void)setResultRSS:(NSArray *)rss {
    [self setupSource];
    [resultRSS removeAllObjects];
    [resultRSS addObjectsFromArray:rss];
    [self makefilteredFromResultRSS];
    plusB.enabled = [self isPlusActive];
    [self.tableView reloadData];
}

- (BOOL)isPlusActive {
    NSString *text = searchBar.text.trimmedString;
    NSString *foundRSS = [resultRSS firstObjectWithPredicate:^BOOL(NSString *url) {
        return [url.trimmedString isEqualToString:text];
    }];
    return foundRSS? NO: YES;
}

#pragma mark - Actions

- (void)tapPlus:(UIBarButtonItem *)b {
    NSString *text = searchBar.text.trimmedString;
    searchBar.text = @"";
    [resultRSS insertObject:text atIndex:0];
    [self makefilteredFromResultRSS];
    plusB.enabled = [self isPlusActive];
    [self.tableView reloadData];
}

- (void)popToBackAction:(UIButton *)b {
    [self.delegate didCompleteModificationsInRSSTVC:self];
    [super popToBackAction:b];
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self makefilteredFromResultRSS];
    plusB.enabled = [self isPlusActive];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredRSS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"RSSCell";
    RSSCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.rssURL = filteredRSS[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"RSS", nil);
}



#pragma mark - UITableViewDelegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = filteredRSS[indexPath.row];
        url = url.trimmedString;
        NSNumber *index = [resultRSS indexOfFirstObjectWithPredicate:^BOOL(NSString *str) {
            return [url isEqualToString:str.trimmedString];
        }];
        if(index){
            [resultRSS removeObjectAtIndex:index.unsignedIntegerValue];
        }
        [self makefilteredFromResultRSS];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}





@end
