#import <Foundation/Foundation.h>
#import "Difference.h"

@interface SerializedDifference : NSObject<Difference>
-(id)initWithAdded:(NSSet*)added removed:(NSSet*)removed;
@end
