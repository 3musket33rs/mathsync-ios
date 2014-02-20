#import "InvertibleBloomFilter.h"
#import "Difference.h"
#import "Bucket.h"

@implementation InvertibleBloomFilter {
    NSArray* _buckets;
    id<BucketSelector> _bucketSelector;
    id<Digester> _digester;
}

-(id)initWithJSONString:(NSString*)json digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector {
    if (self = [super init]) {
        _digester = digester;
        _bucketSelector = bucketSelector;
        _buckets = [InvertibleBloomFilter bucketsFromJSONString:json];
    }
    return self;
}

-(id)initWithSize:(NSUInteger)size digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector {
    if (self = [super init]) {
        _digester = digester;
        _bucketSelector = bucketSelector;
        _buckets = [InvertibleBloomFilter bucketsOfSize:size];
    }
    return self;
}

-(id<Summary>)plus:(NSData*)data {
    if (data == nil) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:@"Cannot add a null item to an IBF"
                userInfo:nil];
    }
    NSMutableArray* updated = [_buckets mutableCopy];
    [self modifyWithSideEffect:updated variation:@1 data:data];
    return [[InvertibleBloomFilter alloc] initWithBucket:updated digester:_digester bucketSelector:_bucketSelector];
}

-(id<Summary>)plusAll:(NSArray*)items {
    if (items == nil) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:@"Cannot add a null list of items to an IBF"
                userInfo:nil];
    }
    NSMutableArray* updated = [_buckets mutableCopy];
    [self modifyManyWithSideEffect:updated variation:@1 data:items];
    return [[InvertibleBloomFilter alloc] initWithBucket:updated digester:_digester bucketSelector:_bucketSelector];
}

-(id<Summary>)minus:(id<Summary>)data {
    return nil;
}

-(NSString*)toJSON {
    NSMutableArray* arrayOfBuckets = [NSMutableArray array];
    for (Bucket *bucket in _buckets) {
        [arrayOfBuckets addObject:[bucket toJSON]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayOfBuckets
                                                       options:0
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
}

-(id<Difference>)toDifference {
    return nil;
}

//-------------------------------------------
// private methods
//-------------------------------------------

-(id)initWithBucket:(NSArray*)bucket digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector {
    if (self = [super init]) {
        _digester = digester;
        _bucketSelector = bucketSelector;
        _buckets = bucket;
    }
    return self;
}

+(NSArray*)bucketsFromJSONString:(NSString*)jsonString {
    NSArray* deserialized =  [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options: NSJSONReadingMutableContainers
                                                                    error: nil];
    NSMutableArray* buckets = [NSMutableArray array];
    for (int i = 0; i < [deserialized count]; i++) {
        buckets[i] = [[Bucket alloc] initWithJSONArray:deserialized[i]];
    }
    return buckets;
}

+(NSArray*)bucketsOfSize:(NSUInteger)size {
    if (size < 1) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:[NSString stringWithFormat:@"IBF size must be a strictly positive number, given: %lu", (unsigned long)size]
                userInfo:nil];
    }
    NSMutableArray* buckets = [NSMutableArray array];
    for (int i = 0; i < size; i++) {
        buckets[i] = [Bucket emptyBucket];
    }
    return buckets;
}

-(void)modifyWithSideEffect:(NSMutableArray*)buckets variation:(NSNumber*)variation data:(NSData*)data {
    NSData* hashed = [_digester digest:data];
    for(NSNumber* number in [_bucketSelector selectBuckets:data]) {
        int value = [number intValue] % [buckets count];
        buckets[value] = [(Bucket*)buckets[value] modifyItemsNumber:variation xored:data hashed:hashed];
    }
}

-(void)modifyManyWithSideEffect:(NSMutableArray*)buckets variation:(NSNumber*)variation data:(NSArray*)arrayOfData {
    for (NSData* data in arrayOfData) {
        [self modifyWithSideEffect:buckets variation:variation data:data];
    }
}

@end
