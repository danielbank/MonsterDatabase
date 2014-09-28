//
//  monsterTableViewController.h
//  MonsterDatabase
//
//  Created by Daniel Bank on 9/20/14.
//  Copyright (c) 2014 Annuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface monsterTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *monsterNames;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *monsterDB;
@end
