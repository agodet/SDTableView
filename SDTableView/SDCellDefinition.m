#import "SDCellDefinition.h"

@implementation SDCellDefinition

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod
      selectedMethod:(SEL)selectedMethod
              object:(id)object
            editable:(BOOL)editable
        editingStyle:(UITableViewCellEditingStyle)editingStyle
      withEditMethod:(SEL)editModelMethod
             canMove:(BOOL)canMove
      withMoveMethod:(SEL)moveMethod
accessoryButtonTappedMethod:(SEL)accessoryButtonTappedMethod{
    
    if (self = [super init]) {
        self.target = target;
        self.heightMethod = heightMethod;
        self.displayMethod = displayMethod;
        self.selectedMethod = selectedMethod;
        self.object = object;
        self.editable = editable;
        self.editingStyle = editingStyle;
        self.editModelMethod = editModelMethod;
        self.canMove = canMove;
        self.moveMethod = moveMethod;
        self.accessoryButtonTappedMethod = accessoryButtonTappedMethod;
    }
    return self;
}

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod {
    
    return [self initWithTarget:target
                   heightMethod:heightMethod
                  displayMethod:displayMethod
                 selectedMethod:nil object:nil
                       editable:NO
                   editingStyle:UITableViewCellEditingStyleNone
                 withEditMethod:nil
                        canMove:NO
                 withMoveMethod:nil
    accessoryButtonTappedMethod:nil];
}

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod
      selectedMethod:(SEL)selectedMethod {
    
    return [self initWithTarget:target
                   heightMethod:heightMethod
                  displayMethod:displayMethod
                 selectedMethod:selectedMethod
                         object:nil
                       editable:NO
                   editingStyle:UITableViewCellEditingStyleNone
                 withEditMethod:nil
                        canMove:NO
                 withMoveMethod:nil
    accessoryButtonTappedMethod:nil];
}

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod
      selectedMethod:(SEL)selectedMethod
              object:(id)object{
    
    return [self initWithTarget:target
                   heightMethod:heightMethod
                  displayMethod:displayMethod
                 selectedMethod:selectedMethod
                         object:object
                       editable:NO
                   editingStyle:UITableViewCellEditingStyleNone
                 withEditMethod:nil
                        canMove:NO
                 withMoveMethod:nil
    accessoryButtonTappedMethod:nil];
}

@end