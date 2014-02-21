#import "SummarizerFromItems.h"
#import "SerializedItems.h"
#import "Sha1Digester.h"
#import "DefaultsConfiguration.h"
#import "InvertibleBloomFilter.h"

@implementation SummarizerFromItems {
    NSArray* _items;
    id<Digester> _digester;
    id<BucketSelector> _selector;
}

+(id)customSummarizerWithItem:(NSArray*)items serializer:(id<Serializer>)serializer digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector {
    SerializedItems* serializedItems = [[SerializedItems alloc] initWithItems:items serializer:serializer];
    return [[SummarizerFromItems alloc] initWithItems:serializedItems digester:digester bucketSelector:bucketSelector];
}

+(id)simpleSummarizerWithItem:(NSArray*)items serializer:(id<Serializer>)serializer digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector {
    return [self customSummarizerWithItem:items serializer:serializer digester:[Sha1Digester sharedSha1Digester] bucketSelector:[DefaultsConfiguration defaultSelector]];
}

-(id<Summary>)summarize:(NSUInteger)level {
    id<Summary> empty = [[InvertibleBloomFilter alloc] initWithSize:[DefaultsConfiguration ibfSizeFromLevel:level] digester:_digester bucketSelector:_selector];
    id<Summary> filled = [empty plusAll:_items];
    return filled;
}

//-------------------------------------------
// private methods
//-------------------------------------------
-(id)initWithItems:(SerializedItems*)items digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)selector {
    if (self = [super init]) {
        _digester = digester;
        _selector = selector;
    }
    return self;
}
@end
