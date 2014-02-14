#import <Foundation/Foundation.h>
#import "Serializer.h"
#import "Deserializer.h"

@interface JSONEncoder : NSObject<Serializer, Deserializer>

@end
