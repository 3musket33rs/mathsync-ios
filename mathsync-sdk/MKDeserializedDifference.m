#import "MKDeserializedDifference.h"

@implementation MKDeserializedDifference {
    NSSet* _added;
    NSSet* _removed;
}
-(id)initWithDifference:(id<MKDifference>)serializedDifference deserializer:(id<MKDeserializer>)deserializer {
    if(self = [super init]) {
        _added = [self deserializeData:[serializedDifference added] with:deserializer];
        _removed = [self deserializeData:[serializedDifference removed] with:deserializer];
    }
    return self;
}

-(NSSet*)added {
    return _added;
}

-(NSSet*)removed {
    return _removed;
}

-(NSSet*)deserializeData:(NSSet*)serialized with:(id<MKDeserializer>)deserializer {
    NSMutableSet* deserialized = [NSMutableSet set];
    for(NSData* content in serialized) {
        [deserialized addObject:[deserializer deserialize:content]];
    }
    return [deserialized copy];
}

@end
