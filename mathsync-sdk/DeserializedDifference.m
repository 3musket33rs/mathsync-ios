#import "DeserializedDifference.h"

@implementation DeserializedDifference {
    NSSet* _added;
    NSSet* _removed;
}
-(id)initWithDifference:(id<Difference>)serializedDifference deserializer:(id<Deserializer>)deserializer {
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

-(NSSet*)deserializeData:(NSSet*)serialized with:(id<Deserializer>)deserializer {
    NSMutableSet* deserialized = [NSMutableSet set];
    for(NSData* content in serialized) {
        [deserialized addObject:[deserializer deserialize:content]];
    }
    return [deserialized copy];
}

@end
