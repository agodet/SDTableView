//
//  Created by Lebrustiec Xavier on 09/06/2015.
//  Copyright (c) 2015 SNCF. All rights reserved.
//

#import "SDTableViewHandler.h"
#import "SDSectionDefinition.h"
#import "SDCellDefinition.h"

#define EMPTY_STRING @""

@interface SDTableViewHandler()

@property (nonatomic, strong) NSMutableArray *sectionsArray;

@end

@implementation SDTableViewHandler

#pragma mark - Public functions

- (void)reloadDefinitions {
    [self dataSourceCheck:^(BOOL dataSourceExisting) {
        if (dataSourceExisting){
            self.sectionsArray = [[NSMutableArray alloc] initWithArray:[self.datasource sectionsDefinitions]];
        }
    }];
}

- (float)heightForSectionAtIndex:(NSInteger)index {
    if(index < 0 || [self.sectionsArray count] <= index) return 0.0;
    
    float height = 0.0;
    SDSectionDefinition *section = (SDSectionDefinition *)self.sectionsArray[index];
    
    if(section.target &&
       section.headerViewMethod != nil &&
       [section.target respondsToSelector:section.headerViewMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIView *viewForSection = [section.target performSelector:section.headerViewMethod withObject:section.object withObject:[NSNumber numberWithInteger:index]];
#pragma clang diagnostic pop
        if (viewForSection){
            height += viewForSection.frame.size.height;
        }
    }
    if(!section.sectionFoldable || (section.sectionFoldable && !section.sectionFolded)) {
        
        for(SDCellDefinition *currentCellDef in section.cells){
            if ([currentCellDef.target respondsToSelector:currentCellDef.heightMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                height += [[currentCellDef.target performSelector:currentCellDef.heightMethod withObject:currentCellDef.object withObject:nil] floatValue];
#pragma clang diagnostic pop
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView foldSectionAtIndex:(NSInteger)index {
    if(index < 0 || [self.sectionsArray count] <= index) return;
    SDSectionDefinition *section = (SDSectionDefinition *)self.sectionsArray[index];
    if(section.sectionFoldable){
        //Will Fold
        if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:willFoldSectionAtIndex:)]){
            [self.delegate tableView:tableView willFoldSectionAtIndex:index];
        }
        section.sectionFolded = YES;
        [tableView reloadData];
        
        //Did Fold
        if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:didFoldSectionAtIndex:)]){
            [self.delegate tableView:tableView didFoldSectionAtIndex:index];
        }
    }
}

- (void)tableView:(UITableView *)tableView unfoldSectionAtIndex:(NSInteger)index {
    if(index < 0 || [self.sectionsArray count] <= index) return;
    SDSectionDefinition *section = (SDSectionDefinition *)self.sectionsArray[index];
    if(section.sectionFoldable){
        //Will Unfold
        if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:willUnfoldSectionAtIndex:)]){
            [self.delegate tableView:tableView willUnfoldSectionAtIndex:index];
        }
        section.sectionFolded = NO;
        [tableView reloadData];
        
        //Did Unfold
        if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:didUnfoldSectionAtIndex:)]){
            [self.delegate tableView:tableView didUnfoldSectionAtIndex:index];
        }
    }
}

