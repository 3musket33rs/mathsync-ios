#import "MKDefaultsConfiguration.h"
#import "MKPadAndHashBucketSelector.h"
#import "MKSha1Digester.h"

@implementation MKDefaultsConfiguration

+(id<MKBucketSelector>)defaultSelector {
    return [MKPadAndHashBucketSelector sharedPadAndHashBucketSelector:[MKSha1Digester sharedSha1Digester] spread:3];
}

+(NSUInteger)ibfSizeFromLevel:(NSUInteger)level {
    return pow(2, level);
}

@end
