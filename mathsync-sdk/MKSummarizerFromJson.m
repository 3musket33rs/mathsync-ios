#import "MKSummarizerFromJson.h"
#import "MKSha1Digester.h"
#import "MKDefaultsConfiguration.h"
#import "MKInvertibleBloomFilter.h"

@implementation MKSummarizerFromJson {
    id<MKBucketSelector> _selector;
    id<MKDigester> _digester;
    MKProducerBlock _producer;
}

+(id)simpleWithProducerCallback:(MKProducerBlock)block {
   return [[MKSummarizerFromJson alloc] initWithProducerCallback:block digester:[MKSha1Digester sharedSha1Digester] selector:[MKDefaultsConfiguration defaultSelector]];
}

+(id)customWithProducerCallback:(MKProducerBlock)block digester:(id<MKDigester>)digester selector:(id<MKBucketSelector>)selector {
    return [[MKSummarizerFromJson alloc] initWithProducerCallback:block digester:digester selector:selector];

}

-(id<MKSummary>)summarize:(NSUInteger)level {
    return [[MKInvertibleBloomFilter alloc] initWithJSONString:_producer(level) digester:_digester bucketSelector:_selector];
}

-(id)initWithProducerCallback:(MKProducerBlock)producer digester:(id<MKDigester>)digester selector:(id<MKBucketSelector>)selector {
    if (self = [super init]) {
        _selector = selector;
        _digester = digester;
        _producer = producer;
    }
    return self;
}
@end
