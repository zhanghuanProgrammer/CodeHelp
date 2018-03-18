//
//  ZHComparCode.m
//  CodeHelp
//
//  Created by mac on 2018/1/12.
//  Copyright © 2018年 com/qianfeng/mac. All rights reserved.
//

#import "ZHComparCode.h"
#import "ZHFileManager.h"

@implementation ZHComparCode

- (NSString *)description{
    return @"请将要对比的工程填写到文本框里面";
    
///Users/mac/Desktop/bonreeAgent4Tmp最新/bonreeAgent
///Users/mac/bonreeAgentJson/bonreeAgent

}

- (void)Begin:(NSString *)str{
    if (str.length<=0) {
        [self saveData:@"不要为空"];
        return;
    }
    NSArray *arr=[str componentsSeparatedByString:@"\n"];
    if (arr.count>=2) {
        NSString *path1=arr[0];
        NSString *path2=arr[1];
        
        NSArray *filePaths1= [ZHFileManager subPathFileArrInDirector:path1 hasPathExtension:@[@".h",@".m"]];
        NSArray *filePaths2= [ZHFileManager subPathFileArrInDirector:path2 hasPathExtension:@[@".h",@".m"]];
        //开始对比里面的文件差别
        NSMutableArray *fileNames1=[NSMutableArray array];
        NSMutableArray *fileNames2=[NSMutableArray array];
        NSMutableArray *filepathReal1=[NSMutableArray array];
        NSMutableArray *filepathReal2=[NSMutableArray array];
        for (NSString *filePath in filePaths1) {
            NSString *fileName =[ZHFileManager getFileNameFromFilePath:filePath];
            if (![fileNames1 containsObject:fileName]) {
                [fileNames1 addObject:fileName];
                [filepathReal1 addObject:filePath];
            }else{
                NSInteger index=[fileNames1 indexOfObject:fileName];
                NSLog(@"工程1%@文件重复存在",fileName);
                NSLog(@"%@-%@\n\n",filepathReal1[index],filePath);
            }
        }
        for (NSString *filePath in filePaths2) {
            NSString *fileName =[ZHFileManager getFileNameFromFilePath:filePath];
            if (![fileNames2 containsObject:fileName]) {
                [fileNames2 addObject:fileName];
                [filepathReal2 addObject:filePath];
            }else{
                NSInteger index=[fileNames2 indexOfObject:fileName];
                NSLog(@"工程2%@文件重复存在",fileName);
                NSLog(@"%@-%@\n\n",filepathReal2[index],filePath);
            }
        }
        for (NSString *fileName in fileNames1) {
            if ([fileNames2 containsObject:fileName]==NO) {
                NSInteger index=[fileNames1 indexOfObject:fileName];
                NSLog(@"工程2里面不存在文件%@",fileName);
                NSLog(@"%@\n\n",filepathReal1[index]);
            }
        }
        for (NSString *fileName in fileNames2) {
            if ([fileNames1 containsObject:fileName]==NO) {
                NSInteger index=[fileNames2 indexOfObject:fileName];
                NSLog(@"工程1里面不存在文件%@",fileName);
                NSLog(@"%@\n\n",filepathReal2[index]);
            }
        }
        //开始对比代码
        for (NSString *filePath in filePaths1) {
            BOOL find =NO;
            NSString *fileName =[ZHFileManager getFileNameFromFilePath:filePath];
            for (NSString *filePath2 in filePaths2) {
                NSString *fileName2 =[ZHFileManager getFileNameFromFilePath:filePath2];
                if ([fileName2 isEqualToString:fileName]) {
                    find = YES;
                    NSString *text1=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                    NSString *text2=[NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
                    NSArray *arr1=[text1 componentsSeparatedByString:@"\n"];
                    NSArray *arr2=[text2 componentsSeparatedByString:@"\n"];
                    if (arr1.count!=arr2.count) {
                        NSLog(@"%@-%@里面代码行数不同\n",fileName,fileName2);
                        break;
                    }else{
                        for (NSInteger i=0; i<arr1.count; i++) {
                            NSString *line1=arr1[i];
                            NSString *line2=arr2[i];
                            if ([line1 isEqualToString:line2]==NO) {
                                NSLog(@"%@-%@-第%zd行代码不同\n",fileName,fileName2,i);
                                NSLog(@"😄%@\n💣%@",line1,line2);
                                break;
                            }
                        }
                    }
                }
            }
            if (find==NO) {
                NSLog(@"工程2里面不存在文件%@\n",fileName);
            }
        }
        for (NSString *filePath in filePaths2) {
            BOOL find =NO;
            NSString *fileName =[ZHFileManager getFileNameFromFilePath:filePath];
            for (NSString *filePath2 in filePaths1) {
                NSString *fileName2 =[ZHFileManager getFileNameFromFilePath:filePath2];
                if ([fileName2 isEqualToString:fileName]) {
                    find = YES;
                    NSString *text1=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                    NSString *text2=[NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
                    NSArray *arr1=[text1 componentsSeparatedByString:@"\n"];
                    NSArray *arr2=[text2 componentsSeparatedByString:@"\n"];
                    if (arr1.count!=arr2.count) {
                        NSLog(@"%@-%@里面代码行数不同\n",fileName,fileName2);
                        break;
                    }else{
                        for (NSInteger i=0; i<arr1.count; i++) {
                            NSString *line1=arr1[i];
                            NSString *line2=arr2[i];
                            if (line1!=line2) {
                                NSLog(@"%@-%@-第几%zd行代码不同\n",fileName,fileName2,i);
                                break;
                            }
                        }
                    }
                }
            }
            if (find==NO) {
                NSLog(@"工程2里面不存在文件%@\n",fileName);
            }
        }
    }else{
        [self saveData:@"必须填写两个工程路径,并且注意换行"];
    }
}

@end
