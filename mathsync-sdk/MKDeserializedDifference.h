#import <Foundation/Foundation.h>
#import "MKDeserializer.h"
#import "MKDifference.h"

@interface MKDeserializedDifference : NSObject<MKDifference>
-(id)initWithDifference:(id<MKDifference>)serializedDifference deserializer:(id<MKDeserializer>)deserializer;
@end
