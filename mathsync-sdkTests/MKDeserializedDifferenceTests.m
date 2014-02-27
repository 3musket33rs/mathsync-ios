#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>
#import "MKDeserializedDifference.h"
#import "MKDifference.h"
#import "MKDeserializer.h"

@interface MKDeserializedDifferenceTests : XCTestCase

@end


SPEC_BEGIN(DeserializedDifferenceSpec)

describe(@"MKDeserializedDifference", ^{
    context(@"when newly created", ^{
        
        __block MKDeserializedDifference *difference = nil;
        __block id mockDifference = nil;
        __block id mockDeserializer = nil;
        
        beforeEach(^{
            mockDifference = [KWMock mockForProtocol:@protocol(MKDifference)];
            mockDeserializer = [KWMock mockForProtocol:@protocol(MKDeserializer)];
            const Byte elt1 = '1';
            const Byte elt2 = '2';
            NSData* data1 = [[NSData alloc] initWithBytes:&elt1 length:1];
            NSData* data2 = [[NSData alloc] initWithBytes:&elt2 length:1];
            NSSet* array1 = [[NSSet alloc] initWithArray:@[data1, data2]];
            [[mockDifference stubAndReturn:array1] added];
            [[mockDeserializer stubAndReturn:@"a"] deserialize:data1];
            [[mockDeserializer stubAndReturn:@"b"] deserialize:data2];
            
            const Byte elt3 = '3';
            const Byte elt4 = '4';
            NSData* data3 = [[NSData alloc] initWithBytes:&elt3 length:1];
            NSData* data4 = [[NSData alloc] initWithBytes:&elt4 length:1];
            NSSet* array2 = [[NSSet alloc] initWithArray:@[data3, data4]];
            [[mockDifference stubAndReturn:array1] added];
            [[mockDifference stubAndReturn:array2] removed];
            [[mockDeserializer stubAndReturn:@"c"] deserialize:data3];
            [[mockDeserializer stubAndReturn:@"d"] deserialize:data4];
            
            difference = [[MKDeserializedDifference alloc] initWithDifference:mockDifference deserializer:mockDeserializer];
            
        });
        
        it(@"added set is deserialized from input", ^{
            [[[difference added] should] containObjectsInArray:@[@"a", @"b"]];
        });
        
        it(@"removed set is deserialized from input", ^{
            [[[difference removed] should] containObjectsInArray:@[@"c", @"d"]];
        });
        
    });
});

SPEC_END