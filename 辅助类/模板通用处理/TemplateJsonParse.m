#import "TemplateJsonParse.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "ZHFileManager.h"
#import "ZHJson.h"

@interface TemplateJsonParse ()

/**获取所有需要生成的文件和规则*/
@property (nonatomic,strong)NSDictionary *rulesData;
@property (nonatomic,strong)MGTemplateEngine *engine;

@end

@implementation TemplateJsonParse

- (MGTemplateEngine *)engine{
    if (!_engine) {
        _engine = [MGTemplateEngine templateEngine];
        [_engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:_engine]];
    }
    return _engine;
}

- (NSString *)getFilePathFromTemplateWithFileName:(NSString *)fileName{
    for (NSString *fileNameStr in self.templates) {
        if ([fileNameStr hasSuffix:fileName]) {
            return fileNameStr;
        }
    }
    return @"";
}

- (void)parse{
    if(self.parameterData&&self.parameterData[@"rules"]){
        self.rulesData=self.parameterData[@"rules"];
    }
}

/**如果要生成的文件是一串数组,那么根据里面的元素获取更改过后的参数数据*/
- (NSDictionary *)getChangeDicWithRule:(NSDictionary *)rule{
    ZHJson *zhjson=[ZHJson new];
    NSMutableDictionary *copyDic=[zhjson copyMutableDicFromDictionary:self.parameterData];
    [zhjson changeMutableDicFromDictionary:copyDic forKey:[rule allKeys][0] value:[rule allValues][0]];
    return copyDic;
}

- (id)getValueWithKey:(NSString *)key{
    ZHJson *zhjson=[ZHJson new];
    NSMutableDictionary *copyDic=[zhjson copyMutableDicFromDictionary:self.parameterData];
    return [zhjson getValueFromDictionary:copyDic forKey:key];
}

- (NSString *)creatCode{
    [self parse];
    
    if(!self.rulesData) return @"不存在规则";
    
    //1.获取需要生成代码的文件
    for (NSString *key in self.rulesData) {
        NSDictionary *creatCodeFile=self.rulesData[key];
        NSArray *fileNames=creatCodeFile[@"指定模板文件的名字"];
        if(!fileNames)return [NSString stringWithFormat:@"%@ 不存在 \"指定模板文件的名字\" 这个字段",key];
        
        for (NSString *fileName in fileNames) {
            NSString *filePath=[self getFilePathFromTemplateWithFileName:fileName];
            NSArray *combinationArr=[self combinationWithA:[self getValueWithKey:key] B:fileName];
            for (NSString *combination in combinationArr) {
                NSString *unCombination=[self unCombinationWithString:combination whithArr:fileNames];
                NSDictionary *variables=[self getChangeDicWithRule:@{key:unCombination}];
                [self creatTemplateCodeTemplateInFileAtPath:filePath withVariables:variables withRename:combination];
            }
        }
    }
    return @"生成成功! 生成的文件在桌面上";
}

- (NSArray *)combinationWithA:(id)A B:(id)B{
    NSMutableArray *a_arr=nil;
    NSMutableArray *b_arr=nil;
    if([A isKindOfClass:[NSArray class]])a_arr=A;
    else if([A isKindOfClass:[NSString class]]){
        a_arr=[NSMutableArray array];
        [a_arr addObject:A];
    }
    if([B isKindOfClass:[NSArray class]])b_arr=B;
    else if([B isKindOfClass:[NSString class]]){
        b_arr=[NSMutableArray array];
        [b_arr addObject:B];
    }
    if(a_arr==nil||b_arr==nil)return nil;
    
    NSMutableArray *combinationArrM=[NSMutableArray array];
    for (NSString *aStr in a_arr) {
        for (NSString *bStr in b_arr) {
            NSString *combinationStr=[aStr stringByAppendingString:bStr];
            if(![combinationArrM containsObject:combinationStr]){
                [combinationArrM addObject:combinationStr];
            }
        }
    }
    return combinationArrM;
}

- (NSString *)unCombinationWithString:(NSString *)string whithArr:(NSArray *)arr{
    for (NSString *str in arr) {
        if ([string hasSuffix:str]) {
            return [string substringToIndex:string.length-str.length];
        }
    }
    return string;
}

- (void)creatTemplateCodeTemplateInFileAtPath:(NSString *)path withVariables:(NSDictionary *)variables withRename:(NSString *)rename{
    
    NSString *result = [self.engine processTemplateInFileAtPath:path withVariables:variables];
    
    NSString *newPath=path;
    newPath=[newPath stringByReplacingOccurrencesOfString:self.path withString:self.curDataDirector];
    
    newPath=[ZHFileManager getFilePathByRemoveFileName:newPath];
    newPath=[newPath stringByAppendingPathComponent:rename];
    
    [result writeToFile:newPath atomically:yearMask encoding:NSUTF8StringEncoding error:nil];
}

@end
