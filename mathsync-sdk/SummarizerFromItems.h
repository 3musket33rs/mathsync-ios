#import <Foundation/Foundation.h>
#import "Summarizer.h"
#import "Digester.h"
#import "BucketSelector.h"
#import "Serializer.h"

@interface SummarizerFromItems : NSObject<Summarizer>
+(id)customSummarizerWithItem:(NSArray*)items serializer:(id<Serializer>)serializer digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector;
+(id)simpleSummarizerWithItem:(NSArray*)items serializer:(id<Serializer>)serializer digester:(id<Digester>)digester bucketSelector:(id<BucketSelector>)bucketSelector;
-(id<Summary>)summarize:(NSUInteger)level;
@end
