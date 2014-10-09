#import <UIKit/UIKit.h>
#import <VKSdk.h>
//#import "ListMessengersViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>//, VKSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray * messages;
@property (strong, nonatomic) NSMutableDictionary * users;
//@property (strong, nonatomic) ListMessengersViewController * listController;

+ (AppDelegate *)sharedDelegate;

@end

