//
//  SUSectionDefinition.m
//  SNCF
//
//  Created by Xavier Le Brustiec on 21/01/2014.
//  Copyright (c) 2014 SNCF. All rights reserved.
//

#import "SDSectionDefinition.h"

@implementation SDSectionDefinition

-(id)initWithTitle:(NSString *)title cells:(NSArray *)cells {
    self = [super init];
    if(self){
        self.simpleTitle = title;
        self.cells = [[NSMutableArray alloc] initWithArray:cells];
    }
    return self;
}

-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod object:(id)object cells:(NSArray *)cells {
    return [self initWithTarget:target headerViewMethod:headerViewMethod footerViewMethod:nil object:object cells:cells sectionFoldable:NO sectionFolded:NO];
}

-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod object:(id)object cells:(NSArray *)cells sectionFoldable:(BOOL)sectionFoldable{
    return [self initWithTarget:target headerViewMethod:headerViewMethod footerViewMethod:nil object:object cells:cells sectionFoldable:sectionFoldable sectionFolded:NO];
}

-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod object:(id)object cells:(NSArray *)cells sectionFoldable:(BOOL)sectionFoldable sectionFolded:(BOOL)sectionFolded{
    return [self initWithTarget:target headerViewMethod:headerViewMethod footerViewMethod:nil object:object cells:cells sectionFoldable:sectionFoldable sectionFolded:sectionFolded];
}

-(id)initWithTarget:(id)target headerViewMethod:(SEL)headerViewMethod footerViewMethod:(SEL)footerViewMethod object:(id)object cells:(NSArray *)cells sectionFoldable:(BOOL)sectionFoldable sectionFolded:(BOOL)sectionFolded {
    self = [super init];
    if(self){
        self.target = target;
        self.headerViewMethod = headerViewMethod;
        self.footerViewMethod = footerViewMethod;
        self.object = object;
        self.cells = [[NSMutableArray alloc] initWithArray:cells];
        self.sectionFoldable = sectionFoldable;
        self.sectionFolded = sectionFolded;
    }
    return self;
}

-(id)initWithCells:(NSArray *)cells {
    self = [super init];
    if(self){
        self.cells = [[NSMutableArray alloc] initWithArray:cells];
    }
    return self;
}

@end
