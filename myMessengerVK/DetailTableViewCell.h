//
//  DetailTableViewCell.h
//  myMessengerVK
//
//  Created by Administrator on 07.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UIView *fromUIView;
@property (strong, nonatomic) IBOutlet UIView *toUIView;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;

@end
