//
//  DetailMessageViewController.h
//  myMessengerVK
//
//  Created by Oleksandr Isaiev on 06.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DetailMessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (retain, nonatomic) UITableView *tableView;


@property (strong, nonatomic) NSString *methodIdentifier;

@property (strong, nonatomic) NSString *currentID;
@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIView * viewForTextField;
@property (strong, nonatomic) UITextField * textField;
@property (retain, nonatomic) UIActivityIndicatorView * activitiIndicator;

@end
