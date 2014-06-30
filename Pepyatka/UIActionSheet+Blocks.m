#import "UIActionSheet+Blocks.h"
#import <objc/runtime.h>


@interface NSObject (UIAlertViewAssociatedObjects)
- (void)associateValue:(id)value withKey:(const char *)key;
- (id)associatedValueForKey:(const char *)key;
@end

static char *kActionSheetHandlersArrayKey = "UIActionSheetHandlersArrayKey";
static char *kActionSheetWillPresentBlockKey = "UIActionSheetWillPresentBlockKey";
static char *kActionSheetDidPresentBlockKey = "UIActionSheetDidPresentBlockKey";
static char *kActionSheetWillDismissBlockKey = "UIActionSheetWillDismissBlockKey";
static char *kActionSheetDidDismissBlockKey = "UIActionSheetDidDismissBlockKey";

@implementation NSObject (UIAlertViewAssociatedObjects)

- (void)associateValue:(id)value withKey:(const char *)key {
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedValueForKey:(const char *)key {
	return objc_getAssociatedObject(self, key);
}

@end

@implementation UIActionSheet (Blocks)


+ (instancetype)actionSheetWithTitle:(NSString *)title {
    return [[[self class] alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
}


//- (NSMutableDictionary *)handlers {
//    NSMutableDictionary *handlers = [self associatedValueForKey:kAlertViewHandlerDictionaryKey];
//    if (!handlers) {
//        handlers = [NSMutableDictionary dictionary];
//        [self associateValue:handlers withKey:kAlertViewHandlerDictionaryKey];
//    }
//    return handlers;
//}

- (NSMutableArray *)indexedHandlers {
    NSMutableArray *iHandlers = [self associatedValueForKey:kActionSheetHandlersArrayKey];
    if(!iHandlers) {
        iHandlers = [NSMutableArray array];
        [self associateValue:iHandlers withKey:kActionSheetHandlersArrayKey];
    }
    return iHandlers;
}

- (void)setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index {
    if (block) {
        block = [block copy];
        [self indexedHandlers][index] = [block copy];
    } else {
        [[self indexedHandlers] removeObjectAtIndex:index];
    }
}

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
	NSAssert(title.length, @"A button without a title cannot be added to an action sheet.");
	NSInteger index = [self addButtonWithTitle:title];
	[self setHandler:block forButtonAtIndex:index];
	return index;
}

- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
	NSInteger index = [self addButtonWithTitle:title handler:block];
	self.destructiveButtonIndex = index;
	return index;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
	NSInteger cancelButtonIndex = self.cancelButtonIndex;
    
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && !title.length) {
		title = NSLocalizedString(@"Cancel", nil);
    }
    
	if (title.length) {
		cancelButtonIndex = [self addButtonWithTitle:title];
    }
    
    [self setHandler:block forButtonAtIndex:cancelButtonIndex];
	self.cancelButtonIndex = cancelButtonIndex;
	return cancelButtonIndex;
}

- (void (^)(void))handlerForButtonAtIndex:(NSInteger)index {
    return [self indexedHandlers][index];
}

#pragma mark - Propertites

- (void (^)(UIActionSheet *actionSheet))actionSheetHandlerWithKey:(const char *)key {
    return (void (^)(UIActionSheet *actionSheet))[self associatedValueForKey:key];
}

- (void)setActionSheetHandler:(void (^)(UIActionSheet *actionSheet))h forKey:(const char *)key {
    [self associateValue:[h copy] withKey:key];
}

- (void (^) (UIActionSheet *actionSheet, NSInteger buttonIndex))actionSheetIndexedHandlerWithKey:(const char *)key {
    return (void (^) (UIActionSheet *actionSheet, NSInteger buttonIndex))[self associatedValueForKey:key];
}

- (void)setActionSheetIndexedHandler:(void (^) (UIActionSheet *actionSheet, NSInteger buttonIndex))h forKey:(const char *)key {
    [self associateValue:[h copy] withKey:key];
}


- (void (^)(void))cancelBlock {
	return [self handlerForButtonAtIndex:self.cancelButtonIndex];
}
- (void)setCancelBlock:(void (^)(void))block {
	[self setHandler:block forButtonAtIndex:self.cancelButtonIndex];
}


- (void (^)(UIActionSheet *actionSheet))willPresentBlock {
    return [self actionSheetHandlerWithKey:kActionSheetWillPresentBlockKey];
}
- (void)setWillPresentBlock:(void (^)(UIActionSheet *))willPresentBlock {
    [self setActionSheetHandler:willPresentBlock forKey:kActionSheetWillPresentBlockKey];
}


- (void (^)(UIActionSheet *actionSheet))didPresentBlock {
    return [self actionSheetHandlerWithKey:kActionSheetDidPresentBlockKey];
}
- (void)setDidPresentBlock:(void (^)(UIActionSheet *))didPresentBlock {
    [self setActionSheetHandler:didPresentBlock forKey:kActionSheetDidPresentBlockKey];
}


- (void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))willDismissBlock {
    return [self actionSheetIndexedHandlerWithKey:kActionSheetWillDismissBlockKey];
}
- (void)setWillDismissBlock:(void (^)(UIActionSheet *, NSInteger))willDismissBlock {
    [self setActionSheetIndexedHandler:willDismissBlock forKey:kActionSheetWillDismissBlockKey];
}

- (void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))didDismissBlock {
    return [self actionSheetIndexedHandlerWithKey:kActionSheetDidDismissBlockKey];
}

- (void)setDidDismissBlock:(void (^)(UIActionSheet *, NSInteger))didDismissBlock {
    [self setActionSheetIndexedHandler:didDismissBlock forKey:kActionSheetDidDismissBlockKey];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block) (void) = [self indexedHandlers][buttonIndex];
    block();
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    void (^block) (void) = self.cancelBlock;
    if(block) {
        block();
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    void (^block) (UIActionSheet *as) = [self actionSheetHandlerWithKey:kActionSheetWillPresentBlockKey];
    if(block) {
        block(actionSheet);
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
    void (^block) (UIActionSheet *as) = [self actionSheetHandlerWithKey:kActionSheetDidPresentBlockKey];
    if(block) {
        block(actionSheet);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^block) (UIActionSheet *as, NSInteger i) = [self actionSheetIndexedHandlerWithKey:kActionSheetWillDismissBlockKey];
    if(block) {
        block(actionSheet, buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^block) (UIActionSheet *as, NSInteger i) = [self actionSheetIndexedHandlerWithKey:kActionSheetDidDismissBlockKey];
    if(block) {
        block(actionSheet, buttonIndex);
    }
}



@end
