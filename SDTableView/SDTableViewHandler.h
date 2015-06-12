//
//  SUTableViewHandler.h
//  SNCF
//
//  Created by Lebrustiec Xavier on 09/06/2015.
//  Copyright (c) 2015 SNCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SDTableViewHandlerDatasource <NSObject>

- (NSArray *)sectionsDefinitions;

@end

@protocol SDTableViewHandlerDelegate <NSObject>

@optional
//TableView
- (void)tableView:(UITableView *)tableView willFoldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView willUnfoldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView didFoldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView didUnfoldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView isCurrentlyEditing:(BOOL)currentlyEditing;
//ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end



@interface SDTableViewHandler : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SDTableViewHandlerDatasource> datasource;
@property (nonatomic, assign) id<SDTableViewHandlerDelegate> delegate;

- (float)heightForSectionAtIndex:(NSInteger)index;
- (void)reloadDefinitions;
- (void)tableView:(UITableView *)tableView foldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView unfoldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing animated:(BOOL)animated;

@end
