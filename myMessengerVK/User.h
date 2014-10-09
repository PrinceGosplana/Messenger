#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) BOOL isDialog;
@property (strong, nonatomic) NSData * userImageData;
@property (strong, nonatomic) NSString * userFullName;

@end
