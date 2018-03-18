#import <UIKit/UIKit.h>
#import "{{ TableViewCell }}.h"
@interface {{ TableViewCell }} : UITableViewCell

- (void)refreshUI:({{ 自定义Cell }}CellModel *)dataModel;

@end
