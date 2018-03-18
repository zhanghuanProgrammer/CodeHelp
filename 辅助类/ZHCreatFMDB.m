#import "ZHCreatFMDB.h"
#import "ZHWordWrap.h"
#import "ZHFunToRedition.h"
#import "ZHNSString.h"
#import "ZHFileManager.h"

@implementation ZHCreatFMDB
- (NSString *)description{
    NSString *filePath=[self creatFatherFile:@"代码助手" andData:@[@"类名",@"ModelName",@"integer",@"text",@"REAL",@"BLOB"]];
    
    [self openFile:filePath];
    
    return @"指导文件已经创建在桌面上: 代码助手.m  ,请勿修改指定内容";
}

- (void)Begin:(NSString *)str{
    NSDictionary *dic=[self getDicFromFileName:@"代码助手"];
    
    //开始,注意,这是给自己用的,所以不需要很大的容错性
    
//    1. .h文件
    NSString *funCode=[self creat_M_file:dic];
    [self creat_H_file:dic withFunCode:funCode];
    [self backUp:@"代码助手"];
    [self saveData:@"生成成功"];
}

- (void)creat_H_file:(NSDictionary *)dic withFunCode:(NSString *)code{
    NSMutableString *text=[NSMutableString string];
    
    code=[[ZHFunToRedition new]funToRedition:code];
    [self insertValueAndNewlines:@[code] ToStrM:text];
    [text setString:[[ZHWordWrap new]wordWrapText:text]];
    [self saveText:text toFileName:@[[dic[@"类名"] stringByAppendingString:@".h"]]];
}


