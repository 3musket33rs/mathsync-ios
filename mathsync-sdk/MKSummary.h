#import <Foundation/Foundation.h>
#import "MKDifference.h"

@protocol MKSummary <NSObject>
-(id<MKSummary>)plus:(NSData*)data;
-(id<MKSummary>)plusAll:(NSArray*)items;
-(id<MKSummary>)minus:(id<MKSummary>)data;
-(NSString*)toJSON;
-(id<MKDifference>)toDifference;
@end
