#import "{{ 自定义Cell }}TableViewCell.h"

@interface {{ 自定义Cell }}TableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,weak){{ 自定义Cell }}CellModel *dataModel;

@end

@implementation {{ 自定义Cell }}TableViewCell
- (void)refreshUI:({{ 自定义Cell }}CellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
	self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	//self.selectionStyle=UITableViewCellSelectionStyleNone;
	//self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

@end
