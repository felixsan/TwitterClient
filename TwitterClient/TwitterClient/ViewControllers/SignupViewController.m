//
//  SignupViewController.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/19/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "SignupViewController.h"
#import "CredentialCell.h"

@interface SignupViewController ()

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;


- (CredentialCell *)getCellFromTextField:(UITextField *)textField;

@end

@implementation SignupViewController

# pragma mark - View Life Cycle Functions

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Account";

    // Change the Nav Bar color on both iOS 6 and 7
    UIColor *twitterColor = [UIColor colorWithRed:(8.0 / 255.0) green:(172.0 / 255.0) blue:(237.0 / 255.0) alpha:1.0];
    SEL selector =  NSSelectorFromString(@"setBarTintColor:");
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    if ([self.navigationController.navigationBar respondsToSelector:selector])
    {
        self.navigationController.navigationBar.barTintColor = twitterColor;
    } else {
        self.navigationController.navigationBar.tintColor = twitterColor;
    }

    // Add in our custom cell
    UINib *CredentialCellNib = [UINib nibWithNibName:@"CredentialCell" bundle:nil];
    [self.tableView registerNib:CredentialCellNib forCellReuseIdentifier:@"LoginCell"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CredentialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginCell"];

    if (indexPath.row == 0) {
        // Configure the UserName cell
        cell.cellLabel.text = @"User Name";
        cell.cellValue.placeholder = @"@name";
        cell.cellType = CredentialCellUserName;
        cell.cellValue.delegate = self;

    } else if (indexPath.row == 1) {
        // Configure the Password cell
        cell.cellLabel.text = @"Password";
        cell.cellValue.secureTextEntry = YES;
        cell.cellValue.placeholder = @"Required";
        cell.cellType = CredentialCellPassword;
        cell.cellValue.delegate = self;
    }

    return cell;
}

- (CredentialCell *)getCellFromTextField:(UITextField *)textField {
    CredentialCell  *cell = nil;
    UIView *parentView = textField.superview;
    while(parentView) {
        if([parentView isKindOfClass:[CredentialCell class]]) {
            cell = parentView;
            break;
        }
        parentView = parentView.superview;
    }
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Automatically add the "@" to the username to reflect it's their twitter handle
    CredentialCell *cell= [self getCellFromTextField:textField];
    if (cell.cellType == CredentialCellUserName && [textField.text isEqualToString:@""]) {
        textField.text = @"@";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    // Automatically remove the "@" to the username if the user never added anything to the field
    CredentialCell *cell= [self getCellFromTextField:textField];
    if (cell.cellType == CredentialCellUserName && [textField.text isEqualToString:@"@"]) {
        textField.text = @"";
    }

}



@end
