#import <UIKit/UIKit.h>

#import "{{ 自定义Cell }}TableViewCell.h"

@interface {{ 自定义Cell }}TableViewCell : UITableViewCell

- (void)refreshUI:({{ 自定义Cell }}CellModel *)dataModel;

@end
