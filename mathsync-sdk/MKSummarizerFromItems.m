#import "MKSummarizerFromItems.h"
#import "MKSerializedItems.h"
#import "MKSha1Digester.h"
#import "MKDefaultsConfiguration.h"
#import "MKInvertibleBloomFilter.h"

@implementation MKSummarizerFromItems {
    MKSerializedItems* _items;
    id<MKDigester> _digester;
    id<MKBucketSelector> _selector;
}

+(id)customSummarizerWithItem:(NSArray*)items serializer:(id<MKSerializer>)serializer digester:(id<MKDigester>)digester bucketSelector:(id<MKBucketSelector>)bucketSelector {
    MKSerializedItems* serializedItems = [[MKSerializedItems alloc] initWithItems:items serializer:serializer];
    return [[MKSummarizerFromItems alloc] initWithItems:serializedItems digester:digester bucketSelector:bucketSelector];
}

+(id)simpleSummarizerWithItem:(NSArray*)items serializer:(id<MKSerializer>)serializer {
    return [self customSummarizerWithItem:items serializer:serializer digester:[MKSha1Digester sharedSha1Digester] bucketSelector:[MKDefaultsConfiguration defaultSelector]];
}

-(id<MKSummary>)summarize:(NSUInteger)level {
    id<MKSummary> empty = [[MKInvertibleBloomFilter alloc] initWithSize:[MKDefaultsConfiguration ibfSizeFromLevel:level] digester:_digester bucketSelector:_selector];
    id<MKSummary> filled = [empty plusAll:_items];
    return filled;
}

//-------------------------------------------
// private methods
//-------------------------------------------
-(id)initWithItems:(MKSerializedItems*)items digester:(id<MKDigester>)digester bucketSelector:(id<MKBucketSelector>)selector {
    if (self = [super init]) {
        _digester = digester;
        _selector = selector;
        _items = items;
    }
    return self;
}
@end
