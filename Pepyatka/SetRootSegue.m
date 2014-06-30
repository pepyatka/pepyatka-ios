#import "SetRootSegue.h"

@implementation SetRootSegue

- (void)perform {
    UINavigationController *navVC = self.sourceViewController;
    UIViewController *rootVC = self.destinationViewController;
    [navVC setViewControllers:@[rootVC] animated:YES];
}


@end
