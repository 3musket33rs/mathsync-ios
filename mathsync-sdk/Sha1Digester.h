#import <Foundation/Foundation.h>
#import "Digester.h"

@interface Sha1Digester : NSObject<Digester>
+(id)sharedSha1Digester;
@end
