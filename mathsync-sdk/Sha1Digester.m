#import "Sha1Digester.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Sha1Digester

+(id)sharedSha1Digester {
    static Sha1Digester *sharedMySha1Digester = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMySha1Digester = [[self alloc] init];
    });
    return sharedMySha1Digester;
}

-(NSData*)digest:(NSData*)data {
    if (data == nil) {
        @throw [NSException
                exceptionWithName:@"IllegalArugument"
                reason:@"Can not digest a null data"
                userInfo:nil];
    }
    unsigned char hashBytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([data bytes], [data length], hashBytes);
    NSData *hashedData = [[NSData alloc] initWithBytes:hashBytes length:CC_SHA1_DIGEST_LENGTH];
    return hashedData;
}



@end
