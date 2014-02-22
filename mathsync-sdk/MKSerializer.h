#import <Foundation/Foundation.h>

@protocol MKSerializer <NSObject>
-(NSData*)serialize:(id)item;
@end
