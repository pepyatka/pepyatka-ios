#import <Foundation/Foundation.h>
#import "UIAlertView+Blocks.h"
#import "NSError+Message.h"

@interface NSError (MessageUIAlertView)

- (void)showAlertWithCompletion:(void (^)(void))completion;
- (void)showAlert;

@end
