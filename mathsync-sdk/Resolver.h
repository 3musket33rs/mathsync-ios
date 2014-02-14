#import <Foundation/Foundation.h>
#import "Difference.h"

@protocol Resolver <NSObject>
-(id<Difference>)difference;
@end
