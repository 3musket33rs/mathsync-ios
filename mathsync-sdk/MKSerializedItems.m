#import "MKSerializedItems.h"

@implementation MKSerializedItems {
    id<MKSerializer> _serializer;
    NSArray* _items;
    NSEnumerator* _it;
}

-(id)initWithItems:(NSArray*)items serializer:(id<MKSerializer>)serializer {
    if(self = [super init]) {
        _items = items;
        _serializer = serializer;
        _it = [_items objectEnumerator];
    }
    return self;
}

-(id)nextObject {
    id obj = [_it nextObject];
    NSLog(@"onject %@", obj);
    return [_serializer serialize:obj];
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_items countByEnumeratingWithState:state objects:buffer count:len];
}
@end
