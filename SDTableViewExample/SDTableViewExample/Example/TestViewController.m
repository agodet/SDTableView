//
//  TestViewController.m
//  SDTableViewExample
//
//  Created by Lebrustiec Xavier on 12/06/2015.
//  Copyright (c) 2015 SU. All rights reserved.
//

#import "TestViewController.h"
#import "SDCellDefinition.h"
#import "SDSectionDefinition.h"

@interface TestViewController ()

@property (nonatomic, strong) SDTableViewHandler *handler;

@end

@implementation TestViewController

- (id)init {
    self = [super initWithNibName:@"TestViewController" bundle:nil];
    if (self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Simple TableView";
    
    self.handler = [[SDTableViewHandler alloc] init];
    self.handler.datasource = self;
    
    self.tableView.dataSource = self.handler;
    self.tableView.delegate = self.handler;

    [self.handler reloadDefinitions];
    [self.tableView reloadData];
}


#pragma mark - SDTableViewHandlerDataSource

//To implement
- (NSArray *)sectionsDefinitions {
    
    //Section 1
    SDCellDefinition *cell1Def = [[SDCellDefinition alloc] initWithTarget:self heightMethod:@selector(cell1Height) displayMethod:@selector(cell1Def) selectedMethod:@selector(cell1selected)];
    
    SDCellDefinition *cell2Def = [[SDCellDefinition alloc] initWithTarget:self heightMethod:@selector(cell2Height) displayMethod:@selector(cell2Def) selectedMethod:nil object:@{@"key" : @"Any Object Value"}];
    
    SDSectionDefinition *section1Definition = [[SDSectionDefinition alloc] initWithTarget:self headerViewMethod:@selector(headerSection1Def:) object:@"test String" cells:@[cell1Def, cell2Def]];
    
    
    //Section 2
    SDCellDefinition *cell3Def = [[SDCellDefinition alloc] initWithTarget:self heightMethod:@selector(cell3Height) displayMethod:@selector(cell3Def)];
    
    SDCellDefinition *cell4Def = [[SDCellDefinition alloc] initWithTarget:self heightMethod:@selector(cell4Height) displayMethod:@selector(cell4Def)];
    
    SDSectionDefinition *section2Definition = [[SDSectionDefinition alloc] initWithTarget:self headerViewMethod:@selector(headerSection2Def:) object:@{ @"key" : @"test2"} cells:@[cell3Def, cell4Def]];
    
    return @[section1Definition, section2Definition];
}

#pragma mark - Header Definitions

- (UIView *)headerSection1Def:(NSString *)stringParam {
    NSLog(@"String param : %@", stringParam);
    return self.headerSection1;
}

- (UIView *)headerSection2Def:(NSDictionary *)dictParams {
    NSLog(@"Dict param : %@", dictParams);
    return self.headerSection2;
}

#pragma mark - Cell Definitions

#pragma mark Cell 1

- (NSNumber *)cell1Height {
    return [NSNumber numberWithFloat:self.cell1.frame.size.height];
}

- (UITableViewCell *)cell1Def {
    return self.cell1;
}

- (void)cell1selected {
    NSLog(@"Cell 1 selected !");
}

#pragma mark Cell 2

- (NSNumber *)cell2Height {
    return [NSNumber numberWithFloat:self.cell2.frame.size.height];
}

- (UITableViewCell *)cell2Def {
    return self.cell2;
}

#pragma mark Cell 3

- (NSNumber *)cell3Height {
    return [NSNumber numberWithFloat:self.cell3.frame.size.height];
}

- (UITableViewCell *)cell3Def {
    return self.cell3;
}

#pragma mark - Cell 4

- (NSNumber *)cell4Height {
    return [NSNumber numberWithFloat:self.cell4.frame.size.height];
}

- (UITableViewCell *)cell4Def {
    return self.cell4;
}

@end
