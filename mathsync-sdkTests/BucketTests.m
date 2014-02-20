#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>

#import "Bucket.h"


@interface BucketTests : XCTestCase

@end


SPEC_BEGIN(BucketSpec)

describe(@"Bucket", ^{
    context(@"when doing operation", ^{
        
        
        __block Bucket* empty;
        __block Bucket* added1;
        __block Bucket* added2;
        __block Bucket* added1removed2;

        
        beforeEach(^{
            NSMutableData* content1 = [NSMutableData data];
            char bytesToAppend1[2] = {0x01, 0x02};
            [content1 appendBytes:bytesToAppend1 length:sizeof(bytesToAppend1)];
            NSMutableData* hash1 = [NSMutableData data];
            char bytesToAppendHash1[2] = {0x03, 0x04};
            [hash1 appendBytes:bytesToAppendHash1 length:sizeof(bytesToAppendHash1)];
            
            NSMutableData* content2 = [NSMutableData data];
            char bytesToAppend2[2] = {0x05, 0x06};
            [content2 appendBytes:bytesToAppend2 length:sizeof(bytesToAppend2)];
            NSMutableData* hash2 = [NSMutableData data];
            char bytesToAppendHash2[2] = {0x07, 0x08};
            [hash2 appendBytes:bytesToAppendHash2 length:sizeof(bytesToAppendHash2)];
            
            empty = [Bucket emptyBucket];
            added1 = [empty modifyItemsNumber:@1 xored:content1 hashed:hash1];
            added2 = [empty modifyItemsNumber:@2 xored:content2 hashed:hash2];
            added1removed2 = [added1 modifyItemsNumber:@-2 xored:content2 hashed:hash2];
            
        });
        
        it(@"itemsNumber on empty bucket should return 0", ^{
            [[empty.itemsNumber should] equal:@0];
            [[theValue([empty isEmpty]) should] equal:theValue(YES)];
            [[added1.itemsNumber should] equal:@1];
            [[added2.itemsNumber should] equal:@2];
            [[theValue([added1 isEmpty]) should] equal:theValue(NO)];
            [[[added1.xored description] should] equal:@"<0102>"];
            [[[added1.hashed description] should] equal:@"<0304>"];
            [[[added2.xored description] should] equal:@"<0506>"];
            [[[added2.hashed description] should] equal:@"<0708>"];
        });
        
        it(@"init or toJSON to serialze / deserialize data should contain same value", ^{
            NSArray* array = [added1 toJSON];
            //[[array should] equal:@[@1, @"AQI=", @"AwQ="]];
            Bucket* bucket = [[Bucket alloc] initWithJSONArray:array];
            [[[bucket.xored description] should] equal:@"<0102>"];
            [[[bucket.hashed description] should] equal:@"<0304>"];
        });
        
        it(@"group with 2 buckets should result in XOR operation", ^{
            Bucket* result = [added1 group:added2];
            [[[result.xored description] should] equal:@"<0404>"];
        });
        
        it(@"two XOR operations bring back original value", ^{
            Bucket* result = [added1 group:added2];
            result = [result group:added2];
            [[[result.xored description] should] equal:@"<0102>"];
        });
        
        it(@"group with 2 buckets of different size should result in XOR operation", ^{
            NSMutableData* content3 = [NSMutableData data];
            char bytesToAppend3[3] = {0x01, 0x02, 0x03};
            [content3 appendBytes:bytesToAppend3 length:sizeof(bytesToAppend3)];
            NSMutableData* hash3 = [NSMutableData data];
            char bytesToAppendHash3[3] = {0x04, 0x05, 0x06};
            [hash3 appendBytes:bytesToAppendHash3 length:sizeof(bytesToAppendHash3)];
            Bucket* added3 = [empty modifyItemsNumber:@1 xored:content3 hashed:hash3];
            
            Bucket* result = [added1 group:added3];
            [[[result.xored description] should] equal:@"<000003>"];
        });
    });
});

SPEC_END