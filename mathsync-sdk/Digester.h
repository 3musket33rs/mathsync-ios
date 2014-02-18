#import <Foundation/Foundation.h>

@protocol Digester <NSObject>
-(NSData*)digest:(NSData*)data;
@end
