#import "InvertibleBlumFilter.h"
#import "Difference.h"

@implementation InvertibleBlumFilter

-(id<Summary>)plus:(NSData*)data {
    return nil;
}

-(id<Summary>)minus:(id<Summary>)data {
    return nil;
}

-(NSString*)toJSON {
    return nil;
}

-(id<Difference>)toDifference {
    return nil;
}

//-------------------------------------------
// private methods
//-------------------------------------------
+(NSArray*)bucketsFromJSONString:(NSString*)jsonString {
    NSArray* deserialized =  [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options: NSJSONReadingMutableContainers
                                                                    error: nil];
    NSMutableArray* buckets = [NSMutableArray array];
    for (int i = 0; i < [deserialized count]; i++) {
        //buckets[i] = [[Bucket alloc] initWithDeserialiazed:[deserialized[i]];
    }
    return buckets;
}

+(NSArray*)bucketsOfSize:(NSUInteger)size {
    NSMutableArray* buckets = [NSMutableArray array];
    for (int i = 0; i < size; i++) {
        //buckets[i] = Bucket.EMPTY_BUCKET;
    }
    return buckets;
}

@end
