#import "AppDelegate.h"
#import "User.h"

#define APP_ID @"4574749"

static NSArray * scope = nil;


@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *) sharedDelegate
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _messages = [NSMutableArray array];
//    [self downloadMessages];
//    _listController = [self.window.rootViewController.navigationController.viewControllers firstObject];
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:70.0/255.0 green:111.0/255.0 blue:160.0/255.0 alpha:1], NSForegroundColorAttributeName,
                                                            [UIFont fontWithName:@"GFSCUS1D" size:12.0], NSFontAttributeName, nil]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//#pragma mark - VK Delegate
//-(BOOL)application:(UIApplication *)application
//           openURL:(NSURL *)url
// sourceApplication:(NSString *)sourceApplication
//        annotation:(id)annotation
//{
//    [VKSdk processOpenURL:url fromApplication:sourceApplication];
//    return YES;
//}
//
//- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
//{
//    
//}
//
//- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
//{
//    
//}
//
//- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError
//{
//    
//}
//
//- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
//{
//    [self.window.rootViewController presentViewController:controller animated:YES completion:^{}];
//}
//
//- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
//{
////    [self startWorking];
//}
//
//- (void)vkSdkRenewedToken:(VKAccessToken *)newToken
//{
//    NSLog(@"- (void)vkSdkRenewedToken:(VKAccessToken *)newToken");
//}
//
//- (void) startWorking {
//    VKRequest *avatarRequ = [VKRequest requestWithMethod:@"users.get"
//                                           andParameters:@{@"fields":@"photo_50",}
//                                           andHttpMethod:@"GET"];
//    [avatarRequ executeWithResultBlock:^(VKResponse *response) {
//        NSString *link = [[response.json firstObject] valueForKey:@"photo_50"];
//        NSURL *avatarURL = [NSURL URLWithString:link];
//        NSData *data = [NSData dataWithContentsOfURL:avatarURL];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
//        [image drawInRect:CGRectMake(0, 0, 30, 30)];
//        _selfAvatar= UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    } errorBlock:^(NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Ошибка" message:@"Время подсоеденения к серверу истекло" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
//    }];
//    VKRequest *request = [VKRequest requestWithMethod:@"messages.getDialogs"
//                                        andParameters:@{@"count":@30}
//                                        andHttpMethod:@"GET"];
//    [request executeWithResultBlock:^(VKResponse *response) {
//        NSArray *items = [response.json valueForKey:@"items"];
//        [_dialogs addObjectsFromArray:items];
//        NSMutableString *uIDs = [NSMutableString string];
//        for (id msg in items) {
//            NSNumber *chatID = [msg valueForKey:@"chat_id"];
//            if (chatID) {
//                [self loadChatWithMessage:msg];
//            } else {
//                NSString *userID = [[[msg valueForKey:@"message"] valueForKey:@"user_id"] stringValue];
//                [uIDs appendString:userID];
//                [uIDs appendString:@","];
//            }
//        }
//        [uIDs deleteCharactersInRange:NSMakeRange([uIDs length]-1, 1)];
//        [self loadUserDataWithUserIDs:uIDs];
//    } errorBlock:^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}
//
//- (void)loadChatWithMessage:(id)message
//{
//    User *user = [[User alloc] init];
//    user.isDialog = YES;
//    NSString *link = [message valueForKey:@"photo_50"];
//    NSURL *url = [NSURL URLWithString:link];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    user.userImage = [UIImage imageWithData:data];
//    
//    NSUInteger n = [[message valueForKey:@"users_count"] integerValue];
//    NSString *title = [NSString stringWithFormat:@"%d участников", n];
//    user.userFullName = title;
//    [_users setValue:user forKey:[message valueForKey:@"chat_id"]];
//}
//
//- (void)loadUserDataWithUserIDs:(NSString *)userIDs
//{
//    VKRequest *r = [VKRequest requestWithMethod:@"users.get"
//                                  andParameters:@{@"fields":@"photo_50,online,online_mobile",
//                                                  @"user_ids":userIDs}
//                                  andHttpMethod:@"GET"];
//    [r executeWithResultBlock:^(VKResponse *response) {
//        for (id userData in response.json) {
//            User *user = [[User alloc] init];
//            user.isDialog = NO;
//            user.userFullName = [NSString stringWithFormat:@"%@ %@",
//                             [userData valueForKey:@"first_name"],
//                             [userData valueForKey:@"last_name"]];
//            
//            NSString *avatarLink = [userData valueForKey:@"photo_50"];
//            NSURL *avatarURL = [NSURL URLWithString:avatarLink];
//            NSData *imgData = [NSData dataWithContentsOfURL:avatarURL];
//            UIImage *image = [UIImage imageWithData:imgData];
//            user.userImage = image;
//            
//            NSString *userID = [[userData valueForKey:@"id"] stringValue];
//            [_users setValue:user forKey:userID];
//        }
//        [_dialogView update];
//    } errorBlock:^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}
//- (void) downloadMessages
//{
//    VKRequest *avatarRequ = [VKRequest requestWithMethod:@"users.get"
//                                           andParameters:@{@"fields":@"photo_50",}
//                                           andHttpMethod:@"GET"];
//    [avatarRequ executeWithResultBlock:^(VKResponse *response) {
//        NSString *link = [[response.json firstObject] valueForKey:@"photo_50"];
//        NSURL *avatarURL = [NSURL URLWithString:link];
//        NSData *data = [NSData dataWithContentsOfURL:avatarURL];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        //        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
//        //        [image drawInRect:CGRectMake(0, 0, 30, 30)];
//        //        _selfAvatar= UIGraphicsGetImageFromCurrentImageContext();
//        //        UIGraphicsEndImageContext();
//    } errorBlock:^(NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Ошибка" message:@"Время подсоеденения к серверу истекло" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
//    }];
//    VKRequest *request = [VKRequest requestWithMethod:@"messages.getDialogs"
//                                        andParameters:@{@"count":@30}
//                                        andHttpMethod:@"GET"];
//    [request executeWithResultBlock:^(VKResponse *response) {
//        NSArray *items = [response.json valueForKey:@"items"];
//        [_messages addObjectsFromArray:items];
//        NSMutableString *uIDs = [NSMutableString string];
//        for (id msg in items) {
//            NSNumber *chatID = [msg valueForKey:@"chat_id"];
//            if (chatID) {
//                [self loadChatWithMessage:msg];
//            } else {
//                NSString *userID = [[[msg valueForKey:@"message"] valueForKey:@"user_id"] stringValue];
//                [uIDs appendString:userID];
//                [uIDs appendString:@","];
//            }
//        }
//        [uIDs deleteCharactersInRange:NSMakeRange([uIDs length]-1, 1)];
//        [self loadUserDataWithUserIDs:uIDs];
//    } errorBlock:^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    NSLog(@"Users Dict: %@", _users);
//}
//
//- (void)loadChatWithMessage:(id)message
//{
//    User *user = [[User alloc] init];
//    user.isDialog = YES;
//    NSString *link = [message valueForKey:@"photo_50"];
//    NSURL *url = [NSURL URLWithString:link];
//    user.userImageData = [NSData dataWithContentsOfURL:url];
//    
//    NSUInteger countUsers = [[message valueForKey:@"users_count"] integerValue];
//    NSString *title = [NSString stringWithFormat:@"%ld участников", (long)countUsers];
//    user.userFullName = title;
//    [_users setValue:user forKey:[message valueForKey:@"chat_id"]];
//}
//
//- (void)loadUserDataWithUserIDs:(NSString *)userIDs
//{
//    VKRequest * request = [VKRequest requestWithMethod:@"users.get"
//                                         andParameters:@{@"fields":@"photo_50,online,online_mobile",
//                                                         @"user_ids":userIDs}
//                                         andHttpMethod:@"GET"];
//    [request executeWithResultBlock:^(VKResponse *response) {
//        for (id userData in response.json) {
//            User *user = [[User alloc] init];
//            user.isDialog = NO;
//            user.userFullName = [NSString stringWithFormat:@"%@ %@",
//                                 [userData valueForKey:@"first_name"],
//                                 [userData valueForKey:@"last_name"]];
//            
//            NSString *avatarLink = [userData valueForKey:@"photo_50"];
//            NSURL *avatarURL = [NSURL URLWithString:avatarLink];
//            user.userImageData = [NSData dataWithContentsOfURL:avatarURL];
//            
//            NSString *userID = [[userData valueForKey:@"id"] stringValue];
//            [_users setValue:user forKey:userID];
//        }
////        [_listController update];
//    } errorBlock:^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}

@end
