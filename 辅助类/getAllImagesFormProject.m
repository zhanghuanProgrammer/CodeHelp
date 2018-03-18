
#import "getAllImagesFormProject.h"
#import "ZHFileManager.h"

@implementation getAllImagesFormProject

- (NSString *)description{
    return @"请将要抽取图片的工程路径拖到这个输入框中";
}

- (void)Begin:(NSString *)str{
    NSString *description=[self description];
    str=[str stringByReplacingOccurrencesOfString:description withString:@""];
    
    NSArray *arr=[ZHFileManager subPathFileArrInDirector:str hasPathExtension:@[@"png",@"jpg",@"gif"]];
    NSString *desktop=[ZHFileManager getDesktopInMac];
    desktop = [desktop stringByAppendingPathComponent:@"imagesTemp"];
    [ZHFileManager createDirectoryAtPath:desktop];
    for (NSInteger i=0; i<arr.count; i++) {
        @autoreleasepool {
            NSString *oldPath=arr[i];
            NSString *newpath=[desktop stringByAppendingPathComponent:[ZHFileManager getFileNameFromFilePath:oldPath]];
            [ZHFileManager copyItemAtPath:oldPath toPath:newpath];
        }
    }
    
    [self saveData:[NSString stringWithFormat:@"提取了%ld张",arr.count]];
}
@end