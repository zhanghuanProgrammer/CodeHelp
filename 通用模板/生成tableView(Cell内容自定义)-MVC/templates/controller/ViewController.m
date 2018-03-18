#import "{{ 最大文件夹名字 }}.h"

{% for p in 自定义Cell %}
#import "{{ p }}.h"
{% /for %}

@interface {{ 最大文件夹名字 }} ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation {{ 最大文件夹名字 }}

- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];

        {% for p in 自定义Cell %}
        {{ p }}CellModel *{{ p | lowercase }}Model=[{{ p }}CellModel new];
        {{ p | lowercase }}Model.title=@"";
        {{ p | lowercase }}Model.iconImageName=@"";
        [_dataArr addObject:{{ p | lowercase }}Model];
        {% /for %}
	}
	return _dataArr;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
	self.tableView.tableFooterView=[UIView new];
	self.edgesForExtendedLayout=UIRectEdgeNone;
}

#pragma mark - TableViewDelegate实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.row];

    {% for p in 自定义Cell %}
    if ([modelObjct isKindOfClass:[{{ p }}CellModel class]]){
        {{ p }}TableViewCell *{{ p | lowercase }}Cell=[tableView dequeueReusableCellWithIdentifier:@"{{ p }}TableViewCell"];
        {{ p }}CellModel *model=modelObjct;
        [{{ p | lowercase }}Cell refreshUI:model];
        return {{ p | lowercase }}Cell;
    }
    {% /for %}

	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.row];
    {% for p in 自定义Cell %}
    if ([modelObjct isKindOfClass:[{{ p }}CellModel class]]){
        return 44.0f;
    }
    {% /for %}
	return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

{% if tempView.viewType equalsString "1" %}
/**是否可以编辑*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
	if (indexPath.row==self.dataArr.count) {
		return NO;
	}
	return YES;
}

/**编辑风格*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleDelete;
}

/**设置编辑的控件  删除,置顶,收藏*/
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	//设置删除按钮
	UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[self.dataArr removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
	}];
	return  @[deleteRowAction];
}
{% /if %}

@end
