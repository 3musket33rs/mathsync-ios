#import "DefaultsConfiguration.h"
#import "PadAndHashBucketSelector.h"
#import "Sha1Digester.h"

@implementation DefaultsConfiguration

+(id<BucketSelector>)defaultSelector {
    return [PadAndHashBucketSelector sharedPadAndHashBucketSelector:[Sha1Digester sharedSha1Digester] spread:3];
}

+(NSUInteger)ibfSizeFromLevel:(NSUInteger)level {
    return pow(2, level);
}

@end
