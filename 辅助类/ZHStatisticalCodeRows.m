#import "ZHStatisticalCodeRows.h"
#import "ZHFileManager.h"

@implementation ZHStatisticalCodeRows
- (NSString *)description{
    return @"请将要统计代码行数的工程路径拖到这个输入框中";
}
- (void)Begin:(NSString *)str{
    NSString *filePath=str;
    switch ([ZHFileManager getFileType:filePath]) {
        case FileTypeNotExsit:
        {
            [self saveData:@"路劲不存在"];
        }
            break;
        case FileTypeFile:
        {
            if ([filePath hasSuffix:@".m"]||[filePath hasSuffix:@".h"]) {
                [self saveData:[NSString stringWithFormat:@"代码文件行数(不包括空格)为:%ld",[self fileRows:filePath]]];
            }else{
                [self saveData:@"文件不是.h或者.m文件,无法统计代码行数!"];
            }
        }
            break;
        case FileTypeDirectory:
        {
            NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:filePath hasPathExtension:@[@".h",@".m"]];
            NSUInteger sum=0;
            for (NSString *fileName in fileArr) {
                sum+=[self fileRows:fileName];
            }
            [self saveData:[NSString stringWithFormat:@"工程所有文件行数总和(不包括空格)为:%ld",sum]];
        }
            break;
        case FileTypeUnkown:
        {
            [self saveData:@"文件类型未知"];
        }
            break;
    }
}

- (NSInteger)fileRows:(NSString *)filePath{
    NSString *content=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr=[content componentsSeparatedByString:@"\n"];
    NSInteger count=0;
    for (NSString *str in arr) {
        if (str.length>0) {
            count++;
        }
    }
    return count;
}
@end