#import <Foundation/Foundation.h>

@protocol BucketSelector <NSObject>
-(NSArray)selectBuckets(NSData*)content;
@end
