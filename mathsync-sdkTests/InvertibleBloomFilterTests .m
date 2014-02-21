#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>

#import "InvertibleBloomFilter.h"
#import "SerializedDifference.h"

@interface InvertibleBloomFilterTests : XCTestCase

@end


SPEC_BEGIN(InvertibleBloomFilterSpec)

describe(@"InvertibleBloomFilter", ^{
    context(@"gives a summary", ^{
        
        __block id digester;
        __block id selector;
        __block id<Summary> empty;
        __block id<Summary> just1;
        __block id<Summary> just2;
        __block id<Summary> just3;
        __block id<Summary> items1and2;
        __block id<Summary> items2and3;
        __block NSMutableData* item1;
        __block NSMutableData* item2;
        __block NSMutableData* item3;
        
        beforeEach(^{
            item1 = [NSMutableData data];
            char bytesToAppend1[1] = {0x05};
            [item1 appendBytes:bytesToAppend1 length:sizeof(bytesToAppend1)];
            item2 = [NSMutableData data];
            char bytesToAppend2[1] = {0x06};
            [item2 appendBytes:bytesToAppend2 length:sizeof(bytesToAppend2)];
            item3 = [NSMutableData data];
            char bytesToAppend3[3] = {0x07, 0x08, 0x09};
            [item3 appendBytes:bytesToAppend3 length:sizeof(bytesToAppend3)];

            NSMutableData* digested1 = [NSMutableData data];
            char digestedByte1[1] = {0x04};
            [digested1 appendBytes:digestedByte1 length:sizeof(digestedByte1)];
            NSMutableData* digested2 = [NSMutableData data];
            char digestedByte2[1] = {0x08};
            [digested2 appendBytes:digestedByte2 length:sizeof(digestedByte2)];
            NSMutableData* digested3 = [NSMutableData data];
            char digestedByte3[1] = {0x0c};
            [digested3 appendBytes:digestedByte3 length:sizeof(digestedByte3)];
            
            digester = [KWMock nullMockForProtocol:@protocol(Digester)];
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
        
        it(@"when adding one item should xor items", ^{
            [[[just1 toJSON] should] equal:@"[[0,\"\",\"\"],[1,\"BQ==\",\"BA==\"],[0,\"\",\"\"],[1,\"BQ==\",\"BA==\"],[1,\"BQ==\",\"BA==\"]]"];
            [[[just3 toJSON] should] equal:@"[[1,\"BwgJ\",\"DA==\"],[1,\"BwgJ\",\"DA==\"],[1,\"BwgJ\",\"DA==\"],[0,\"\",\"\"],[0,\"\",\"\"]]"];
            
            [[[items1and2 toJSON] should] equal:@"[[0,\"\",\"\"],[1,\"BQ==\",\"BA==\"],[1,\"Bg==\",\"CA==\"],[2,\"Aw==\",\"DA==\"],[2,\"Aw==\",\"DA==\"]]"];
        });
        
        it(@"when diff a empty summary, added and removed set are empty", ^{
            id<Difference> diff = [empty toDifference];
            [[theValue([[diff added] count]) should] equal:theValue(0)];
            [[theValue([[diff removed] count]) should] equal:theValue(0)];
        });
        
        it(@"when added element should be in difference", ^{
            id<Difference> diff1 = [just1 toDifference];
            NSSet* added1 = [diff1 added];
            [[theValue([[diff1 added] count]) should] equal:theValue(1)];
            [[theValue([[diff1 removed] count]) should] equal:theValue(0)];
            [[[[added1 allObjects] objectAtIndex:0] should] equal:item1];
            
            id<Difference> diff2 = [just2 toDifference];
            NSSet* added2 = [diff2 added];
            [[theValue([[diff2 added] count]) should] equal:theValue(1)];
            [[theValue([[diff2 removed] count]) should] equal:theValue(0)];
            [[[[added2 allObjects] objectAtIndex:0] should] equal:item2];
            
            id<Difference> diff3 = [just3 toDifference];
            NSSet* added3 = [diff3 added];
            [[theValue([[diff3 added] count]) should] equal:theValue(1)];
            [[theValue([[diff3 removed] count]) should] equal:theValue(0)];
            [[[[added3 allObjects] objectAtIndex:0] should] equal:item3];
            
            id<Difference> diff1and2 = [items1and2 toDifference];
            NSSet* added1and2 = [diff1and2 added];
            [[theValue([[diff1and2 added] count]) should] equal:theValue(2)];
            [[theValue([[diff1and2 removed] count]) should] equal:theValue(0)];
            [[[[added1and2 allObjects] objectAtIndex:0] should] equal:item2];
            [[[[added1and2 allObjects] objectAtIndex:1] should] equal:item1];
            
            id<Difference> diff2and3 = [items2and3 toDifference];
            NSSet* added2and3 = [diff2and3 added];
            [[theValue([[diff2and3 added] count]) should] equal:theValue(2)];
            [[theValue([[diff2and3 removed] count]) should] equal:theValue(0)];
            [[[[added2and3 allObjects] objectAtIndex:0] should] equal:item3];
            [[[[added2and3 allObjects] objectAtIndex:1] should] equal:item2];
        });
        
        it(@"when JSON added element should be in difference", ^{
            id<Summary> jsonSum1 = [[InvertibleBloomFilter alloc] initWithJSONString:[just1 toJSON] digester:digester bucketSelector:selector];
            id<Difference> diff1 = [jsonSum1 toDifference];
            NSSet* added1 = [diff1 added];
            [[theValue([[diff1 added] count]) should] equal:theValue(1)];
            [[theValue([[diff1 removed] count]) should] equal:theValue(0)];
            [[[[added1 allObjects] objectAtIndex:0] should] equal:item1];
            
            id<Summary> jsonSum2 = [[InvertibleBloomFilter alloc] initWithJSONString:[just2 toJSON] digester:digester bucketSelector:selector];
            id<Difference> diff2 = [jsonSum2 toDifference];
            NSSet* added2 = [diff2 added];
            [[theValue([[diff2 added] count]) should] equal:theValue(1)];
            [[theValue([[diff2 removed] count]) should] equal:theValue(0)];
            [[[[added2 allObjects] objectAtIndex:0] should] equal:item2];
            
            id<Summary> jsonSum3 = [[InvertibleBloomFilter alloc] initWithJSONString:[just3 toJSON] digester:digester bucketSelector:selector];
            id<Difference> diff3 = [jsonSum3 toDifference];
            NSSet* added3 = [diff3 added];
            [[theValue([[diff3 added] count]) should] equal:theValue(1)];
            [[theValue([[diff3 removed] count]) should] equal:theValue(0)];
            [[[[added3 allObjects] objectAtIndex:0] should] equal:item3];
            
            id<Summary> jsonSum1and2 = [[InvertibleBloomFilter alloc] initWithJSONString:[items1and2 toJSON] digester:digester bucketSelector:selector];
            id<Difference> diff1and2 = [jsonSum1and2 toDifference];
            NSSet* added1and2 = [diff1and2 added];
            [[theValue([[diff1and2 added] count]) should] equal:theValue(2)];
            [[theValue([[diff1and2 removed] count]) should] equal:theValue(0)];
            [[[[added1and2 allObjects] objectAtIndex:0] should] equal:item2];
            [[[[added1and2 allObjects] objectAtIndex:1] should] equal:item1];
            
            id<Summary> jsonItems2and3 = [[InvertibleBloomFilter alloc] initWithJSONString:[items2and3 toJSON] digester:digester bucketSelector:selector];
            id<Difference> diff2and3 = [jsonItems2and3 toDifference];
            NSSet* added2and3 = [diff2and3 added];
            [[theValue([[diff2and3 added] count]) should] equal:theValue(2)];
            [[theValue([[diff2and3 removed] count]) should] equal:theValue(0)];
            [[[[added2and3 allObjects] objectAtIndex:0] should] equal:item3];
            [[[[added2and3 allObjects] objectAtIndex:1] should] equal:item2];
        });
        
        it(@"when removed element should be in difference", ^{
            id<Difference> diff1 = [[empty minus:just1] toDifference];
            [[theValue([[diff1 added] count]) should] equal:theValue(0)];
            [[theValue([[diff1 removed] count]) should] equal:theValue(1)];
            [[[[[diff1 removed] allObjects] objectAtIndex:0] should] equal:item1];
            
            id<Difference> diff2 = [[empty minus:just2] toDifference];
            [[theValue([[diff2 added] count]) should] equal:theValue(0)];
            [[theValue([[diff2 removed] count]) should] equal:theValue(1)];
            [[[[[diff2 removed] allObjects] objectAtIndex:0] should] equal:item2];
            
            id<Difference> diff3 = [[empty minus:just3] toDifference];
            [[theValue([[diff3 added] count]) should] equal:theValue(0)];
            [[theValue([[diff3 removed] count]) should] equal:theValue(1)];
            [[[[[diff3 removed] allObjects] objectAtIndex:0] should] equal:item3];
            
            id<Difference> diff1and2 = [[empty minus:items1and2] toDifference];;
            [[theValue([[diff1and2 added] count]) should] equal:theValue(0)];
            [[theValue([[diff1and2 removed] count]) should] equal:theValue(2)];
            [[[[[diff1and2 removed] allObjects] objectAtIndex:0] should] equal:item2];
            [[[[[diff1and2 removed] allObjects] objectAtIndex:1] should] equal:item1];
            
            id<Difference> diff2and3 =  [[empty minus:items2and3] toDifference];;
            [[theValue([[diff2and3 added] count]) should] equal:theValue(0)];
            [[theValue([[diff2and3 removed] count]) should] equal:theValue(2)];
            [[[[[diff2and3 removed] allObjects] objectAtIndex:0] should] equal:item3];
            [[[[[diff2and3 removed] allObjects] objectAtIndex:1] should] equal:item2];
        });
        
        it(@"when added and removed element should be in difference", ^{
            id<Difference> diff1 = [[just1 minus:just2] toDifference];
            [[theValue([[diff1 added] count]) should] equal:theValue(1)];
            [[theValue([[diff1 removed] count]) should] equal:theValue(1)];
            [[[[[diff1 added] allObjects] objectAtIndex:0] should] equal:item1];
            [[[[[diff1 removed] allObjects] objectAtIndex:0] should] equal:item2];
        });
        
        it(@"when added and removed element should be in difference", ^{
            id<Difference> diff1 = [[[just1 plus:item2] minus:just3] toDifference];
            [[theValue([[diff1 added] count]) should] equal:theValue(2)];
            [[theValue([[diff1 removed] count]) should] equal:theValue(1)];
            [[[[[diff1 added] allObjects] objectAtIndex:0] should] equal:item2];
            [[[[[diff1 added] allObjects] objectAtIndex:1] should] equal:item1];
            [[[[[diff1 removed] allObjects] objectAtIndex:0] should] equal:item3];
        });
        
        it(@"when unresolved difference", ^{
            SerializedDifference* diff1 = (SerializedDifference*)[[just1 plus:item1] toDifference];
            [[diff1 should] beNil];
        });
        
    });
});

SPEC_END