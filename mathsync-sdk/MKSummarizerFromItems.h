#import <Foundation/Foundation.h>
#import "MKSummarizer.h"
#import "MKDigester.h"
#import "MKBucketSelector.h"
#import "MKSerializer.h"

@interface MKSummarizerFromItems : NSObject<MKSummarizer>
+(id)customSummarizerWithItem:(NSArray*)items serializer:(id<MKSerializer>)serializer digester:(id<MKDigester>)digester bucketSelector:(id<MKBucketSelector>)bucketSelector;
+(id)simpleSummarizerWithItem:(NSArray*)items serializer:(id<MKSerializer>)serializer;
-(id<MKSummary>)summarize:(NSUInteger)level;
@end
