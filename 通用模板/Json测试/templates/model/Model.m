#import "{{ 自定义Cell }}Model.h"

@implementation {{ 自定义Cell }}Model

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isSelect{{ 自定义Cell }}1=YES;
        self.isSelect{{ 自定义Cell }}2=YES;
        self.isSelect{{ 自定义Cell }}3=YES;
        self.isSelect{{ 自定义Cell }}4=YES;
        self.isSelect{{ 自定义Cell }}5=YES;
        self.title{{ 自定义Cell }}1=@"title";
        self.title{{ 自定义Cell }}2=@"title";
        self.title{{ 自定义Cell }}3=@"title";
        self.title{{ 自定义Cell }}4=@"title";
        self.title{{ 自定义Cell }}5=@"title";
        self.age{{ 自定义Cell }}1=18;
        self.age{{ 自定义Cell }}2=18;
        self.age{{ 自定义Cell }}3=18;
        self.age{{ 自定义Cell }}4=18;
        self.age{{ 自定义Cell }}5=18;
        self.content{{ 自定义Cell }}1=@"content";
        self.content{{ 自定义Cell }}2=@"content";
        self.content{{ 自定义Cell }}3=@"content";
        self.content{{ 自定义Cell }}4=@"content";
        self.content{{ 自定义Cell }}5=@"content";
        self.width{{ 自定义Cell }}1=20.1;
        self.width{{ 自定义Cell }}2=20.1;
        self.width{{ 自定义Cell }}3=20.1;
        self.width{{ 自定义Cell }}4=20.1;
        self.width{{ 自定义Cell }}5=20.1;
        
        self.nextModel = [Class<#index#>Model new];
        
        [self.dataArr addObject:@"1111111111"];
        [self.dataArr addObject:@"2222222222"];
        [self.dataArr addObject:@"3333333333"];
        [self.dataArr addObject:@"4444444444"];
        [self.dataArr addObject:@"5555555555"];
        [self.dataArr addObjectsFromArray:self.dataArr];
        [self.dataArr addObjectsFromArray:self.dataArr];
        [self.dataArr addObjectsFromArray:self.dataArr];
        [self.dataArr addObjectsFromArray:self.dataArr];
        [self.dataArr addObjectsFromArray:self.dataArr];
        [self.dataArr addObjectsFromArray:self.dataArr];
    }
    return self;
}

@end

