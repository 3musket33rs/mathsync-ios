#import "PadAndHashBucketSelector.h"

@implementation PadAndHashBucketSelector {
    NSUInteger _spread;
    id<Digester> _digester;
}

+(id)sharedPadAndHashBucketSelector:(id<Digester>)digester spread:(NSUInteger)spread {
    static PadAndHashBucketSelector *sharedMyPadAndHashBucketSelector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyPadAndHashBucketSelector = [[self alloc] initWithDigester:digester spread:spread];
    });
    return sharedMyPadAndHashBucketSelector;
}

-(NSArray*)selectBuckets:(NSData*)content {
    NSMutableArray* destinations = [NSMutableArray array];
    for (char i = 0; i < _spread; i++) {
        NSMutableData* paddedContent = [content mutableCopy];
        [paddedContent appendBytes:&i length:sizeof(i)];
        NSData* digested = [_digester digest:paddedContent];
        int numberOfHashes = [self destinationBucket:digested];
        [destinations addObject:[[NSNumber alloc] initWithInt:numberOfHashes]];
    }
    return destinations;
}

-(int) destinationBucket:(NSData*)digested {
    if ([digested length] < 4) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:[NSString stringWithFormat:@"Digester does not produce long enough digests: %lu",  (unsigned long)[digested length]]
                userInfo:nil];
    }
    char* myDigested;
    myDigested = (char*)[digested bytes];
    int id = ((myDigested[0] << 24) | (myDigested[1] << 16) | (myDigested[2] << 8) | (myDigested[3]));
    return abs(id);
}

-(id)initWithDigester:(id<Digester>)digester spread:(NSUInteger)spread {
    if (spread < 1) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:[NSString stringWithFormat:@"Items must be stored in a strictly positive number of buckets, given: %lu", (unsigned long)spread]
                userInfo:nil];
    }
    if (digester == nil) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:@"Digester cannot be null"
                userInfo:nil];
    }
    if (self = [super init]) {
        _spread = spread;
        _digester = digester;
    }
    return self;
}

@end
