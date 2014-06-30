#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>


@interface NSObject (UIAlertViewAssociatedObjects)
- (void)associateValue:(id)value withKey:(const char *)key;
- (id)associatedValueForKey:(const char *)key;
@end

@implementation NSObject (UIAlertViewAssociatedObjects)

- (void)associateValue:(id)value withKey:(const char *)key {
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedValueForKey:(const char *)key {
	return objc_getAssociatedObject(self, key);
}

@end


@interface UIAlertView (BlocksPrivate)
@property (nonatomic, readonly) NSMutableDictionary *handlers;
@end

@implementation UIAlertView (Blocks)

static char *kAlertViewHandlerDictionaryKey = "UIAlertViewBlockHandlers";
static NSString *kAlertViewWillShowBlockKey = @"UIAlertViewWillShowBlock";
static NSString *kAlertViewDidShowBlockKey = @"UIAlertViewDidShowBlock";
static NSString *kAlertViewWillDismissBlockKey = @"UIAlertViewWillDismissBlock";
static NSString *kAlertViewDidDismissBlockKey = @"UIAlertViewDidDismissBlock";

#pragma mark - Convenience

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonText handler:(void(^)(void))block {
    UIAlertView *alert = [UIAlertView alertWithTitle:title message:message];
    if (!buttonText || !buttonText.length)
        buttonText = NSLocalizedString(@"Dismiss", @"DismissString");
    [alert addButtonWithTitle:buttonText];
    if (block)
        alert.didDismissBlock = ^(NSUInteger index){
            block();
        };
    [alert show];
}

#pragma mark Initializers

+ (id)alertWithTitle:(NSString *)title {
    return [self alertWithTitle:title message:nil];
}

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[UIAlertView alloc] initWithTitle:title message:message];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    return [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
}


#pragma mark Public methods

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void(^)(void))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    NSAssert(title.length, @"A button without a title cannot be added to the alert view.");
    NSInteger index = [self addButtonWithTitle:title];
    
    id key = [NSNumber numberWithInteger:index];
    
    if (block) {
        block = [block copy];
        [self.handlers setObject:block forKey:key];
    } else
        [self.handlers removeObjectForKey:key];
    
    return index;
}

- (NSInteger)setCancelButtonWithTitle:(NSString *)title handler:(void(^)(void))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (!title) title = NSLocalizedString(@"Cancel", @"CancelString");
    NSInteger index = [self addButtonWithTitle:title];
    self.cancelButtonIndex = index;
    
    id key = [NSNumber numberWithInteger:index];
    
    if (block) {
        block = [block copy];
        [self.handlers setObject:block forKey:key];
    } else
        [self.handlers removeObjectForKey:key];
    
    return index;
}

#pragma mark Properties

- (NSMutableDictionary *)handlers {
    NSMutableDictionary *handlers = [self associatedValueForKey:kAlertViewHandlerDictionaryKey];
    if (!handlers) {
        handlers = [NSMutableDictionary dictionary];
        [self associateValue:handlers withKey:kAlertViewHandlerDictionaryKey];
    }
    return handlers;
}

- (void(^)(void))handlerForButtonAtIndex:(NSInteger)index {
    NSNumber *key = [NSNumber numberWithInteger:index];
    void (^block)(void) = [self.handlers objectForKey:key];
    return [block copy];
}

- (void(^)(void))cancelBlock {
    NSNumber *key = [NSNumber numberWithInteger:self.cancelButtonIndex];
    void (^block)(void) = [self.handlers objectForKey:key];
    return [block copy];
}

- (void)setCancelBlock:(void(^)(void))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (self.cancelButtonIndex == -1) {
        [self setCancelButtonWithTitle:nil handler:block];
    } else {
        id key = [NSNumber numberWithInteger:self.cancelButtonIndex];
        
        if (!block) {
            [self.handlers removeObjectForKey:key];
            return;
        }
        
        block = [block copy];
        [self.handlers setObject:block forKey:key];
    }
}

- (void(^)(void))willShowBlock {
    void (^handler)(void) = [self.handlers objectForKey:kAlertViewWillShowBlockKey];
    return [handler copy];
}

- (void)setWillShowBlock:(void(^)(void))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (!block) {
        [self.handlers removeObjectForKey:kAlertViewWillShowBlockKey];
        return;
    }
    
    block = [block copy];
    [self.handlers setObject:block forKey:kAlertViewWillShowBlockKey];
}

- (void(^)(void))didShowBlock {
    void (^block)(void) = [self.handlers objectForKey:kAlertViewDidShowBlockKey];
    return [block copy];
}

- (void)setDidShowBlock:(void(^)(void))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (!block) {
        [self.handlers removeObjectForKey:kAlertViewDidShowBlockKey];
        return;
    }
    
    block = [block copy];
    [self.handlers setObject:block forKey:kAlertViewDidShowBlockKey];
}

- (void(^)(NSUInteger))willDismissBlock {
    void (^block)(NSUInteger) = [self.handlers objectForKey:kAlertViewWillDismissBlockKey];
    return [block copy];
}

- (void)setWillDismissBlock:(void(^)(NSUInteger))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (!block) {
        [self.handlers removeObjectForKey:kAlertViewWillDismissBlockKey];
        return;
    }
    
    block = [block copy];
    [self.handlers setObject:block forKey:kAlertViewWillDismissBlockKey];
}

- (void(^)(NSUInteger))didDismissBlock {
    void (^block)(void) = [self.handlers objectForKey:kAlertViewDidDismissBlockKey];
    return [block copy];
}

- (void)setDidDismissBlock:(void(^)(NSUInteger))block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (!block) {
        [self.handlers removeObjectForKey:kAlertViewDidDismissBlockKey];
        return;
    }
    
    block = [block copy];
    [self.handlers setObject:block forKey:kAlertViewDidDismissBlockKey];
}

#pragma mark Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block)(void) = [self.handlers objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    if (block)
        block();
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    void (^block)(void) = [self.handlers objectForKey:kAlertViewWillShowBlockKey];
    if (block)
        block();
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    void (^block)(void) = [self.handlers objectForKey:kAlertViewDidShowBlockKey];
    if (block)
        block();
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^block)(NSUInteger) = [self.handlers objectForKey:kAlertViewWillDismissBlockKey];
    if (block)
        block(buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^block)(NSUInteger) = [self.handlers objectForKey:kAlertViewDidDismissBlockKey];
    if (block)
        block(buttonIndex);
}


@end
