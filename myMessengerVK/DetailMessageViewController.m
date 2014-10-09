//
//  DetailMessageViewController.m
//  myMessengerVK
//
//  Created by Oleksandr Isaiev on 06.10.14.
//  Copyright (c) 2014 Oleksandr Isaiev. All rights reserved.
//

#import "DetailMessageViewController.h"
#import <VKSdk.h>
#import "DetailTableViewCell.h"

#define GREEN [UIColor colorWithRed:60.f/255.f green:180.f/255.f blue:15.f/255.f alpha:1.f];
#define GREY [UIColor colorWithRed:160.f/255.f green:165.f/255.f blue:160.f/255.f alpha:1.f];
#define HEIGHT_ROW 55
#define CORNER_RADIUS 15
#define WIDTH_MESSAGE 200
#define FONT_SIZE 14
#define TEXTFIELD_VIEW_HEIGHT 70
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface DetailMessageViewController () {
    CGPoint _originalCenter;
    NSMutableArray *_rowHeight;
    CGRect _tableFrame;

}

@property (strong, nonatomic) NSMutableArray * listMessages;

@end


@implementation DetailMessageViewController

#pragma maek - Properties

- (NSMutableArray *) listMessages
{
    if (!_listMessages) {
        _listMessages = [NSMutableArray array];
    }
    return _listMessages;
}

- (NSString *)currentID
{
    if (!self.userID) {
        _currentID = self.chatID;
    } else {
        _currentID = self.userID;
    }
    return _currentID;
}

- (NSString *)methodIdentifier
{
    if (!self.userID) {
        _methodIdentifier = @"chat_id";
    } else {
        _methodIdentifier = @"user_id";
    }
    return _methodIdentifier;
}


- (void)viewDidLoad {
    

    _originalCenter = self.view.center;
    _tableFrame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TEXTFIELD_VIEW_HEIGHT - 64);
    _tableView = [[UITableView alloc] initWithFrame:_tableFrame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];

    [self.view addSubview:_tableView];
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
    _listMessages = [NSMutableArray array];
    self.navigationItem.title = self.user.userFullName;
    dispatch_async(kBgQueue, ^{
        [self doRequestWithOffset:0];
    });
    

    _viewForTextField = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TEXTFIELD_VIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width, TEXTFIELD_VIEW_HEIGHT)];
    _viewForTextField.backgroundColor = GREY;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width - 80, TEXTFIELD_VIEW_HEIGHT - 20)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.placeholder = @"enter message";
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.delegate = self;
    [_viewForTextField addSubview:_textField];
    
    UIButton * sendMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendMessage setTitle:@"Send" forState:UIControlStateNormal];
    sendMessage.frame = CGRectMake(15 + _textField.frame.size.width, 10, [UIScreen mainScreen].bounds.size.width - 15 - _textField.frame.size.width,  _textField.frame.size.height);
    [sendMessage addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    sendMessage.tintColor = [UIColor whiteColor];
    [_viewForTextField addSubview:sendMessage];
    
    [self.view addSubview:_viewForTextField];
    
    // add activiti indicator
    _activitiIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activitiIndicator];
    _activitiIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [_activitiIndicator startAnimating];
}

