
#import "ZHOrderForFiles.h"
#import "ZHFileManager.h"
#import "ZHNSString.h"

@implementation ZHOrderForFiles

- (NSString *)description{
    return @"请将要 为文件添加顺序索引 文件夹路径拖到这个输入框中";
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
    NSArray *tempArr=[ZHFileManager contentsOfDirectoryAtPath:directory];
    NSMutableArray *fileArr=[NSMutableArray array];
    for (NSString *str in tempArr) {
        if (![[ZHFileManager getFileNameFromFilePath:str]hasPrefix:@"."]) {
            [fileArr addObject:str];
        }
    }
    
    NSMutableArray *orderArrM=[NSMutableArray array];
    NSMutableArray *orderFileArrM=[NSMutableArray array];
    NSMutableArray *noOrderFileArrM=[NSMutableArray array];
    
    for (NSString *str in fileArr) {
        NSString *fileName=[ZHFileManager getFileNameFromFilePath:str];
        if ([ZHFileManager getFileType:fileName]==FileTypeFile) {
            fileName=[fileName stringByDeletingPathExtension];
        }
        if ([fileName rangeOfString:@"."].location!=NSNotFound) {
            NSString *numStr=[fileName substringToIndex:[fileName rangeOfString:@"."].location];
            if ([ZHNSString isValidateNumber:numStr]) {
                [orderArrM addObject:numStr];
                [orderFileArrM addObject:str];
            }else{
                [noOrderFileArrM addObject:str];
            }
        }else{
            [noOrderFileArrM addObject:str];
        }
    }
    for (NSString *str in noOrderFileArrM) {
        NSString *adapterNumString=[NSString stringWithFormat:@"%ld",[self getAdapterNumFromArr:orderArrM]];
        [ZHFileManager changeFileOldPath:str newFileName:[[adapterNumString stringByAppendingString:@"."] stringByAppendingString:[ZHFileManager getFileNameFromFilePath:str]]];
        [orderArrM addObject:adapterNumString];
    }
}

- (NSInteger)getAdapterNumFromArr:(NSArray *)arr{
    for (NSInteger i=1; i<=[self getMaxNumFromArr:arr]+1; i++) {
        if ([arr containsObject:[NSString stringWithFormat:@"%ld",i]]==NO) {
            return i;
        }
    }
    return 0;
}
- (NSInteger)getMaxNumFromArr:(NSArray *)arr{
    if (arr.count==0) {
        return 1;
    }
    arr=[arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue]>[obj2 integerValue];
    }];
    return [arr[arr.count-1] integerValue];
}

@end