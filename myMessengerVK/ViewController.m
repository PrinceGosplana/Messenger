//
//  ViewController.m
//  myMessengerVK
//
//  Created by Administrator on 03.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import "ViewController.h"

#define APP_ID @"4574749"


static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";

static NSArray  * SCOPE = nil;

@interface ViewController () {
    UIImageView * _baseLayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];

    _baseLayer = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 60, self.view.frame.size.height/2 - 60, 120, 120)];
    _baseLayer.userInteractionEnabled = YES;
    _baseLayer.backgroundColor = [UIColor whiteColor];
    _baseLayer.layer.borderColor = [UIColor colorWithRed:70.0/255.0 green:111.0/255.0 blue:160.0/255.0 alpha:1].CGColor;
    _baseLayer.layer.borderWidth = 2;
    _baseLayer.layer.masksToBounds = YES;
    _baseLayer.layer.cornerRadius = 10;
    
    
    UIImageView * vkLogo = [[UIImageView alloc] initWithFrame:CGRectMake(_baseLayer.frame.size.width/2 - 40, _baseLayer.frame.size.height/2 - 24, 80, 48)];
    vkLogo.image = [UIImage imageNamed:@"ic_vk_logo_nb"];
    [_baseLayer addSubview:vkLogo];

    UILabel * textLog = [[UILabel alloc] initWithFrame:CGRectMake(_baseLayer.frame.size.width/2 - 40, _baseLayer.frame.size.height/2 + 30, 80, 20)];
    [textLog setFont:[UIFont fontWithName:@"thirteen_pixel_fonts" size:18]];
    [textLog setTextColor:[UIColor colorWithRed:70.0/255.0 green:111.0/255.0 blue:160.0/255.0 alpha:1]];
    textLog.text = @"Log in";
    [textLog setTextAlignment:NSTextAlignmentCenter];
    [_baseLayer addSubview:textLog];
    [self.view addSubview:_baseLayer];
    self.title = @"Log in";
    
    UITapGestureRecognizer * tapToGo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorize)];
    [_baseLayer addGestureRecognizer:tapToGo];
    
    [VKSdk initializeWithDelegate:self andAppId:APP_ID];
    if ([VKSdk wakeUpSession])
    {
        [self startWorking];
    }
}

- (void) authorize {
    [VKSdk authorize:SCOPE revokeAccess:YES];
//    NSLog(@"authorize");
}

- (void)startWorking {
    [self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VK delegate
- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {

}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self startWorking];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    [self startWorking];
}
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}


@end
