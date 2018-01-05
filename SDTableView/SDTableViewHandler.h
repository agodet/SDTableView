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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//ScrollView
- (void)tableViewDidScroll:(UIScrollView *)scrollView;

@end



@interface SDTableViewHandler : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<SDTableViewHandlerDatasource> datasource;
@property (nonatomic, weak) id<SDTableViewHandlerDelegate> delegate;

- (float)heightForSectionAtIndex:(NSInteger)index;
- (void)reloadDefinitions;
- (void)tableView:(UITableView *)tableView foldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView unfoldSectionAtIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing animated:(BOOL)animated;

@end
