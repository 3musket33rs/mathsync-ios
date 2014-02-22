#import <Foundation/Foundation.h>

@protocol MKDeserializer <NSObject>
-(id)deserialize:(NSData*)data;
@end