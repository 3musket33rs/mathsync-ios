#import <Foundation/Foundation.h>
#import "MKSerializer.h"

@interface MKSerializedItems : NSEnumerator
-(id)initWithItems:(NSArray*)items serializer:(id<MKSerializer>)serializer;
@end
