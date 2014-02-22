#import <Foundation/Foundation.h>
#import "MKDifference.h"

@interface MKSerializedDifference : NSObject<MKDifference>
-(id)initWithAdded:(NSSet*)added removed:(NSSet*)removed;
@end
