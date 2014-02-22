#import <Foundation/Foundation.h>
#import "MKBucketSelector.h"
#import "MKDigester.h"

@interface MKPadAndHashBucketSelector : NSObject<MKBucketSelector>
+(id)sharedPadAndHashBucketSelector:(id<MKDigester>)digester spread:(NSUInteger)spread;
@end
