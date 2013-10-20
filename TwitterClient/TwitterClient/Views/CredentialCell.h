//
//  CredentialCell.h
//  TwitterClient
//
//  Created by Felix Santiago on 10/20/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

typedef NS_ENUM(NSInteger, CredentialCellType) {
    CredentialCellUserName,
    CredentialCellPassword
};

@interface CredentialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UITextField *cellValue;
@property (nonatomic) CredentialCellType cellType;

@end
