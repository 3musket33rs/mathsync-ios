#import "MKBucket.h"

@implementation MKBucket
@synthesize itemsNumber = _itemsNumber;
@synthesize xored = _xored;
@synthesize hashed = _hashed;

+(id)emptyBucket {
    return [[MKBucket alloc] initWithItemsNumber:@0 xored:[NSData data] hashed:[NSData data]];
}

-(id)initWithJSONArray:(NSArray*)array {
    return [self initWithItemsNumber:array[0] xored:[self deserialize:array[1]] hashed:[self deserialize:array[2]]];
}

-(id)group:(MKBucket*)other {
    return [self modifyItemsNumber:other.itemsNumber xored:other.xored hashed:other.hashed];
}

-(BOOL)isEmpty {
    if(![_itemsNumber isEqualToNumber:@0]) {
        return NO;
    }
    char* ptr = (char*)self.hashed.bytes;
    for (int i = 0; i < [self.hashed length]; i++) {
        if (*ptr != 0) {
            return NO;
        }
        ptr++;
    }

    return YES;
}

-(id)modifyItemsNumber:(NSNumber*)variation xored:(NSData*)content hashed:(NSData*)digested {
    NSData* newXored = [self xorItem1:self.xored item2:content];
    NSData* newHashed = [self xorItem1:self.hashed item2:digested];
    return [[MKBucket alloc] initWithItemsNumber:([NSNumber numberWithInt:([self.itemsNumber intValue] + [variation intValue])]) xored:newXored hashed:newHashed];
}

-(NSArray*)toJSON {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:self.itemsNumber];
    [array addObject:[self serialize:self.xored]];
    [array addObject:[self serialize:self.hashed]];
    return array;
}

//-------------------------------------------------------
// Private methods
//-------------------------------------------------------

-(id)initWithItemsNumber:(NSNumber*)items xored:(NSData*)xored hashed:(NSData*)hashed {
    if(self = [super init]) {
        _itemsNumber = items;
        _xored = xored;
        _hashed = hashed;
    }
    return self;
}

-(NSString*)serialize:(NSData*)data {
    NSString* serialized;
    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        serialized = [data base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        serialized = [data base64Encoding];                              // pre iOS7
    }
    return serialized;
}

-(NSData*)deserialize:(NSString*)serialized {
    NSData* deserialized;
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        deserialized = [[NSData alloc] initWithBase64EncodedString:serialized options:kNilOptions];  // iOS 7+
    } else {
        deserialized = [[NSData alloc] initWithBase64Encoding:serialized];                           // pre iOS7
    }
    return deserialized;
}

-(NSData*)xorItem1:(NSData*)item1 item2:(NSData*)item2 {
    NSMutableData* xored = ([item1 length] > [item2 length] ? [item1 mutableCopy] : [item2 mutableCopy]);
    char* ptr = (char*)xored.bytes;
    char* itemPtr = (char*)([item1 length] <= [item2 length] ? item1.bytes : item2.bytes);
    int minSize = ([item1 length] <= [item2 length] ? [item1 length] : [item2 length]);
    for (int i = 0; i < minSize; i++) {
        *ptr = 0xff & (*ptr ^ *itemPtr);
        ptr++;
        itemPtr++;
    }
    return xored;
}

-(id)description {
   return [NSString stringWithFormat:@"Bucket holding %@ items, hashed=%@, xored=%@", self.itemsNumber, self.hashed, self.xored ];
}

@end
