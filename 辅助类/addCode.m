#import "addCode.h"

@implementation addCode
- (NSString *)description{
    return @"请将要添加换行符的代码添加到这个输入框中,如果要使用特殊的替换符,请在最前面写@1";
}
- (void)Begin:(NSString *)str{
    NSString *text=str;
    text=[text stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    text=[text stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    text =[text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\\n"];
    
    if ([text hasPrefix:@"@1"]) {
        text = [text substringFromIndex:2];
        text=[text stringByReplacingOccurrencesOfString:@"    " withString:@"\t"];
        text=[text stringByReplacingOccurrencesOfString:@"\t" withString:@"____"];
        text=[@"@\"" stringByAppendingString:text];
        text=[text stringByAppendingString:@"\""];
    }
    
    [self saveData:text];
}

@end