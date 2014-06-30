
#import "NSArray+Utils.h"

@implementation NSArray (Accessors)

- (NSSet *)set {
    return [NSSet setWithArray:self];
}

- (id)firstObject {
    return [self objectAtSafeIndex:0];
}

- (id)secondObject {
    return [self objectAtSafeIndex:1];
}

- (id)thirdObject {
    return [self objectAtSafeIndex:2];
}

- (id)objectAtSafeIndex:(NSUInteger)idx {
    if(!self.count) return nil;
    return idx > self.count - 1? nil: [self objectAtIndex:idx];
}

- (NSArray *)arrayByTakeCount:(NSUInteger)count {
	if(!count) return [NSArray array];
	if(count >= self.count) {
		return self.copy;
	}
	
	NSRange range;
	range.location = 0;
	range.length = MAX(self.count, count);
	return [self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}

@end

@implementation NSArray (Blocks)
- (void)apply:(void(^)(id arrayItem))anAction {
	NSParameterAssert(anAction != nil);
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		anAction(obj);
	}];
}

- (void)applyConcurrent:(void(^)(id arrayItem))anAction {
	NSParameterAssert(anAction != nil);
	[self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		anAction(obj);
	}];
}

- (id)firstObjectWithPredicate:(BOOL(^)(id arrayItem))aPredicate {
	NSParameterAssert(aPredicate != nil);
	
	NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return aPredicate(obj);
	}];
	
	if (index == NSNotFound) {
        return nil;
    }
	
	return [self objectAtIndex:index];
}

- (NSNumber *)indexOfFirstObjectWithPredicate:(BOOL(^)(id arrayItem))aPredicate {
    NSParameterAssert(aPredicate != nil);
	
	NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return aPredicate(obj);
	}];
	
	if (index == NSNotFound) {
        return nil;
    }
	
	return @(index);
}

- (NSArray *)arrayWhere:(BOOL(^)(id arrayItem))aPredicate {
	NSParameterAssert(aPredicate != nil);
	
	return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return aPredicate(obj);
	}]];
}

- (NSArray *)arrayByRejectionWhere:(BOOL(^)(id arrayItem))aPredicate {
	return [self arrayWhere:^BOOL(id obj) {
		return !aPredicate(obj);
	}];
}

- (NSArray *)arrayByRejectFirstObjectWithPredicate:(BOOL(^)(id arrayItem))aPredicate {
    if(!aPredicate) return self.copy;
    NSMutableArray *array = @[].mutableCopy;
    for (id obj in self) {
        if(!aPredicate(obj)) {
            [array addObject:obj];
        }
    }
    return array.copy;
}


- (NSArray *)map:(id(^)(id arrayItem))aTransformer {
	NSParameterAssert(aTransformer != nil);
	
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id value = aTransformer(obj);
		if (!value) {
			value = [NSNull null];
        }
		
		[result addObject:value];
	}];
	
	return result;
}

- (BOOL)any:(BOOL(^)(id arrayItem))aPredicate {
	return [self firstObjectWithPredicate:aPredicate] != nil;
}

- (BOOL)none:(BOOL(^)(id arrayItem))aPredicate {
	return [self firstObjectWithPredicate:aPredicate] == nil;
}

- (BOOL)all:(BOOL(^)(id arrayItem))aPredicate {
	NSParameterAssert(aPredicate != nil);
	
    __block BOOL result = YES;
    
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (!aPredicate(obj)) {
			result = NO;
			*stop = YES;
		}
	}];
    
    return result;
}

- (NSArray *)arrayByRemovingObject:(id)obj {
    NSMutableArray *a = self.mutableCopy;
    [a removeObject:obj];
    return a.copy;
}

@end
