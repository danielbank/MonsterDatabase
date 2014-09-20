//
//  ViewController.h
//  ContactsList
//
//  Created by Daniel Bank on 8/23/14.
//  Copyright (c) 2014 Annuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *monsterName;
@property (weak, nonatomic) IBOutlet UITextField *monsterType;
@property (weak, nonatomic) IBOutlet UITextField *monsterScariness;
@property (weak, nonatomic) IBOutlet UILabel *status;

- (IBAction)saveMonster:(id)sender;
- (IBAction)findMonster:(id)sender;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *monsterDB;
@end
