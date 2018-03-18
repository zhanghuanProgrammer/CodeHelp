#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZHRemoveTheCommentsTypeAllComments=0,//删除全部注释
    ZHRemoveTheCommentsTypeFileInstructionsComments=1,//删除文件说明注释
    ZHRemoveTheCommentsTypeEnglishComments=2,//删除英文注释
    ZHRemoveTheCommentsTypeDoubleSlashComments=3,//删除//注释
    ZHRemoveTheCommentsTypeFuncInstructionsComments=4//删除/ **\/或\/ ***\/注释
} ZHRemoveTheCommentsType;

@interface ZHRemoveTheComments : NSObject

+ (NSString *)BeginWithFilePath:(NSString *)filePath type:(ZHRemoveTheCommentsType)type;

@end