
#import "ZHRemove_SVN_GIT.h"
#import "ZHFileManager.h"

@implementation ZHRemove_SVN_GIT

- (NSString *)description{
    return @"请将要 删除.git和.svn 文件夹路径拖到这个输入框中";
}

- (void)Begin:(NSString *)str{
    switch ([ZHFileManager getFileType:str]) {
        case FileTypeNotExsit:
        {
            [self saveData:@"路劲不存在"];
        }
            break;
        case FileTypeFile:
        {
            [self saveData:@"不是文件夹"];
        }
            break;
        case FileTypeDirectory:
        {
            [self addOrder:str];
            [self saveData:@"添加顺序索引成功!"];
        }
            break;
        case FileTypeUnkown:
        {
            [self saveData:@"文件类型未知"];
        }
            break;
    }
}

- (void)addOrder:(NSString *)directory{
    
    //先复制一份样板
    
    //有后缀的文件名
    NSString *tempFileName=[ZHFileManager getFileNameFromFilePath:directory];
    
    //无后缀的文件名
    NSString *fileName=[ZHFileManager getFileNameNoPathComponentFromFilePath:directory];
    
    //获取无文件名的路径
    NSString *newFilePath=[directory stringByReplacingOccurrencesOfString:tempFileName withString:@""];
    //拿到新的有后缀的文件名
    tempFileName=[tempFileName stringByReplacingOccurrencesOfString:fileName withString:[NSString stringWithFormat:@"%@备份",fileName]];
    
    newFilePath = [newFilePath stringByAppendingPathComponent:tempFileName];
    
    if([ZHFileManager fileExistsAtPath:newFilePath]){
        [ZHFileManager removeItemAtPath:newFilePath];
    }
    
    BOOL result=[ZHFileManager copyItemAtPath:directory toPath:newFilePath];
    
    if (result) {
        NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:directory pathContainDirector:@[@".svn",@".git"]];
        
        for (NSString *str in fileArr) {
            [ZHFileManager removeItemAtPath:str];
        }
    }
}

@end