- (void)doRequestWithOffset:(NSInteger)offset
{
    NSNumber *offsetNumber = [NSNumber numberWithInteger:offset];
    VKRequest *request = [VKRequest requestWithMethod:@"messages.getHistory"
                                        andParameters:@{@"user_id":_userID,
                                                        @"count":@60,
                                                        @"offset":offsetNumber}
                                        andHttpMethod:@"GET"];
    [request executeWithResultBlock:^(VKResponse *response) {
        [_listMessages addObjectsFromArray:[response.json valueForKey:@"items"]];
        [self.tableView reloadData];
        [_activitiIndicator stopAnimating];
        _activitiIndicator.hidden = YES;
    }errorBlock:^(NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

- (NSString *)getDescriptionWithKey:(NSString *)key
{
    NSDictionary *values = @{@"photo":@"Фотография",
                             @"video":@"Видеозапись",
                             @"audio":@"Аудиозапись",
                             @"doc":@"Документ",
                             @"wall":@"Запись на стене",
                             @"wall_reply":@"Комментарий к записи на стене",};
    return [values valueForKey:key];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdentitier = [NSString stringWithFormat:@"Cell%li%li", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentitier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentitier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI);

        id msg = [_listMessages objectAtIndex:indexPath.row];
        NSArray *attachments = [msg valueForKey:@"attachments"];
        
        NSString *strMessage;
        if (!attachments) {
            strMessage = [msg valueForKey:@"body"];
        } else {
            id attachment = [attachments firstObject];
            NSString *type = [attachment valueForKey:@"type"];
            strMessage = [self getDescriptionWithKey:type];
        }
        BOOL sent = [[msg valueForKey:@"out"] boolValue];
        CGSize sizeTxtMessage = [self sizeForText:strMessage];
        sizeTxtMessage.height -= 10.0f;
        
        UIView * messageView;
        
        if (sent) {
            messageView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - WIDTH_MESSAGE - 15, 5, WIDTH_MESSAGE, sizeTxtMessage.height)];
            messageView.backgroundColor = GREEN;
        } else {
            messageView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, WIDTH_MESSAGE, sizeTxtMessage.height)];
            messageView.backgroundColor = GREY;
        }
        
        messageView.layer.masksToBounds = YES;
        messageView.layer.cornerRadius = CORNER_RADIUS;
        
        UILabel * txtMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, WIDTH_MESSAGE - 10, sizeTxtMessage.height - 10)];
        [txtMessageLabel setFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE]];
        [txtMessageLabel setTextColor:[UIColor whiteColor]];
        txtMessageLabel.numberOfLines = 0;
        txtMessageLabel.text = strMessage;
        [messageView addSubview:txtMessageLabel];
        
        [cell.contentView addSubview:messageView];

    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id message = [_listMessages objectAtIndex:indexPath.row];
    NSString * txt = [message valueForKey:@"body"];
    
    CGSize size = [self sizeForText:txt];
    return MAX(size.height, HEIGHT_ROW);
}

- (CGSize)sizeForText:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(WIDTH_MESSAGE, HUGE_VALF) lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += 48.0f;
    return size;
}

- (void) sendMessage {
    [_activitiIndicator startAnimating];
    _activitiIndicator.hidden = NO;
    VKRequest *sendRequest = [VKRequest requestWithMethod:@"messages.send"
                                            andParameters:@{self.methodIdentifier:self.currentID,
                                                            @"message":_textField.text}
                                            andHttpMethod:@"GET"];
    [sendRequest executeWithResultBlock:^(VKResponse *response) {
        NSString *mid = [response.json stringValue];
        VKRequest *getMessage = [VKRequest requestWithMethod:@"messages.getById"
                                               andParameters:@{@"message_ids":mid}
                                               andHttpMethod:@"GET"];
        [getMessage executeWithResultBlock:^(VKResponse *response) {
            NSArray *messages = [response.json valueForKey:@"items"];
            [_listMessages insertObject:[messages firstObject] atIndex:0];
            NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0
                                                                       inSection:0]];
            [_tableView insertRowsAtIndexPaths:arr
                                  withRowAnimation:UITableViewRowAnimationBottom];
            _textField.text = @"";
            [_textField resignFirstResponder];
        }errorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [_activitiIndicator stopAnimating];
    _activitiIndicator.hidden = YES;
}


#pragma mark - TextField Delegate


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldShouldReturn:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textField.text.length) {
        [self sendMessage];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView commitAnimations];
    [_textField resignFirstResponder];
    return YES;
}

- (void) keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = [UIScreen mainScreen].bounds;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    newFrame.origin.y -= keyboardFrame.size.height;
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}

@end
