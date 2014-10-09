//
//  ListMessengersViewController.m
//  myMessengerVK
//
//  Created by Oleksandr Isaiev on 05.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import "ListMessengersViewController.h"
#import <VKSdk.h>
#import "User.h"
#import "User.h"
#import "DetailMessageViewController.h"

#define SIZE_IMG 65
#define HEIGHT_ROW 65
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 

@implementation ListMessengersViewController

- (void) update {
    [_tableView reloadData];
}
- (void)viewDidLoad {
    
//
    
    [super viewDidLoad];

    [_activityIndicator startAnimating];
    [_activityIndicator hidesWhenStopped];
    [_tableView setUserInteractionEnabled:NO];
    
    _dialogs = [NSMutableArray array];
    _users = [NSMutableDictionary dictionary];
    dispatch_async(kBgQueue, ^{
        [self downloadMessages];
    });
    

    self.tableView.separatorColor = [UIColor clearColor];

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dialogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdentifier = [NSString stringWithFormat:@"Cell%ld-%ld", (long)indexPath.section, (long)indexPath.row];

    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        id message = [[_dialogs objectAtIndex:indexPath.row] valueForKey:@"message"];
        NSString *userID = [[message valueForKey:@"user_id"] stringValue];
        NSString * userMsg = [message valueForKey:@"body"];
        CGSize sizeTxtMessage = [self sizeForText:userMsg];
        
        UIImageView * backgroundLayer = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, sizeTxtMessage.height + 46.0f)];
        backgroundLayer.clipsToBounds = YES;
        backgroundLayer.layer.cornerRadius = 30;
        backgroundLayer.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:170.0/255.0 blue:165.0/255.0 alpha:0.5];
        
        User * user = [_users valueForKey:userID];
        
        
        
        // image user
        UIImageView * userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_IMG - 10, SIZE_IMG - 10)];
        userImage.clipsToBounds = YES;
        userImage.layer.cornerRadius = (SIZE_IMG - 10)/2;
        userImage.image = [UIImage imageWithData:user.userImageData];
        [backgroundLayer addSubview:userImage];
        
        // full name user
        UILabel * nameUser = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 240, 20)];
        [nameUser setFont:[UIFont fontWithName:@"Helvetica-bold" size:17]];
        nameUser.text = user.userFullName;
        [backgroundLayer addSubview:nameUser];
        
        // text message
        _textMsg = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 180, sizeTxtMessage.height + 20.0f)];
        _textMsg.numberOfLines = 0;
        [_textMsg setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        _textMsg.text = userMsg;
        [_textMsg setTextAlignment:NSTextAlignmentLeft];
        [backgroundLayer addSubview:_textMsg];
        _textMsg.tag = 50;
        [cell.contentView addSubview:backgroundLayer];

        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id message = [[_dialogs objectAtIndex:indexPath.row] valueForKey:@"message"];
    NSString * txt = [message valueForKey:@"body"];

    CGSize size = [self sizeForText:txt];
    CGFloat height = 10.0f + size.height + 10.0f + 18.0f + 10.0f;
    return MAX(height, HEIGHT_ROW);
}

- (CGSize)sizeForText:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(280.0f, HUGE_VALF) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

//DETATIL_MES
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DETATIL_MES" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DETATIL_MES"]) {
        DetailMessageViewController *view = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id msg = [[_dialogs objectAtIndex:indexPath.row] valueForKey:@"message"];
        NSString *uID = [[msg valueForKey:@"user_id"] stringValue];
        User *user = [_users valueForKey:uID];
        
        view.userID = uID;
        view.user = user;
    }
}

#pragma mark - VKMessages

- (void) downloadMessages
{

    VKRequest *request = [VKRequest requestWithMethod:@"messages.getDialogs"
                                        andParameters:@{@"count":@10}
                                        andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSArray *items = [response.json valueForKey:@"items"];
        [_dialogs addObjectsFromArray:items];
        NSMutableString *uIDs = [NSMutableString string];
        for (id msg in items) {
            NSNumber *chatID = [msg valueForKey:@"chat_id"];
            if (chatID) {
                [self loadChatWithMessage:msg];
            } else {
                NSString *userID = [[[msg valueForKey:@"message"] valueForKey:@"user_id"] stringValue];
                [uIDs appendString:userID];
                [uIDs appendString:@","];
            }
        }
        [uIDs deleteCharactersInRange:NSMakeRange([uIDs length]-1, 1)];
        [self loadUserDataWithUserIDs:uIDs];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    NSLog(@"Users Dict: %@", _users);
}

- (void)loadChatWithMessage:(id)message
{
    User *user = [[User alloc] init];
    user.isDialog = YES;
    NSString *link = [message valueForKey:@"photo_50"];
    NSURL *url = [NSURL URLWithString:link];
    user.userImageData = [NSData dataWithContentsOfURL:url];
    
    NSUInteger countUsers = [[message valueForKey:@"users_count"] integerValue];
    NSString *title = [NSString stringWithFormat:@"%ld участников", (long)countUsers];
    user.userFullName = title;
    [_users setValue:user forKey:[message valueForKey:@"chat_id"]];
}

- (void)loadUserDataWithUserIDs:(NSString *)userIDs
{
    VKRequest * request = [VKRequest requestWithMethod:@"users.get"
                                  andParameters:@{@"fields":@"photo_50,online,online_mobile",
                                                  @"user_ids":userIDs}
                                  andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        for (id userData in response.json) {
            User *user = [[User alloc] init];
            user.isDialog = NO;
            user.userFullName = [NSString stringWithFormat:@"%@ %@",
                             [userData valueForKey:@"first_name"],
                             [userData valueForKey:@"last_name"]];
            
            NSString *avatarLink = [userData valueForKey:@"photo_50"];
            NSURL *avatarURL = [NSURL URLWithString:avatarLink];
            user.userImageData = [NSData dataWithContentsOfURL:avatarURL];
            
            NSString *userID = [[userData valueForKey:@"id"] stringValue];
            [_users setValue:user forKey:userID];
        }
        [self update];
        [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
        [_tableView setUserInteractionEnabled:YES];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
