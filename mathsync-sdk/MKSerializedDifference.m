#import "MKSerializedDifference.h"

@implementation MKSerializedDifference {
    NSSet* _added;
    NSSet* _removed;
}

-(id)initWithAdded:(NSSet*)added removed:(NSSet*)removed {
    if (self = [super init]) {
        _added = added;
        _removed = removed;
    }
    return self;
}

-(NSSet*)added {
    return _added;
}

-(NSSet*)removed {
    return _removed;
}

@end
