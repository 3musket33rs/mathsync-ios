#import <Foundation/Foundation.h>
#import "MKSummary.h"
#import "MKBucketSelector.h"
#import "MKDigester.h"

@interface MKInvertibleBloomFilter : NSObject<MKSummary> {
    @private
    NSArray* _buckets;
}
-(id)initWithJSONString:(NSString*)json digester:(id<MKDigester>)digester bucketSelector:(id<MKBucketSelector>)bucketSelector;
-(id)initWithSize:(NSUInteger)size digester:(id<MKDigester>)digester bucketSelector:(id<MKBucketSelector>)bucketSelector;
@end
