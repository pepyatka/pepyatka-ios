#import "NSArrayTransformer.h"

@implementation NSArrayTransformer

+ (Class)transformedValueClass {
	return [NSArray class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (NSData *)transformedValue:(NSArray *)value {
	return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (NSArray *)reverseTransformedValue:(NSData *)value {
	return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}


@end


// source: http://www.lextech.com/2013/01/core-data-transformable-attributes/
