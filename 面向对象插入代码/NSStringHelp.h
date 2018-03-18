#import <Foundation/Foundation.h>

@interface NSStringHelp : NSObject

/**
 *  添加替换条件,可以重复key值 即old值 这种替换只能一对一替换,不对把某一种全部都替换
 *
 */
- (void)addDataToReplaceDicMWithOld:(NSString *)oldStr new:(NSString *)newStr;

/**
 *  添加替换条件,可以重复key值 即old值 这种替换会把某一种全部都替换
 *
 */
- (void)addDataToReplaceDicM_All_WithOld:(NSString *)oldStr new:(NSString *)newStr;

/**
 *  重复某个代码片段
 *
 *  @param oringalCode              最初代码
 *  @param count                    重复次数
 *  @param componentsJoinedByString 如有重复,用来拼接的字符串
 *
 */
- (NSString *)getRepeatCodeWithOringalCode:(NSString *)oringalCode;

@end