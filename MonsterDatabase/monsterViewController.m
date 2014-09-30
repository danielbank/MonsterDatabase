//
//  ViewController.m
//  MonsterDatabase
//
//  Created by Daniel Bank on 8/23/14.
//  Copyright (c) 2014 Annuit. All rights reserved.
//

#import "monsterViewController.h"

@interface monsterViewController ()

@end

@implementation monsterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *docsDir;
    NSArray *dirPaths;

    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"monsters.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath: _databasePath] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_monsterDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS MONSTERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, TYPE TEXT, SCARINESS TEXT)";
            
            if(sqlite3_exec(_monsterDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _status.text = @"Failed to create table";
            }
            sqlite3_close(_monsterDB);
        } else {
            _status.text = @"Failed to open/create database";
        }
    }
    [self findMonster:_thisMonster];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveMonster:(id)sender {
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_monsterDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO MONSTERS (name, type, scariness) VALUES (\"%@\", \"%@\", \"%@\")", _monsterName.text, _monsterType.text, _monsterScariness.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_monsterDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _status.text = @"Monster added";
            _monsterName.text = @"";
            _monsterType.text = @"";
            _monsterScariness.text = @"";
        } else {
            _status.text = @"Failed to add monster";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_monsterDB);
    }
    [_monsterName resignFirstResponder];
}

- (IBAction)findMonster:(id)sender {
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_monsterDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT type, scariness FROM MONSTERS WHERE name=\"%@\"", _thisMonster];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_monsterDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                _status.text = @"Match found";
                NSString *typeField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *scarinessField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                _monsterName.text = _thisMonster;
                _monsterType.text = typeField;
                _monsterScariness.text = scarinessField;
                                            
            } else {
                _status.text = @"Match not found";
                _monsterType.text = @"";
                _monsterScariness.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_monsterDB);
    }
    [_monsterName resignFirstResponder];
}
@end
