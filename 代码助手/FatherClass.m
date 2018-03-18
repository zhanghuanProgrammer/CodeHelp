#import "SIngleCategroy.h"
#import "FatherClass.h"

@implementation FatherClass
- (void)Begin:(NSString *)str{
    [self saveData:str];
}
- (void)saveData:(NSString *)text{
    if (text.length<=0) {
        text=@"操作成功";
    }
    [SIngleCategroy setValueWithIdentity:@"value" withValue:text];
}
- (NSString *)description{
    return @"你还没有对你的类进行方法描述";
}
@end
