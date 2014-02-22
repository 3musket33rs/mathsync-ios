#import "MKResolverFromSummarizers.h"
#import "MKDeserializedDifference.h"

@implementation MKResolverFromSummarizers {
    id<MKSummarizer> _local;
    id<MKSummarizer> _remote;
    id<MKDeserializer> _deserializer;
}

+(id)resolverWithLocal:(id<MKSummarizer>)local remote:(id<MKSummarizer>)remote deserializer:(id<MKDeserializer>)deserializer {
    return [[MKResolverFromSummarizers alloc] initWithLocal:local remote:remote deserializer:deserializer];
}

-(id)initWithLocal:(id<MKSummarizer>)local remote:(id<MKSummarizer>)remote deserializer:(id<MKDeserializer>)deserializer {
    if(self = [super init]) {
        _local = local;
        _remote = remote;
        _deserializer = deserializer;
    }
    return self;
}

-(id<MKDifference>)difference {
    NSUInteger level = 0;
    id<MKDifference> difference;
    while (difference == nil) {
        level++;
        id<MKSummary> localInvertedBloomFilter = [_local summarize:level];
        id<MKSummary> remoteInvertedBloomFilter = [_remote summarize:level];
        difference = [self computeDifferenceLocal:localInvertedBloomFilter remote:remoteInvertedBloomFilter];
    }
    return [[MKDeserializedDifference alloc] initWithDifference:difference deserializer:_deserializer];
}

-(id<MKDifference>)computeDifferenceLocal:(id<MKSummary>)localIbf remote:(id<MKSummary>)remoteIbf {
    return [[remoteIbf minus:localIbf] toDifference];
}

@end
