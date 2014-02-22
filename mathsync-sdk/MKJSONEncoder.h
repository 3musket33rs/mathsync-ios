#import <Foundation/Foundation.h>
#import "MKSerializer.h"
#import "MKDeserializer.h"

@interface MKJSONEncoder : NSObject<MKSerializer, MKDeserializer>

@end
