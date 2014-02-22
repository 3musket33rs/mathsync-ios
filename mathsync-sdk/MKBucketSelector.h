#import <Foundation/Foundation.h>

@protocol MKBucketSelector <NSObject>
-(NSArray*)selectBuckets:(NSData*)content;
@end
