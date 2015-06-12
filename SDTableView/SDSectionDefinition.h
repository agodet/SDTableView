//
//  Created by Xavier Le Brustiec on 21/01/2014.
//  Copyright (c) 2014 SNCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSectionDefinition : NSObject

//Simple title
@property (nonatomic, strong) NSString *simpleTitle;

@property (nonatomic, assign) id target;
@property (nonatomic, strong) id object;

//HeaderView
@property (nonatomic, assign) SEL headerViewMethod;
//FooterView
@property (nonatomic, assign) SEL footerViewMethod;
//Associated cells
@property (nonatomic, strong) NSMutableArray *cells;
//Section Foldable
@property (nonatomic) BOOL sectionFoldable;
@property (nonatomic) BOOL sectionFolded;

-(id)initWithTitle:(NSString *)title cells:(NSArray *)cells;
-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod object:(id)object cells:(NSArray *)cells;
-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod footerViewMethod:(SEL)footerViewMethod object:(id)object cells:(NSArray *)cells sectionFoldable:(BOOL)sectionFoldable sectionFolded:(BOOL)sectionFolded;
-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod object:(id)object cells:(NSArray *)cells sectionFoldable:(BOOL)sectionFoldable;
-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod object:(id)object cells:(NSArray *)cells sectionFoldable:(BOOL)sectionFoldable sectionFolded:(BOOL)sectionFolded;

-(id)initWithCells:(NSArray *)cells;

@end
