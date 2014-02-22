#import <Foundation/Foundation.h>
#import "MKResolver.h"
#import "MKSummarizer.h"
#import "MKDeserializer.h"

@interface MKResolverFromSummarizers : NSObject<MKResolver>
+(id)resolverWithLocal:(id<MKSummarizer>)local remote:(id<MKSummarizer>)remote deserializer:(id<MKDeserializer>)deserializer;
-(id)initWithLocal:(id<MKSummarizer>)local remote:(id<MKSummarizer>)remote deserializer:(id<MKDeserializer>)deserializer;
@end
