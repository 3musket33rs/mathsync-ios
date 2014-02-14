#import "ResolverFromSummarizers.h"
#import "DeserializedDifference.h"

@implementation ResolverFromSummarizers {
    id<Summarizer> _local;
    id<Summarizer> _remote;
    id<Deserializer> _deserializer;
}

+(id)resolverWithLocal:(id<Summarizer>)local remote:(id<Summarizer>)remote deserializer:(id<Deserializer>)deserializer {
    return [[ResolverFromSummarizers alloc] initWithLocal:local remote:remote deserializer:deserializer];
}

-(id)initWithLocal:(id<Summarizer>)local remote:(id<Summarizer>)remote deserializer:(id<Deserializer>)deserializer {
    if(self = [super init]) {
        _local = local;
        _remote = remote;
        _deserializer = deserializer;
    }
    return self;
}

-(id<Difference>)difference {
    NSUInteger level = 0;
    id<Difference> difference;
    while (difference == nil) {
        level++;
        id<Summary> localInvertedBloomFilter = [_local summarize:level];
        id<Summary> remoteInvertedBloomFilter = [_remote summarize:level];
        difference = [self computeDifferenceLocal:localInvertedBloomFilter remote:remoteInvertedBloomFilter];
    }
    return [[DeserializedDifference alloc] initWithDifference:difference deserializer:_deserializer];
}

-(id<Difference>)computeDifferenceLocal:(id<Summary>)localIbf remote:(id<Summary>)remoteIbf {
    return [[remoteIbf minus:localIbf] toDifference];
}

@end
