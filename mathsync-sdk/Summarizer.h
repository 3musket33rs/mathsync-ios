#import <Foundation/Foundation.h>
#import "Summary.h"

@protocol Summarizer <NSObject>
-(id<Summary>)summarize:(NSUInteger)level;
@end
