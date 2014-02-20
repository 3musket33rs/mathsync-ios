#import <Foundation/Foundation.h>
#import "Summary.h"
#import "BucketSelector.h"
#import "Digester.h"

@interface InvertibleBloomFilter : NSObject<Summary>
-(id)initWithJSONString:(NSString*)json digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector;
-(id)initWithSize:(NSUInteger)size digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector;
@end
