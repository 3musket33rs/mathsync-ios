#import <Foundation/Foundation.h>
#import "Resolver.h"
#import "Summarizer.h"
#import "Deserializer.h"

@interface ResolverFromSummarizers : NSObject<Resolver>
+(id)resolverWithLocal:(id<Summarizer>)local remote:(id<Summarizer>)remote deserializer:(id<Deserializer>)deserializer;
-(id)initWithLocal:(id<Summarizer>)local remote:(id<Summarizer>)remote deserializer:(id<Deserializer>)deserializer;
@end
