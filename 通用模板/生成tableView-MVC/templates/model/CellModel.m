#import "{{ 自定义Cell }}CellModel.h"

@implementation {{ 自定义Cell }}CellModel

- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}
- (void)setContent:(NSString *)content{
	_content=content;
	if (self.width==0) {
		self.width=200;
	}
	self.size=[content boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
}

@end
