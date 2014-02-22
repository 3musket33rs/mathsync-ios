#import "MKJSONEncoder.h"

@implementation MKJSONEncoder

-(NSData*)serialize:(id)item {
    return [NSJSONSerialization dataWithJSONObject:item
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

-(id)deserialize:(NSData*)data {
    id arr = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                               error:nil];
    
    // fix for iOS 5 returning an 'immutable' array when the size is empty
    if ([arr count] == 0 && ![arr isKindOfClass:[NSMutableArray class]])
        return nil;
    
    return arr;
    
}

- (BOOL)isValid:(id)json {
    return [NSJSONSerialization isValidJSONObject:json];
}

@end
