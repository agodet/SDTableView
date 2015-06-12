//
//  TestViewController.h
//  SDTableViewExample
//
//  Created by Lebrustiec Xavier on 12/06/2015.
//  Copyright (c) 2015 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTableViewHandler.h"

@interface TestViewController : UIViewController <SDTableViewHandlerDatasource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell4;
@property (strong, nonatomic) IBOutlet UIView *headerSection1;
@property (strong, nonatomic) IBOutlet UIView *headerSection2;

@end
