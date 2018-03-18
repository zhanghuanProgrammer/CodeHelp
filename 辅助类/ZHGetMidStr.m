#import "ZHGetMidStr.h"
#import "ZHNSString.h"

@implementation ZHGetMidStr

- (NSString *)description{
    NSString *filePath=[self creatFatherFile:@"代码助手" andData:@[@"LeftStr",@"RightStr",@"拼接符",@"是否要去除左右包含符1:0(默认为否)"]];
    [self openFile:filePath];
    return @"指导文件已经创建在桌面上: 代码助手.m  ,请勿修改指定内容 ,请把 文本内容 放在这里";
}

- (void)Begin:(NSString *)str{
    
    NSDictionary *dic=[self getDicFromFileName:@"代码助手"];
    
    NSString *text=str;
    NSArray *arr;
    if ([self judge:dic[@"LeftStr"]]&&[self judge:dic[@"RightStr"]]) {
        arr=[ZHNSString getMidStringBetweenLeftString:dic[@"LeftStr"] RightString:dic[@"RightStr"] withText:text getOne:NO withIndexStart:0 stopString:nil];
    }
    
    if (![dic[@"是否要去除左右包含符1:0(默认为否)"] isEqualToString:@"1"]) {
        NSMutableArray *arrM=[NSMutableArray array];
        NSString *LeftStr=dic[@"LeftStr"];
        NSString *RightStr=dic[@"RightStr"];
        for (NSString *str in arr) {
            [arrM addObject:[NSString stringWithFormat:@"%@%@%@",LeftStr,str,RightStr]];
        }
        arr=[NSArray arrayWithArray:arrM];
    }
    
    if (arr.count>0) {
        
        if ([self judge:dic[@"拼接符"]]) {
            [self saveData:[arr componentsJoinedByString:@"\n"]];
        }else{
            [self saveData:[arr componentsJoinedByString:@" "]];
        }
    }else{
        [self saveData:@"获取失败,或者是不存在"];
    }
}

@end