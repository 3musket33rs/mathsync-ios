#import <Foundation/Foundation.h>

@protocol Serializer <NSObject>
-(NSData*)serialize:(id)item;
@end
