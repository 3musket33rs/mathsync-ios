#import "MKSerializedItems.h"

@implementation MKSerializedItems {
    id<MKSerializer> _serializer;
    NSArray* _items;
}

-(id)initWithItems:(NSArray*)items serializer:(id<MKSerializer>)serializer {
    if(self = [super init]) {
        _items = items;
        _serializer = serializer;
    }    
    return self;
}

-(id)nextObject {
    return [_serializer serialize:[[_items objectEnumerator] nextObject]];
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_items countByEnumeratingWithState:state objects:buffer count:len];
}
@end
