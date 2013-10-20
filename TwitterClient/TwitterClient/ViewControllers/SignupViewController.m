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

//@property (weak, nonatomic) IBOutlet UITableView *credentialsView;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;

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

    // Configure the cell...
    NSLog(@"Creating cell - %@", cell);
    cell.cellLabel.text = @"Foo";
    cell.cellValue.placeholder = @"Placeholder";

    return cell;
}

@end
