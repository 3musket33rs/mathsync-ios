#import <Foundation/Foundation.h>
#import "Serializer.h"

@interface SerializedItems : NSEnumerator
-(id)initWithItems:(NSArray*)items serializer:(id<Serializer>)serializer;
@end
