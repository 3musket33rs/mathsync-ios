#import <Foundation/Foundation.h>

@protocol Deserializer <NSObject>
-(id)deserialize:(NSData*)data;
@end