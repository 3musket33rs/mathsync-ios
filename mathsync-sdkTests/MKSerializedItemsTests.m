#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>

#import "MKSerializedItems.h"


@interface MKSerializesItemsTests : XCTestCase

@end


SPEC_BEGIN(MKSerializedItemsSpec)

describe(@"MKSerializedItems", ^{
    context(@"when iterating", ^{
        
        
        __block MKSerializedItems* item1;
        __block id serializer;
        
        beforeEach(^{
            serializer = [KWMock mockForProtocol:@protocol(MKSerializer)];
            
        });
        
        it(@"through an erray of 2", ^{
            NSData* data1 = [@"item1" dataUsingEncoding:NSUTF8StringEncoding];
            [[serializer stubAndReturn:data1] serialize:@"item1"];
            NSData* data2 = [@"item2" dataUsingEncoding:NSUTF8StringEncoding];
            [[serializer stubAndReturn:data1] serialize:@"item2"];
            
            item1 = [[MKSerializedItems alloc] initWithItems:@[@"item1", @"item2"] serializer:serializer];

            
            int i = 0;
            for (NSData* data in item1) {
                i++;
            }
            
            [[theValue(i) should] equal:theValue(2)];

        });

    });
});

SPEC_END