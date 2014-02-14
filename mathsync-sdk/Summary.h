#import <Foundation/Foundation.h>
#import "Difference.h"

@protocol Summary <NSObject>
-(id<Summary>)plus:(NSData*)data;
-(id<Summary>)minus:(id<Summary>)data;
-(NSString*)toJSON;
-(id<Difference>)toDifference;
@end
