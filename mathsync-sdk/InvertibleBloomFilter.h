#import <Foundation/Foundation.h>
#import "Summary.h"
#import "BucketSelector.h"
#import "Digester.h"

@interface InvertibleBloomFilter : NSObject<Summary> {
    @private
    NSArray* _buckets;
}
-(id)initWithJSONString:(NSString*)json digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector;
-(id)initWithSize:(NSUInteger)size digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector;
@end
