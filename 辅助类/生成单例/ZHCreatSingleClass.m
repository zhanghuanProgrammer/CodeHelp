#import "ZHCreatSingleClass.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "ZHFileManager.h"

@implementation ZHCreatSingleClass

- (NSString *)description{
    return @"请将要生成单例的名字填写到文本框里面";
}

- (void)Begin:(NSString *)str{
    if (str.length<=0) {
        [self saveData:@"不要为空"];
        return;
    }
    NSDictionary *dataDic=@{@"ClassName":str};
    
    if ([ZHCreatSingleClass exportTemplateForSingleClassWithParameter:dataDic]) {
        [self saveData:@"生成成功!"];
    }else{
        [self saveData:@"生成失败!"];
    }
}

+ (BOOL)exportTemplateForSingleClassWithParameter:(NSDictionary *)parameter{
    
    BOOL isSuccess =
    [self exportTemplateForSingleClassWithParameter_h:parameter]&&
    [self exportTemplateForSingleClassWithParameter_m:parameter];
    
    return isSuccess;
}

+ (BOOL)exportTemplateForSingleClassWithParameter_h:(NSDictionary *)parameter{
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    if (parameter.count<=0) {
        return NO;
    }
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"singleClass_h" ofType:@"txt"];
    
    NSString *resultH = [engine processTemplateInFileAtPath:templatePath withVariables:parameter];
    
    NSString *deskTopLocation=[ZHFileManager getDesktopInMac];
    NSString *pathH = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h", [parameter allValues][0]]];
    BOOL isSuccess = [resultH writeToFile:pathH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isSuccess;
}

+ (BOOL)exportTemplateForSingleClassWithParameter_m:(NSDictionary *)parameter{
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    if (parameter.count<=0) {
        return NO;
    }
    
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"singleClass_m" ofType:@"txt"];
    
    NSString *resultH = [engine processTemplateInFileAtPath:templatePath withVariables:parameter];
    
    NSString *deskTopLocation=[ZHFileManager getDesktopInMac];
    NSString *pathH = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", [parameter allValues][0]]];
    BOOL isSuccess = [resultH writeToFile:pathH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isSuccess;
}

@end
