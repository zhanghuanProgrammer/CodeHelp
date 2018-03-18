#import "ZH_LJZ.h"
#import "NSStringHelp.h"
#import "ZHNSString.h"

@implementation ZH_LJZ

- (NSString *)description{
    return @"请将要懒加载的属性或者成员变量复制到这个输入框中";
}

- (void)Begin:(NSString *)str{
    if (str.length<=0) {
        [self saveData:@"不要为空"];
        return;
    }
    
    NSString *regexStr=@"@property.*?\\)";//匹配.m文件夹里面的函数实现
    
    //正则表达式之替换
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    
    str  = [regularExpression stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *arrTemp=[str componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    for (NSString *str in arrTemp) {
        NSString *temp=[str stringByReplacingOccurrencesOfString:@";" withString:@""];
        if ([temp rangeOfString:@"*"].location!=NSNotFound) {
            NSArray *arrSub=[temp componentsSeparatedByString:@"*"];
            [dicM setValue:arrSub[0] forKey:arrSub[1]];
        }
    }
    
    NSMutableString *strM=[NSMutableString string];
    
    for (NSString *str in dicM) {
        [strM appendString:[self getCode_NSMutableArray:dicM[str] dataArr:str]];
        [strM appendString:@"\n"];
    }

    [self saveData:strM];
    
    if (strM.length<=0) {
        [self saveData:@"空"];
    }
}

- (NSString *)getCode_NSMutableArray:(NSString *)replaceNSMutableArray dataArr:(NSString *)replaceDataArr{
    
    NSString *text=@"- (NSMutableArray *)dataArr{\n\
    ____if (!_dataArr) {\n\
    _________dataArr=[NSMutableArray <#array#>];\n\
    ____}\n\
    ____return _dataArr;\n\
    }";
    text=[text stringByReplacingOccurrencesOfString:@"____" withString:@"    "];
    
    NSStringHelp *codeHelp=[NSStringHelp new];
    [codeHelp addDataToReplaceDicM_All_WithOld:@"NSMutableArray" new:replaceNSMutableArray];
    [codeHelp addDataToReplaceDicM_All_WithOld:@"dataArr" new:replaceDataArr];
    
    text=[codeHelp getRepeatCodeWithOringalCode:text];
    
    return text;
}

@end
