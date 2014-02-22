#import <Foundation/Foundation.h>
#import "MKDifference.h"

@protocol MKResolver <NSObject>
-(id<MKDifference>)difference;
@end
