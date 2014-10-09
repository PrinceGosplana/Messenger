//
//  DetailTableViewCell.m
//  myMessengerVK
//
//  Created by Administrator on 07.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

@synthesize fromLabel, fromUIView, toLabel, toUIView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
//        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
//        self.descriptionLabel.textColor = [UIColor blackColor];
//        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
//        
//        [self addSubview:self.descriptionLabel];
    }
    return self;
}
@end
