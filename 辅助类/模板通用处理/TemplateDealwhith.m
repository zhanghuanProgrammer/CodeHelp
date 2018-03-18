#import "TemplateDealwhith.h"
#import "ZHFileManager.h"
#import "NSDictionary+ZH.h"
#import "TemplateJsonParse.h"

@implementation TemplateDealwhith

- (NSString *)description{
    return @"请填写需要生产模板的文件夹";
}

- (void)Begin:(NSString *)str{
    [self searchResourseForPath:str];
}

/**开始寻找资源 首先里面必须有两个文件夹,而且名字必须为 templates 和 parameter*/
- (void)searchResourseForPath:(NSString *)path{
    NSArray *filepaths=[ZHFileManager subPathDirectorArrInDirector:path];
    
    NSString *templatesPath=@"";
    NSString *parameterPath=@"";
    
    for (NSString *filepath in filepaths) {
        if ([filepath hasSuffix:@"templates"]) {
            templatesPath=filepath;
        }
        if ([filepath hasSuffix:@"parameter"]) {
            parameterPath=filepath;
        }
    }
    
    if (!(templatesPath.length>0&&parameterPath.length>0)) {
        [self saveData:@"首先里面必须有两个文件夹,而且名字必须为 templates 和 parameter"];
        return;
    }
    
    NSString *curDataDirector=[ZHFileManager creatCurDataDirectorToMacDestop];
    
    //开始下一步处理
    //1.创建模板文件文件夹结构,因为我们生成出来的文件也需要按照模板文件夹结构存放
    [self creatTargetDirectorLikeTemplateDirectorArr:templatesPath oldPath:path curDataDirector:curDataDirector];
    
    //2.获取模板文件集合
    NSArray *templatesArr=[self getTemplates:templatesPath];
    if (templatesArr.count<=0) {
        [self saveData:@"模板集合里的模板文件个数为 0 "];
        return;
    }
    
    //3.读取参数json
    NSDictionary *parameterDic=[self getParameter:parameterPath];
    if (!parameterDic) {
        [self saveData:@"参数json文件不存在或者数据格式错误"];
        return;
    }
    
    //4.进行语法分析并生成代码
    TemplateJsonParse *templateJsonParse=[TemplateJsonParse new];
    templateJsonParse.parameterData=parameterDic;
    templateJsonParse.templates=templatesArr;
    templateJsonParse.path=path;
    templateJsonParse.curDataDirector=curDataDirector;
    NSString *relust=[templateJsonParse creatCode];
    [self saveData:relust];
}

/**创建模板文件文件夹结构,因为我们生成出来的文件也需要按照模板文件夹结构存放*/
- (void)creatTargetDirectorLikeTemplateDirectorArr:(NSString *)filePath oldPath:(NSString *)oldPath curDataDirector:(NSString *)curDataDirector{
    
    NSMutableArray *pathDirectorsArr=[NSMutableArray array];
    [ZHFileManager subPathDirectorsArrInDirector:filePath saveToPathDirectorsArr:pathDirectorsArr];
    
    for (NSInteger i=0; i<pathDirectorsArr.count; i++) {
        NSString *newPath=pathDirectorsArr[i];
        newPath=[newPath stringByReplacingOccurrencesOfString:oldPath withString:curDataDirector];
        [ZHFileManager creatTargetDirectorIfNotExsit:newPath];
    }
}

/**获取模板文件集合*/
- (NSArray *)getTemplates:(NSString *)filePath{
    NSArray *templatesArrM=[ZHFileManager subPathFileArrInDirector:filePath hasPathExtension:@[@".h",@".m",@".txt",@".java",@".xml"]];
    return templatesArrM;
}


/**读取参数json*/
- (NSDictionary *)getParameter:(NSString *)filePath{
    NSArray *filePaths=[ZHFileManager subPathFileArrInDirector:filePath fileNameContain:@[@"parameter"]];
    NSString *parameter=@"";
    for (NSString *filePath in filePaths) {
        if ([filePath hasSuffix:@"parameter.m"]) {
            parameter=filePath;
        }
    }
    
    if (parameter.length<=0) {
        return nil;
    }
    
    NSString *jsonString=[NSString stringWithContentsOfFile:parameter encoding:NSUTF8StringEncoding error:nil];
    
    return [NSDictionary dictionaryWithJsonString:jsonString];
}

@end
