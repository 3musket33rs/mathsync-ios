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

@end