#pragma mark - UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.sectionsArray count] <= section){
        return 0;
    }
    SDSectionDefinition *sectionDef = self.sectionsArray[section];
    if (sectionDef.sectionFoldable && sectionDef.sectionFolded){
        return 0;
    }
    return [sectionDef.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return nil; //Can't handle this !!!
    
    SDCellDefinition *cellDefinition = [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    if ([cellDefinition.target respondsToSelector:cellDefinition.displayMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        cell = [cellDefinition.target performSelector:cellDefinition.displayMethod withObject:cellDefinition.object withObject:indexPath];
#pragma clang diagnostic pop
    }
    else{
        NSLog(@"Target does not respond to displayMethod selector : %@", NSStringFromSelector(cellDefinition.displayMethod));
        return nil;
    }
    
    if ([cell isKindOfClass:[UITableViewCell class]]){
        return cell;
    }
    
    NSLog(@"Cell is not kind of UITableViewCell class !");
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return 0;
    
    SDCellDefinition *cellDefinition = [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    NSNumber *height = 0;
    if ([cellDefinition.target respondsToSelector:cellDefinition.heightMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        height = [cellDefinition.target performSelector:cellDefinition.heightMethod withObject:cellDefinition.object withObject:indexPath];
#pragma clang diagnostic pop
    }
    else{
        NSLog(@"Target does not respond to heightMethod selector !");
    }
    
    if ([height isKindOfClass:[NSNumber class]]){
        return [height floatValue];
    }
    
    NSLog(@"Height is not kind of NSNumber class !");
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return;
    
    SDCellDefinition *cellDefinition = [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    if ([cellDefinition.target respondsToSelector:cellDefinition.selectedMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (cellDefinition.object){
            [cellDefinition.target performSelector:cellDefinition.selectedMethod withObject:cellDefinition.object withObject:indexPath];
        }
        else{
            [cellDefinition.target performSelector:cellDefinition.selectedMethod withObject:indexPath];
        }
#pragma clang diagnostic pop
    }
    else if (cellDefinition.selectedMethod != nil){
        NSLog(@"Target does not respond to selectedMethod selector !");
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return;
    
    SDCellDefinition *cellDefinition = [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    if ([cellDefinition.target respondsToSelector:cellDefinition.accessoryButtonTappedMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (cellDefinition.object){
            [cellDefinition.target performSelector:cellDefinition.accessoryButtonTappedMethod withObject:cellDefinition.object withObject:indexPath];
        }
        else{
            [cellDefinition.target performSelector:cellDefinition.accessoryButtonTappedMethod withObject:indexPath];
        }
#pragma clang diagnostic pop
    }
    else if (cellDefinition.accessoryButtonTappedMethod != nil){
        NSLog(@"Target does not respond to accessoryButtonTappedMethod selector !");
    }
}

#pragma mark Headers

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.sectionsArray count] <= section)
        return EMPTY_STRING;
    
    SDSectionDefinition *sectionDefinition = (SDSectionDefinition *)[self.sectionsArray objectAtIndex:section];
    if(sectionDefinition.simpleTitle && ![EMPTY_STRING isEqualToString:sectionDefinition.simpleTitle]){
        return sectionDefinition.simpleTitle;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.sectionsArray count] <= section)
        return 0;
    
    SDSectionDefinition *sectionDefinition = (SDSectionDefinition *)[self.sectionsArray objectAtIndex:section];
    if(sectionDefinition.target && [sectionDefinition.target respondsToSelector:sectionDefinition.headerViewMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIView *viewForSection = [sectionDefinition.target performSelector:sectionDefinition.headerViewMethod withObject:sectionDefinition.object withObject:[NSNumber numberWithInteger:section]];
#pragma clang diagnostic pop
        return viewForSection.frame.size.height;
    }
    else if(sectionDefinition.simpleTitle && ![EMPTY_STRING isEqualToString:sectionDefinition.simpleTitle]){
        return 20; //Default height for simple sections' header
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.sectionsArray count] <= section)
        return nil;
    
    SDSectionDefinition *sectionDefinition = (SDSectionDefinition *)[self.sectionsArray objectAtIndex:section];
    if(sectionDefinition.target && [sectionDefinition.target respondsToSelector:sectionDefinition.headerViewMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIView *viewForSection = [sectionDefinition.target performSelector:sectionDefinition.headerViewMethod withObject:sectionDefinition.object withObject:[NSNumber numberWithInteger:section]];
#pragma clang diagnostic pop
        return viewForSection;
    }
    return nil;
}

#pragma mark Footers

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.sectionsArray count] <= section)
        return 0;
    
    SDSectionDefinition *sectionDefinition = (SDSectionDefinition *)[self.sectionsArray objectAtIndex:section];
    if(sectionDefinition.target && [sectionDefinition.target respondsToSelector:sectionDefinition.footerViewMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIView *viewForSection = [sectionDefinition.target performSelector:sectionDefinition.footerViewMethod withObject:sectionDefinition.object withObject:[NSNumber numberWithInteger:section]];
#pragma clang diagnostic pop
        return viewForSection.frame.size.height;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.sectionsArray count] <= section)
        return nil;
    
    SDSectionDefinition *sectionDefinition = (SDSectionDefinition *)[self.sectionsArray objectAtIndex:section];
    if(sectionDefinition.target && [sectionDefinition.target respondsToSelector:sectionDefinition.footerViewMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIView *viewForSection = [sectionDefinition.target performSelector:sectionDefinition.footerViewMethod withObject:sectionDefinition.object withObject:[NSNumber numberWithInteger:section]];
#pragma clang diagnostic pop
        return viewForSection;
    }
    return nil;
}

#pragma mark - Editing Style

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return NO;
    
    SDCellDefinition *cellDef = (SDCellDefinition *)[((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    
    return cellDef.editable;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return UITableViewCellEditingStyleNone;
    
    SDCellDefinition *cellDef = (SDCellDefinition *)[((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    
    return cellDef.editingStyle;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return;
    
    SDSectionDefinition *section = ((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]);
    SDCellDefinition *cellDef = [section.cells objectAtIndex:indexPath.row];
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        if(cellDef.target && [cellDef.target respondsToSelector:cellDef.editModelMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cellDef.target performSelector:cellDef.editModelMethod withObject:cellDef.object withObject:indexPath];
            if([section.cells count] == 0){
                [self.sectionsArray removeObjectAtIndex:indexPath.section];
            }
            
            [tableView beginUpdates];
            [self reloadDefinitions];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
#pragma clang diagnostic pop
        }
        else {
            NSLog(@"No target or method for edition");
        }
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert){
        if(cellDef.target && [cellDef.target respondsToSelector:cellDef.editModelMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cellDef.target performSelector:cellDef.editModelMethod withObject:cellDef.object withObject:indexPath];
        }
        else {
            NSLog(@"No target or method for edition");
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sectionsArray count] <= indexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells count] <= indexPath.row)
        return NO;
    
    SDCellDefinition *cellDef = (SDCellDefinition *)[((SDSectionDefinition *)[self.sectionsArray objectAtIndex:indexPath.section]).cells objectAtIndex:indexPath.row];
    if(cellDef.canMove){
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([self.sectionsArray count] <= sourceIndexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:sourceIndexPath.section]).cells count] <= sourceIndexPath.row)
        return;
    
    SDSectionDefinition *section = ((SDSectionDefinition *)[self.sectionsArray objectAtIndex:sourceIndexPath.section]);
    SDCellDefinition *cellDef = [section.cells objectAtIndex:sourceIndexPath.row];
    
    NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:destinationIndexPath.row inSection:destinationIndexPath.section];
    
    if(cellDef.target && [cellDef.target respondsToSelector:cellDef.moveMethod]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SDCellDefinition *insertCellDefinition = [self insertStyleCellDefinition];
        if (insertCellDefinition){
            SDSectionDefinition *insertSectionDefinition = [self insertStyleSectionDefinition];
            if (insertSectionDefinition){
                NSInteger insertCellRow = [insertSectionDefinition.cells indexOfObject:insertCellDefinition];
                if (insertCellRow < destinationIndexPath.row){
                    //If an insert cell is present at the top of table view, we adjust indexPath.row
                    moveIndexPath = [NSIndexPath indexPathForRow:destinationIndexPath.row - 1 inSection:destinationIndexPath.section];
                }
            }
        }
        
        [cellDef.target performSelector:cellDef.moveMethod withObject:cellDef.object withObject:moveIndexPath];
        [self reloadDefinitions]; //Will call the basic building method in subcontroller
#pragma clang diagnostic pop
    }
    else {
        NSLog(@"No target or method for edition");
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if ([self.sectionsArray count] <= proposedDestinationIndexPath.section
        && [((SDSectionDefinition *)[self.sectionsArray objectAtIndex:proposedDestinationIndexPath.section]).cells count] <= proposedDestinationIndexPath.row)
        return sourceIndexPath;
    
    SDCellDefinition *cellDef = (SDCellDefinition *)[((SDSectionDefinition *)[self.sectionsArray objectAtIndex:proposedDestinationIndexPath.section]).cells objectAtIndex:proposedDestinationIndexPath.row];
    if(cellDef.canMove){
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - Utils

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing animated:(BOOL)animated{
    if (editing){
        [self enableTableViewEditing:tableView animated:animated];
    }
    else{
        [self disableTableViewEditing: tableView animated:animated];
    }
}

-(void)enableTableViewEditing:(UITableView *)tableView animated:(BOOL)animated {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:isCurrentlyEditing:)]){
        [self.delegate tableView:tableView isCurrentlyEditing:YES];
    }
    [self reloadDefinitions];
    SDCellDefinition *insertCellDefinition = [self insertStyleCellDefinition];
    if (insertCellDefinition){
        SDSectionDefinition *insertSectionDefinition = [self insertStyleSectionDefinition];
        if (insertSectionDefinition){
            NSInteger section = [self.sectionsArray indexOfObject:insertSectionDefinition];
            NSInteger row = [insertSectionDefinition.cells indexOfObject:insertCellDefinition];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [tableView setEditing:YES animated:animated];
}

-(void)disableTableViewEditing:(UITableView *)tableView animated:(BOOL)animated {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:isCurrentlyEditing:)]){
        [self.delegate tableView:tableView isCurrentlyEditing:NO];
    }
    SDCellDefinition *insertCellDefinition = [self insertStyleCellDefinition];
    if (insertCellDefinition){
        SDSectionDefinition *insertSectionDefinition = [self insertStyleSectionDefinition];
        if (insertSectionDefinition){
            NSInteger section = [self.sectionsArray indexOfObject:insertSectionDefinition];
            NSInteger row = [insertSectionDefinition.cells indexOfObject:insertCellDefinition];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [tableView setEditing:NO animated:animated];
            [tableView beginUpdates];
            [self reloadDefinitions];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
        }
    }
    else {
        [tableView setEditing:NO animated:animated];
    }
}

-(SDCellDefinition*) insertStyleCellDefinition {
    for (SDSectionDefinition *currentSectionDefinition in self.sectionsArray){
        for (SDCellDefinition *currentCellDefinition in currentSectionDefinition.cells) {
            if (currentCellDefinition.editingStyle == UITableViewCellEditingStyleInsert){
                return currentCellDefinition;
            }
        }
    }
    return nil;
}

-(SDSectionDefinition*) insertStyleSectionDefinition {
    for (SDSectionDefinition *currentSectionDefinition in self.sectionsArray){
        for (SDCellDefinition *currentCellDefinition in currentSectionDefinition.cells) {
            if (currentCellDefinition.editingStyle == UITableViewCellEditingStyleInsert){
                return currentSectionDefinition;
            }
        }
    }
    return nil;
}

#pragma mark - Utils

-(void)dataSourceCheck:(void (^)(BOOL dataSourceExisting)) completionBlock {
    if (!self.datasource || ![self.datasource respondsToSelector:@selector(sectionsDefinitions)]){
        [NSException exceptionWithName:@"SUTableViewHandlerError" reason:[NSString stringWithFormat:@"No datasource implemented for SUTableViewHandler : %@", self] userInfo:nil];
        completionBlock(NO);
    }
    else {
        completionBlock(YES);
    }
}

@end
