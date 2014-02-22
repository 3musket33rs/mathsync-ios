#import <Foundation/Foundation.h>
#import "MKSummary.h"

@protocol MKSummarizer <NSObject>
-(id<MKSummary>)summarize:(NSUInteger)level;
@end
