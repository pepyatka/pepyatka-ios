#import "NSError+Message+UIAlertView.h"

@implementation NSError (MessageUIAlertView)

- (void)showAlertWithCompletion:(void (^)(void))completion {
    [UIAlertView showAlertWithTitle:@"Error"
                            message:self.message
                        buttonTitle:@"Ok"
                            handler:^{ if(completion){ completion(); } }];
}

- (void)showAlert {
    [self showAlertWithCompletion:nil];
}

@end
