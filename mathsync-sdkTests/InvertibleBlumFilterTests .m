#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>

#import "InvertibleBloomFilter.h"


@interface InvertibleBlumFilterrTests : XCTestCase

@end


SPEC_BEGIN(InvertibleBlumFilterSpec)

describe(@"InvertibleBlumFilter", ^{
    context(@"gives a summary", ^{
        
        __block id digester;
        __block id selector;
        __block id<Summary> empty;
        __block id<Summary> just1;
        __block id<Summary> just2;
        __block id<Summary> just3;
        __block id<Summary> items1and2;
        __block id<Summary> items2and3;
        
        beforeEach(^{
            NSMutableData* item1 = [NSMutableData data];
            char bytesToAppend1[1] = {0x05};
            [item1 appendBytes:bytesToAppend1 length:sizeof(bytesToAppend1)];
            NSMutableData* item2 = [NSMutableData data];
            char bytesToAppend2[1] = {0x06};
            [item2 appendBytes:bytesToAppend2 length:sizeof(bytesToAppend2)];
            NSMutableData* item3 = [NSMutableData data];
            char bytesToAppend3[3] = {0x07, 0x08, 0x09};
            [item3 appendBytes:bytesToAppend3 length:sizeof(bytesToAppend3)];

            NSMutableData* digested1 = [NSMutableData data];
            char digestedByte1[1] = {0x04};
            [digested1 appendBytes:digestedByte1 length:sizeof(digestedByte1)];
            NSMutableData* digested2 = [NSMutableData data];
            char digestedByte2[1] = {0x08};
            [digested2 appendBytes:digestedByte2 length:sizeof(digestedByte2)];
            NSMutableData* digested3 = [NSMutableData data];
            char digestedByte3[1] = {0x12};
            [digested3 appendBytes:digestedByte3 length:sizeof(digestedByte3)];
            
            digester = [KWMock mockForProtocol:@protocol(Digester)];
            selector = [KWMock mockForProtocol:@protocol(BucketSelector)];
            empty = [[InvertibleBloomFilter alloc] initWithSize:5 digester:digester bucketSelector:selector];
            
            [[selector stubAndReturn:@[@6, @3, @4]] selectBuckets:item1];
            [[digester stubAndReturn:digested1] digest:item1];
            [[selector stubAndReturn:@[@2, @3, @4]] selectBuckets:item2];
            [[digester stubAndReturn:digested2] digest:item2];
            [[selector stubAndReturn:@[@0, @1, @2]] selectBuckets:item3];
            [[digester stubAndReturn:digested3] digest:item3];
            
            just1 = [empty plus:item1];
            just2 = [empty plus:item2];
            just3 = [empty plus:item3];
            items1and2 = [just1 plus:item2];
            items2and3 = [just2 plus:item3];
            
        });
        
        it(@"when adding one item and substracting one item should give intial summary (xor is revertible)", ^{
            [[[just1 toJSON] should] equal:@"[[0,\"\",\"\"],[1,\"BQ==\",\"BA==\"],[0,\"\",\"\"],[1,\"BQ==\",\"BA==\"],[1,\"BQ==\",\"BA==\"]]"];
            [[[items1and2 toJSON] should] equal:@"[[0,\"\",\"\"],[1,\"BQ==\",\"BA==\"],[1,\"Bg==\",\"CA==\"],[2,\"Aw==\",\"DA==\"],[2,\"Aw==\",\"DA==\"]]"];
        });
    });
});

SPEC_END