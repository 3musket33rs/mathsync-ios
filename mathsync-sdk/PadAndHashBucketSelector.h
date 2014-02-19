#import <Foundation/Foundation.h>
#import "BucketSelector.h"
#import "Digester.h"

@interface PadAndHashBucketSelector : NSObject<BucketSelector>
+(id)sharedPadAndHashBucketSelector:(id<Digester>)digester spread:(NSUInteger)spread;
@end
