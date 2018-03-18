#import "NSStringHelp.h"
#import "ZHNSString.h"

@interface NSStringHelp ()
@property (nonatomic,strong)NSMutableDictionary *replaceDicM;
@property (nonatomic,strong)NSMutableDictionary *replaceDicM_All;
@property (nonatomic,strong)NSMutableDictionary *tempDicM;
@end


@implementation NSStringHelp


- (NSMutableDictionary *)replaceDicM{
    if (!_replaceDicM) {
        _replaceDicM=[NSMutableDictionary dictionary];
    }
    return _replaceDicM;
}
- (NSMutableDictionary *)replaceDicM_All{
    if (!_replaceDicM_All) {
        _replaceDicM_All=[NSMutableDictionary dictionary];
    }
    return _replaceDicM_All;
}
- (NSMutableDictionary *)tempDicM{
    if (!_tempDicM) {
        _tempDicM=[NSMutableDictionary dictionary];
    }
    return _tempDicM;
}

/**
 *  添加替换条件,可以重复key值 即old值
 *
 */
- (void)addDataToReplaceDicMWithOld:(NSString *)oldStr new:(NSString *)newStr{
    if (self.replaceDicM[oldStr]!=nil) {//说明已经存在这个old字符串
        
        NSString *randomStr=[ZHNSString getRandomStringWithLenth:10];
        while (self.tempDicM[randomStr]!=nil) {
            randomStr=[ZHNSString getRandomStringWithLenth:10];
        }
        self.tempDicM[randomStr]=oldStr;
        [self.replaceDicM setValue:newStr forKey:randomStr];
        
    }else{
        [self.replaceDicM setValue:newStr forKey:oldStr];
    }
}

/**
 *  添加替换条件,可以重复key值 即old值 这种替换会把某一种全部都替换
 *
 */
- (void)addDataToReplaceDicM_All_WithOld:(NSString *)oldStr new:(NSString *)newStr{
    [self.replaceDicM_All setValue:newStr forKey:oldStr];
}

/**
 *  重复某个代码片段
 *
 *  @param oringalCode              最初代码
 *  @param count                    重复次数
 *  @param componentsJoinedByString 如有重复,用来拼接的字符串
 *
 */
- (NSString *)getRepeatCodeWithOringalCode:(NSString *)oringalCode{
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    //显示一对多替换
    for (NSString *key in self.replaceDicM_All) {
        oringalCode=[oringalCode stringByReplacingOccurrencesOfString:key withString:self.replaceDicM_All[key]];
    }
    
    //必须是一一替换
    for (NSString *key in self.replaceDicM) {
        if (self.tempDicM[key]!=nil) {
            oringalCode=[self stringByReplacingOnlyReplaceOneWithOccurrencesOfString:self.tempDicM[key] withString:self.replaceDicM[key] targetString:oringalCode];
        }else{
            oringalCode=[self stringByReplacingOnlyReplaceOneWithOccurrencesOfString:key withString:self.replaceDicM[key] targetString:oringalCode];
        }
    }
    [arrM addObject:oringalCode];
    
    if(self.replaceDicM.count>0||self.replaceDicM_All.count>0){
        
        return oringalCode;
    }
    
    return [[@"<#" stringByAppendingString:oringalCode] stringByAppendingString:@"#>"];
}

/**
 *  替换字符串并且仅仅替换第一个(这个是为了符合这个示例)
 */
- (NSString *)stringByReplacingOnlyReplaceOneWithOccurrencesOfString:(NSString *)occurrencesOfString withString:(NSString *)replaceString targetString:(NSString *)targetString{
    NSRange range=[targetString rangeOfString:occurrencesOfString options:NSLiteralSearch];
    if (range.location!=NSNotFound) {
        targetString=[targetString stringByReplacingCharactersInRange:range withString:replaceString];
    }
    return targetString;
}
@end
