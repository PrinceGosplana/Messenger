//
//  ListMessengersViewController.h
//  myMessengerVK
//
//  Created by Oleksandr Isaiev on 05.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListMessengersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *dialogs;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) UILabel * textMsg;
- (void) update;

@end
