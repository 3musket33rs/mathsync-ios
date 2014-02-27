#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>

#import "MKPadAndHashBucketSelector.h"


@interface MKPadAndHashBucketSelectorTests : XCTestCase

@end


SPEC_BEGIN(MKPadAndHashBucketSelectorSpec)

describe(@"MKPadAndHashBucketSelector", ^{
    context(@"gives list of different hashes", ^{
        
        
        __block MKPadAndHashBucketSelector* padAndHashBucketSelector;
        __block id digester;
        
        beforeEach(^{
            NSMutableData* data = [NSMutableData data];
            char abc[4] = {0x61, 0x62, 0x63, 0x64};
            [data appendBytes:abc length:sizeof(abc)];
            
            NSMutableData* content0 = [NSMutableData data];
            char contentArray0[2] = {0x05, 0x00};
            [content0 appendBytes:contentArray0 length:sizeof(contentArray0)];
            
            NSMutableData* content1 = [NSMutableData data];
            char contentArray1[2] = {0x05, 0x01};
            [content1 appendBytes:contentArray1 length:sizeof(contentArray1)];
            
            NSMutableData* content2 = [NSMutableData data];
            char contentArray2[2] = {0x05, 0x02};
            [content2 appendBytes:contentArray2 length:sizeof(contentArray2)];
            
            digester = [KWMock mockForProtocol:@protocol(MKDigester)];
            padAndHashBucketSelector = [MKPadAndHashBucketSelector sharedPadAndHashBucketSelector:digester spread:3];
            
            
            [[digester stubAndReturn:data] digest:content0];
            [[digester stubAndReturn:data] digest:content1];
            [[digester stubAndReturn:data] digest:content2];
        });
        
        it(@"calling digest with padded content", ^{
            
            NSMutableData* content = [NSMutableData data];
            char contentArray[1] = {0x05};
            [content appendBytes:contentArray length:sizeof(contentArray)];
            
            NSArray* result = [padAndHashBucketSelector selectBuckets:content];
            
            [[result should] equal:@[@1633837924, @1633837924, @1633837924]];
        });
    });
});

SPEC_END