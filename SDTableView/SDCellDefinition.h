#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDCellDefinition : NSObject

@property (nonatomic, assign) id  target;
@property (nonatomic, assign) SEL heightMethod;
@property (nonatomic, assign) SEL displayMethod;
@property (nonatomic, assign) SEL selectedMethod;
@property (nonatomic, assign) SEL accessoryButtonTappedMethod;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
@property (nonatomic, assign) SEL editModelMethod;
@property (nonatomic, assign) BOOL canMove;
@property (nonatomic, assign) SEL moveMethod;

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
accessoryButtonTappedMethod:(SEL)accessoryButtonTappedMethod;

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod;

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod
      selectedMethod:(SEL)selectedMethod;

- (id)initWithTarget:(id)target
        heightMethod:(SEL)heightMethod
       displayMethod:(SEL)displayMethod
      selectedMethod:(SEL)selectedMethod
              object:(id)object;

@end