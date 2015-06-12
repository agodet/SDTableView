# SDTableView
Simple Definition TableView is a UITableView Framework designed for fast and advanced development. Easy to use, it provides everything basically needed when playing around UITableViews.

##Cococapod
Available for cocoapods

##Implementation

First, your controller must implement at least the SDTableViewHandlerDatasource protocol

> .h file

```objective-c
@interface YourViewController : UIViewController <SDTableViewHandlerDatasource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

...

@end
```

You only need to implement 1 simple method for it to work ! 

> .m file

```objective-c
- (NSArray *)sectionsDefinitions {
    
    //Do your business stuff here !
}
```

Then load the sections definitions and you're good to go !

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.handler = [[SDTableViewHandler alloc] init];
    self.handler.datasource = self;
    
    self.tableView.dataSource = self.handler;
    self.tableView.delegate = self.handler;

    [self.handler reloadDefinitions];
    [self.tableView reloadData];
}
```

## Example

```objective-c
- (NSArray *)sectionsDefinitions {
    
    //First, the cell(s) definition(s) ...
    SDCellDefinition *cell1Def = [[SDCellDefinition alloc] initWithTarget:self heightMethod:@selector(cell1Height) displayMethod:@selector(cell1Def) selectedMethod:@selector(cell1selected)];

    SDCellDefinition *cell2Def = [[SDCellDefinition alloc] initWithTarget:self heightMethod:@selector(cell2Height) displayMethod:@selector(cell2Def) selectedMethod:nil object:@{@"key" : @"Any Object Value"}]; // You can pass any object as a parameter. If you have multiple parameters, use a structure like NSArray

    //... then the section(s) definition(s)
    SDSectionDefinition *sectionDefinition = [[SDSectionDefinition alloc] initWithCells:@[cell1Def, cell2Def]];
    return @[sectionDefinition];
}

//Cell 1 definition

//First the Cell Height method
- (NSNumber *)cell1Height {
    return [NSNumber numberWithFloat:44.0];
}

//Then the Cell itself
- (UITableViewCell *)cell1Def {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SomeIdentifier"];
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SomeIdentifier"];
	}
    return cell;
}

- (void)cell1selected {
    NSLog(@"Cell selected !");
}

//Cell 2 definition

- (NSNumber *)cell2Height {
    return [NSNumber numberWithFloat:35.0];
}

- (UITableViewCell *)cell2Def {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SomeOtherIdentifier"];
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SomeOtherIdentifier"];
	}
    return cell;
}
```

Of course, this example is pretty basic, but the framework offers a lot of functionnalities such as editable cell, foldable sections, etc ... 

A more advanced use / case is implemented in the example project.

## License

No specific license

