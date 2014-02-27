#import <Foundation/Foundation.h>
#import "MKDifference.h"

@protocol MKSummary <NSObject>
-(id<MKSummary>)plus:(NSData*)data;
-(id<MKSummary>)plusAll:(NSEnumerator*)items;
-(id<MKSummary>)minus:(id<MKSummary>)data;
-(NSString*)toJSON;
-(id<MKDifference>)toDifference;
@end
