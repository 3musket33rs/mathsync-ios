#import <Foundation/Foundation.h>

@protocol MKDigester <NSObject>
-(NSData*)digest:(NSData*)data;
@end
