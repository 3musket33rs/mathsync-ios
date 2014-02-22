#import <Kiwi/Kiwi.h>
#import <XCTest/XCTest.h>

#import "MKSha1Digester.h"


@interface MKSha1DigesterTests : XCTestCase

@end


SPEC_BEGIN(Sha1DigesterSpec)

describe(@"Sha1Digester", ^{
    context(@"gives hash with", ^{
        
        
        __block MKSha1Digester* sha1Digester;
        __block NSMutableData* dataForAbc;
        
        beforeEach(^{
            sha1Digester = [MKSha1Digester sharedSha1Digester];
            dataForAbc = [NSMutableData data];
            char abc[3] = {0x61, 0x62, 0x63};
            [dataForAbc appendBytes:abc length:sizeof(abc)];
        });
        
        // In the spec below abc characters are used for reference
        // http://tools.ietf.org/html/rfc3174
        it(@"constant byte length according to spec", ^{
             NSData* result = [sha1Digester digest:dataForAbc];
            
            [[[result description] should] equal:@"<a9993e36 4706816a ba3e2571 7850c26c 9cd0d89d>"];
        });
    });
});

SPEC_END