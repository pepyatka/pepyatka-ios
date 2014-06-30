#import <Foundation/Foundation.h>

//2013-12-23

@interface NSArray (Accessors)
@property (readonly) id firstObject, secondObject, thirdObject;
@property (readonly) NSSet *set;
- (id)objectAtSafeIndex:(NSUInteger)idx;
- (NSArray *)arrayByTakeCount:(NSUInteger)count;
@end


@interface NSArray (Blocks)

- (NSArray *)map:(id(^)(id arrayItem))aTransformer;

- (void)apply:(void(^)(id arrayItem))anAction;
- (void)applyConcurrent:(void(^)(id arrayItem))anAction;

- (id)firstObjectWithPredicate:(BOOL(^)(id arrayItem))aPredicate;
- (NSNumber *)indexOfFirstObjectWithPredicate:(BOOL(^)(id arrayItem))aPredicate;
- (NSArray *)arrayWhere:(BOOL(^)(id arrayItem))aPredicate;
- (NSArray *)arrayByRejectionWhere:(BOOL(^)(id arrayItem))aPredicate;
- (NSArray *)arrayByRejectFirstObjectWithPredicate:(BOOL(^)(id arrayItem))aPredicate;

- (BOOL)any:(BOOL(^)(id arrayItem))aPredicate;
- (BOOL)none:(BOOL(^)(id arrayItem))aPredicate;
- (BOOL)all:(BOOL(^)(id arrayItem))aPredicate;

- (NSArray *)arrayByRemovingObject:(id)obj;


@end
