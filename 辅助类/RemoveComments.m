#import "RemoveComments.h"
#import "ZHRemoveTheComments.h"

@implementation RemoveComments

- (NSString *)description{
    return @"0//删除全部注释\n\
    1,//删除文件说明注释\n\
    2,//删除英文注释\n\
    3,//删除//注释\n\
    4//删除/ ** /或/ *** /注释\n请将要去除注释的工程路径拖到这个输入框中";
}

- (void)Begin:(NSString *)str{
    if (str.length>0) {
        unichar ch=[str characterAtIndex:0];
        NSString *reslut=@"";
        switch (ch) {
            case '0':
            {
                reslut=[ZHRemoveTheComments BeginWithFilePath:[str substringFromIndex:1] type:0];
            }
                break;
            case '1':
            {
                reslut=[ZHRemoveTheComments BeginWithFilePath:[str substringFromIndex:1] type:1];
            }
                break;
            case '2':
            {
                reslut=[ZHRemoveTheComments BeginWithFilePath:[str substringFromIndex:1] type:2];
            }
                break;
            case '3':
            {
                reslut=[ZHRemoveTheComments BeginWithFilePath:[str substringFromIndex:1] type:3];
            }
                break;
            case '4':
            {
                reslut=[ZHRemoveTheComments BeginWithFilePath:[str substringFromIndex:1] type:4];
            }
                break;
            default:{
                reslut=[ZHRemoveTheComments BeginWithFilePath:str type:0];
            }break;
        }
        [self saveData:reslut];
        return;
    }
    [self saveData:@"路径为空"];
}

@end