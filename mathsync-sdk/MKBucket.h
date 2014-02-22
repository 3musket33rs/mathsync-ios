#import <Foundation/Foundation.h>

@interface MKBucket : NSObject
@property(strong, nonatomic)NSNumber* itemsNumber;
@property(strong, nonatomic)NSData* xored;
@property(strong, nonatomic)NSData* hashed;
+(id)emptyBucket;
-(id)initWithJSONArray:(NSArray*)array;
-(id)group:(MKBucket*)other;
-(id)modifyItemsNumber:(NSNumber*)variation xored:(NSData*)content hashed:(NSData*)digested;
-(BOOL)isEmpty;
-(NSArray*)toJSON;
@end
