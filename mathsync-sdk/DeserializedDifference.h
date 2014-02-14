#import <Foundation/Foundation.h>
#import "Deserializer.h"
#import "Difference.h"

@interface DeserializedDifference : NSObject<Difference>
-(id)initWithDifference:(id<Difference>)serializedDifference deserializer:(id<Deserializer>)deserializer;
@end
