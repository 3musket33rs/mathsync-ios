#import <Foundation/Foundation.h>
#import "MKDigester.h"
#import "MKBucketSelector.h"
#import "MKSummarizer.h"

typedef NSString* (^MKProducerBlock)(NSUInteger level);

@interface MKSummarizerFromJson : NSObject<MKSummarizer>
+(id)simpleWithProducerCallback:(MKProducerBlock)block;
+(id)customWithProducerCallback:(MKProducerBlock)block digester:(id<MKDigester>)digester selector:(id<MKBucketSelector>)selector;
@end
