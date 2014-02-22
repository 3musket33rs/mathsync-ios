#import <Foundation/Foundation.h>
#import "MKBucketSelector.h"

@interface MKDefaultsConfiguration : NSObject
+(id<MKBucketSelector>)defaultSelector;
+(NSUInteger)ibfSizeFromLevel:(NSUInteger)level;
@end