//返回所有的方法,这样可以利用之前做的方法生成声明来自动生成声明代码填到.h文件里面
- (NSString *)creat_M_file:(NSDictionary *)dic{
    NSMutableString *text=[NSMutableString string];
    NSMutableString *funCode=[NSMutableString string];
    
    if ([self getArrFromText:dic[@"BLOB"]]) {
        [text appendString:@"#error 注意\n//注意:我这里被坑了好久,%@来格式化二进制会被格式化成字符串(总之,要想存储二进制,不能使用下面的这句语句)\n\
         \n\
         //错误示范\n\
         //        NSString *code=[NSString stringWithFormat:@\"insert into %@ (DataType,Identity,JSONBLOBData) values ('%@','%@','%@')\",TableNameBLOB,@\"NSDictionary\",identity,myData];"];
    }
    {
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@DataBase.h\"\n\
                                    \n\
                                    #define MyMainTable @\"%@Table\"\n\
                                    #define MyDataBaseName @\"%@DataBase.rdb\"\n\
                                    \n\
                                    static %@DataBase *%@FMDB;\n\
                                    \n\
                                    @interface %@DataBase ()\n\
                                    @property (nonatomic,copy)NSString *FilePath;//数据库保存在哪个文件夹\n\
                                    @property (nonatomic,copy)NSString *DataBasePath;//数据库路径\n\
                                    @property (strong,nonatomic)FMDatabase *curFMdatabase;//数据库权柄\n\
                                    @end\n\
                                    \n\
                                    @implementation %@DataBase\n\
                                    \n\n#pragma mark----------文件相关操作\n\
                                    - (NSString *)FilePath{\n\
                                    if (_FilePath.length<=0) {\n\
                                    NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@\"Documents\"];\n\
                                    saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@\"SQlite\"];\n\
                                    _FilePath=saveSslectImagePath;\n\
                                    }\n\
                                    return _FilePath;\n\
                                    }\n\
                                    - (NSString *)DataBasePath{\n\
                                    if (_DataBasePath.length<=0) {\n\
                                    NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@\"Documents\"];\n\
                                    saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@\"SQlite\"];\n\
                                    saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:MyDataBaseName];\n\
                                    _DataBasePath=saveSslectImagePath;\n\
                                    }\n\
                                    return _DataBasePath;\n\
                                    }\n//如果主目录不存在,就创建主目录\n\
                                    - (void)creatMainPath{\n\
                                    BOOL temp;\n\
                                    if(![[NSFileManager defaultManager] fileExistsAtPath:self.FilePath isDirectory:&temp])\n\
                                    [[NSFileManager defaultManager] createDirectoryAtPath:self.FilePath withIntermediateDirectories:YES attributes:nil error:nil];\n\
                                    }\n\n",dic[@"类名"],dic[@"类名"],dic[@"类名"],dic[@"类名"],[ZHNSString lowerFirstCharacter:dic[@"类名"]],dic[@"类名"],dic[@"类名"]]] ToStrM:text];
    
    }
    
    {
    NSString *lowFirstClassName=[ZHNSString lowerFirstCharacter:dic[@"类名"]];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#pragma mark----------懒加载\n\
                                    + (instancetype)default%@{\n\
                                    //添加线程锁\n\
                                    static dispatch_once_t onceToken;\n\
                                    dispatch_once(&onceToken, ^{\n\
                                    if(%@FMDB==nil){\n\
                                    %@FMDB=[[%@DataBase alloc]init];\n\
                                    }\n\
                                    });\n\
                                    return %@FMDB;\n\
                                    }",dic[@"类名"],lowFirstClassName,lowFirstClassName,lowFirstClassName,dic[@"类名"]]] ToStrM:funCode];
    }
    
    NSMutableString *codeMainTable=[NSMutableString stringWithFormat:@"create table if not exists %@Table (id integer primary key autoincrement,myID text",dic[@"类名"]];
    NSMutableString *tempStrM=[NSMutableString string];
    
    for (NSString *str in [self getArrFromText:dic[@"integer"]]) {
        [codeMainTable appendFormat:@",%@ integer",str];
    }
    for (NSString *str in [self getArrFromText:dic[@"text"]]) {
        [codeMainTable appendFormat:@",%@ text",str];
    }
    for (NSString *str in [self getArrFromText:dic[@"REAL"]]) {
        [codeMainTable appendFormat:@",%@ REAL",str];
    }
    for (NSString *str in [self getArrFromText:dic[@"BLOB"]]) {
        [codeMainTable appendFormat:@",%@ BLOB",str];
    }
    {
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"/**创建数据库和表格*/\n\
                                    - (FMDatabase *)curFMdatabase{\n\
                                    if(_curFMdatabase==nil){\n\
                                    if([[NSFileManager defaultManager] fileExistsAtPath:self.DataBasePath]==NO){//判断数据库是否存在\n\
                                    [self creatMainPath];\n\
                                    FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:self.DataBasePath];\n\
                                    if ([fmdateBase open]) {\n\
                                    NSString *codeMainTable=@\"%@\";\n\
                                    if(![fmdateBase executeUpdate:codeMainTable]){\n\
                                    NSLog(@\"创建表格失败\");\n\
                                    }else{\n\
                                    NSLog(@\"创建表格成功\");\n\
                                    }\n\
                                    //创建成功后需要关闭该数据库\n\
                                    [fmdateBase close];\n\
                                    }else{\n\
                                    NSLog(@\"创建数据库失败\");\n\
                                    }\n\
                                    }\n\
                                    _curFMdatabase=[self openDataBase];\n\
                                    if(_curFMdatabase==nil){\n\
                                    NSLog(@\"%%@\",@\"打开数据库失败\");\n\
                                    }\n\
                                    }\n\
                                    return _curFMdatabase;\n\
                                    }\n\
                                    \n\
                                    #pragma mark----------数据库相关基本操作\n\
                                    //1.根据数据库名,来打开一个数据库,如果打开成功,返回这个权柄(测试成功)\n\
                                    - (FMDatabase *)openDataBase{\n\
                                    \n\
                                    FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:self.DataBasePath];\n\
                                    if ([fmdateBase open]) {\n\
                                    return fmdateBase;\n\
                                    }\n\
                                    NSLog(@\"%%@\",@\"打开数据库失败\");\n\
                                    return nil;//如果打开失败,返回空\n\
                                    }\n//2.判断表中是否已经有这条记录\n\
                                    - (BOOL)HasExistInfo:(NSString *)ID{\n\
                                    if(self.curFMdatabase!=nil){//如果打开数据库成功\n\
                                    NSString *code=[NSString stringWithFormat:@\"select count(*) as 'count' from %%@ where  myID = '%%@'\", MyMainTable, ID];\n\
                                    FMResultSet *rs = [self.curFMdatabase executeQuery:code];\n\
                                    while ([rs next]){\n\
                                    NSInteger count = [rs intForColumn:@\"count\"];\n\
                                    if (0 == count){\n\
                                    [rs close];\n\
                                    return NO;\n\
                                    }else{\n\
                                    [rs close];\n\
                                    return YES;\n\
                                    break;\n\
                                    }\n\
                                    }\n\
                                    }\n\
                                    return NO;\n\
                                    }\n//3.根据表格进行 插入 修改 删除 3种命令 (测试成功)\n\
                                    - (BOOL)operateDataToDataBase:(NSString *)DataBaseName withCode:(NSString *)code {\n\
                                    if(self.curFMdatabase!=nil){//如果打开数据库成功\n\
                                    if(![self.curFMdatabase executeUpdate:code]){\n\
                                    return NO;\n\
                                    }else{\n\
                                    return YES;\n\
                                    }\n\
                                    }\n\
                                    return NO;\n\
                                    }",codeMainTable]] ToStrM:funCode];
    }
    
    //数据库查询代码
    {
    [self insertValueAndNewlines:@[@"#pragma mark----------数据库查询代码"] ToStrM:funCode];
    NSMutableString *codeStrM=[NSMutableString string];
    for (NSString *str in [self getArrFromText:dic[@"integer"]]) {
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"model.%@=[set intForColumn:@\"%@\"];",str,str]] ToStrM:codeStrM];
    }
    for (NSString *str in [self getArrFromText:dic[@"text"]]) {
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"model.%@=[set stringForColumn:@\"%@\"];",str,str]] ToStrM:codeStrM];
    }
    for (NSString *str in [self getArrFromText:dic[@"REAL"]]) {
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"model.%@=[set doubleForColumn:@\"%@\"];",str,str]] ToStrM:codeStrM];
    }
    for (NSString *str in [self getArrFromText:dic[@"BLOB"]]) {
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"model.%@=[set dataForColumn:@\"%@\"];",str,str]] ToStrM:codeStrM];
    }
    
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (NSMutableArray *)selectAllData{\n\
                                    NSString *code=[NSString stringWithFormat:@\"select * from %%@ order by time asc\",MyMainTable];\n\
                                    if(self.curFMdatabase !=nil){//如果打开数据库成功\n\
                                    FMResultSet *set = [self.curFMdatabase executeQuery:code];\n\
                                    NSMutableArray *arrM=[NSMutableArray array];\n\
                                    while ([set next]) {\n\
                                    %@Model *model=[%@Model new];\n\
                                    %@\n\
                                    if (model.myID.length>0) {\n\
                                    [arrM addObject:model];\n\
                                    }\n\
                                    }\n\
                                    [set close];\n\
                                    \n\
                                    if (arrM.count>0) {\n\
                                    return arrM;\n\
                                    }else{\n\
                                    return nil;\n\
                                    }\n\
                                    }\n\
                                    return nil;\n\
                                    }",dic[@"ModelName"],dic[@"ModelName"],codeStrM]] ToStrM:funCode];
    }
    
    //数据库插入代码
    {
        [codeMainTable setString:@"NSString *code=[NSString stringWithFormat:@\"insert into %@ (myID"];
        NSInteger count=0;
        for (NSString *str in [self getArrFromText:dic[@"integer"]]) {
            [codeMainTable appendFormat:@",%@",str];
            count++;
        }
        for (NSString *str in [self getArrFromText:dic[@"text"]]) {
            [codeMainTable appendFormat:@",%@",str];
            count++;
        }
        for (NSString *str in [self getArrFromText:dic[@"REAL"]]) {
            [codeMainTable appendFormat:@",%@",str];
            count++;
        }
        for (NSString *str in [self getArrFromText:dic[@"BLOB"]]) {
            [codeMainTable appendFormat:@",%@",str];
            count++;
        }
        [codeMainTable appendString:@") values ("];
        for (NSInteger i=0; i<count; i++) {
            if (i==0)[codeMainTable appendString:@"'%@'"];
            else [codeMainTable appendString:@",'%@'"];
        }
        [codeMainTable appendString:@"\""];
        for (NSString *str in [self getArrFromText:dic[@"integer"]]) {
            [codeMainTable appendFormat:@",@(%@)",str];
        }
        for (NSString *str in [self getArrFromText:dic[@"text"]]) {
            [codeMainTable appendFormat:@",%@",str];
        }
        for (NSString *str in [self getArrFromText:dic[@"REAL"]]) {
            [codeMainTable appendFormat:@",@(%@)",str];
        }
        for (NSString *str in [self getArrFromText:dic[@"BLOB"]]) {
            [codeMainTable appendFormat:@",%@",str];
        }
        
        [codeMainTable appendString:@"),MyMainTable,myID"];
        
        for (NSString *str in [self getArrFromText:dic[@"integer"]]) {
            [tempStrM appendFormat:@"With%@:(NSInteger)%@ ",[ZHNSString upFirstCharacter:str],str];
        }
        for (NSString *str in [self getArrFromText:dic[@"text"]]) {
            [tempStrM appendFormat:@"With%@:(NSString *)%@ ",[ZHNSString upFirstCharacter:str],str];
        }
        for (NSString *str in [self getArrFromText:dic[@"REAL"]]) {
            [tempStrM appendFormat:@"With%@:(CGFloat)%@ ",[ZHNSString upFirstCharacter:str],str];
        }
        for (NSString *str in [self getArrFromText:dic[@"BLOB"]]) {
            [tempStrM appendFormat:@"With%@:(NSData *)%@ ",[ZHNSString upFirstCharacter:str],str];
        }
        [self insertValueAndNewlines:@[@"#pragma mark----------数据库插入代码"] ToStrM:funCode];
                        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (BOOL)insertDataText%@{\n\
                                                        NSString *myID=[ZHNSString getRandomStringWithLenth:20];\n\
                                                        while([self HasExistInfo:myID]==YES){\n\
                                                        myID=[ZHNSString getRandomStringWithLenth:20];\n\
                                                        }\n\
                                                        #error 注意\n\
                                                        %@\n\
                                                        if([self operateDataToDataBase:MyDataBaseName withCode:code]){\n\
                                                        return YES;\n\
                                                        }else{\n\
                                                        return NO;\n\
                                                        }\n\
                                                        return YES;\n\
                                                        }",tempStrM,codeMainTable]] ToStrM:funCode];
    }
    //数据库更新代码
    {
    [self insertValueAndNewlines:@[@"#pragma mark----------数据库更新代码"] ToStrM:funCode];
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)upData%@WithmyID:(NSString *)myID{\n\
                                        if([self HasExistInfo:myID]==YES){\n\
                                        #error 注意\n\
                                        NSString *code=[NSString stringWithFormat:@\"update %%@ set state = '%%@' where myID = '%%@'\",MyMainTable ,@\"unDone\",myID];\n\
                                        \n\
                                        if([self operateDataToDataBase:MyDataBaseName withCode:code]){\n\
                                        NSLog(@\"修改成功\");\n\
                                        }else{\n\
                                        NSLog(@\"修改失败\");\n\
                                        }\n\
                                        }else{\n\
                                        NSLog(@\"你要修改的数据不存在\");\n\
                                        }\n\
                                        }",tempStrM]] ToStrM:funCode];
    }
    //数据库删除代码
    {
    [self insertValueAndNewlines:@[@"#pragma mark----------数据库删除代码"] ToStrM:funCode];
    [self insertValueAndNewlines:@[@"- (void)deleteDataWithmyID:(NSString *)myID{\n\
                                   if([self HasExistInfo:myID]==YES){\n\
                                   NSString *code=[NSString stringWithFormat:@\"delete from %@ where myID = '%@'\",MyMainTable,myID];\n\
                                   if([self operateDataToDataBase:MyDataBaseName withCode:code]){\n\
                                   NSLog(@\"删除成功\");\n\
                                   }else{\n\
                                   NSLog(@\"删除失败\");\n\
                                   }\n\
                                   }else{\n\
                                   NSLog(@\"你要删除的数据不存在\");\n\
                                   }\n\
                                   }"] ToStrM:funCode];
    }
    
    [self insertValueAndNewlines:@[funCode,@"@end"] ToStrM:text];
    [text setString:[[ZHWordWrap new]wordWrapText:text]];
    [self saveText:text toFileName:@[[dic[@"类名"] stringByAppendingString:@".m"]]];
    return funCode;
}
@end