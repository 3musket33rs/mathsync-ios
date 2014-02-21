#import <Foundation/Foundation.h>
#import "BucketSelector.h"

@interface DefaultsConfiguration : NSObject
+(id<BucketSelector>)defaultSelector;
+(NSUInteger)ibfSizeFromLevel:(NSUInteger)level;
@end
