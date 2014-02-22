#import <Foundation/Foundation.h>
#import "MKDigester.h"

@interface MKSha1Digester : NSObject<MKDigester>
+(id)sharedSha1Digester;
@end
