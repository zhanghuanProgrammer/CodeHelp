#import "{{ 自定义Cell }}TableViewCell.h"

@interface {{ 自定义Cell }}TableViewCell ()

{% for imageView in {{ 自定义Cell }}.UIImageView %}
@property (weak, nonatomic) IBOutlet UIImageView *{{ imageView }};
{% /for %}
{% for label in {{ 自定义Cell }}.UILabel %}
@property (weak, nonatomic) IBOutlet UILabel *{{ label }};
{% /for %}
{% for button in {{ 自定义Cell }}.UIButton %}
@property (weak, nonatomic) IBOutlet UIButton *{{ button }};
{% /for %}
{% for textView in {{ 自定义Cell }}.UITextView %}
@property (weak, nonatomic) IBOutlet UITextView *{{ textView }};
{% /for %}

@property (nonatomic,weak){{ 自定义Cell }}CellModel *dataModel;

@end

@implementation {{ 自定义Cell }}TableViewCell

- (void)refreshUI:({{ 自定义Cell }}CellModel *)dataModel{
	_dataModel=dataModel;
    
    {% for imageView in {{ 自定义Cell }}.UIImageView %}
    self.{{ imageView }}.image=[UIImage imageNamed:@"dataModel.{{ imageView }}"];
    {% /for %}
    {% for label in {{ 自定义Cell }}.UILabel %}
    self.{{ label }}.text=dataModel.{{ label }};
    {% /for %}
    {% for button in {{ 自定义Cell }}.UIButton %}
    [[self.{{ button }} new] setTitle:@"dataModel.{{ button }}" forState:(UIControlStateNormal)];
    {% /for %}
    {% for textView in {{ 自定义Cell }}.UITextView %}
    self.{{ textView }}.text=dataModel.{{ textView }};
    {% /for %}
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
