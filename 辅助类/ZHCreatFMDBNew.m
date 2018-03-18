#import "ZHCreatFMDBNew.h"
#import "ZHWordWrap.h"
#import "ZHFileManager.h"
#import "ZHFunToRedition.h"
#import "NSStringHelp.h"
#import "ZHNSString.h"

@implementation ZHCreatFMDBNew

- (NSString *)description{
    NSString *filePath=[self creatFatherFile:@"代码助手" andData:@[@"类名",@"ModelName",@"integer",@"text",@"REAL",@"BLOB"]];
    
    [self openFile:filePath];
    
    return @"指导文件已经创建在桌面上: 代码助手.m  ,请勿修改指定内容";
}

- (void)creat_H_file:(NSDictionary *)dic withFunCode:(NSString *)code{
    NSMutableString *text=[NSMutableString string];
    
    code=[[ZHFunToRedition new]funToRedition:code];
    [self insertValueAndNewlines:@[code] ToStrM:text];
    [text setString:[[ZHWordWrap new]wordWrapText:text]];
    [self saveText:text toFileName:@[[dic[@"类名"] stringByAppendingString:@".h"]]];
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

//返回所有的方法,这样可以利用之前做的方法生成声明来自动生成声明代码填到.h文件里面
- (NSString *)creat_M_file:(NSDictionary *)dic{
    
    NSStringHelp *codeHelp=[NSStringHelp new];
    [codeHelp addDataToReplaceDicM_All_WithOld:@"<#ZHSessionList#>" new:dic[@"类名"]];
    [codeHelp addDataToReplaceDicM_All_WithOld:@"<#zHSessionList#>" new:[ZHNSString lowerFirstCharacter:dic[@"类名"]]];
    
    NSString *text;
    {
    text=@"#import \"<#ZHSessionList#>DataBase.h\"\n\
    \n\
    #define MyMainTable @\"<#ZHSessionList#>Table\"\n\
    #define MyDataBaseName @\"<#ZHSessionList#>DataBase.rdb\"\n\
    \n\
    static <#ZHSessionList#>DataBase *<#zHSessionList#>FMDB;\n\
    \n\
    @interface <#ZHSessionList#>DataBase ()\n\
    @property (nonatomic,copy)NSString *FilePath;//数据库保存在哪个文件夹\n\
    @property (nonatomic,copy)NSString *DataBasePath;//数据库路径\n\
    @property (strong,nonatomic)FMDatabase *curFMdatabase;//数据库权柄\n\
    @end\n\
    \n\
    @implementation <#ZHSessionList#>DataBase\n\
    \n\
    \n\
    #pragma mark----------文件相关操作\n\
    - (NSString *)FilePath{\n\
    ____if (_FilePath.length<=0) {\n\
    ________NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@\"Documents\"];\n\
    ________saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@\"SQlite\"];\n\
    _________FilePath=saveSslectImagePath;\n\
    ____}\n\
    ____return _FilePath;\n\
    }\n\
    - (NSString *)DataBasePath{\n\
    ____if (_DataBasePath.length<=0) {\n\
    ________NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@\"Documents\"];\n\
    ________saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@\"SQlite\"];\n\
    ________saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:MyDataBaseName];\n\
    _________DataBasePath=saveSslectImagePath;\n\
    ____}\n\
    ____return _DataBasePath;\n\
    }\n\
    //如果主目录不存在,就创建主目录\n\
    - (void)creatMainPath{\n\
    ____BOOL temp;\n\
    ____if(![[NSFileManager defaultManager] fileExistsAtPath:self.FilePath isDirectory:&temp])\n\
    ________[[NSFileManager defaultManager] createDirectoryAtPath:self.FilePath withIntermediateDirectories:YES attributes:nil error:nil];\n\
    }\n\
    \n\
    #pragma mark----------懒加载\n\
    + (instancetype)default<#ZHSessionList#>{\n\
    ____//添加线程锁\n\
    ____static dispatch_once_t onceToken;\n\
    ____dispatch_once(&onceToken, ^{\n\
    ________if(<#zHSessionList#>FMDB==nil){\n\
    ____________<#zHSessionList#>FMDB=[[<#ZHSessionList#>DataBase alloc]init];\n\
    ________}\n\
    ____});\n\
    ____return <#zHSessionList#>FMDB;\n\
    }\n\
    /**创建数据库和表格*/\n\
    - (FMDatabase *)curFMdatabase{\n\
    ____if(_curFMdatabase==nil){\n\
    ________if([[NSFileManager defaultManager] fileExistsAtPath:self.DataBasePath]==NO){//判断数据库是否存在\n\
    ____________[self creatMainPath];\n\
    ____________FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:self.DataBasePath];\n\
    ____________if ([fmdateBase open]) {\n\
    ________________NSString *codeMainTable=@\"create table if not exists ZHSessionListTable (id integer primary key autoincrement,myID text,placeTop integer,time integer,placeTopTime integer,ischild integer,iconUrl text,name text,message text,uid text)\";\n\
    ________________if(![fmdateBase executeUpdate:codeMainTable]){\n\
    ____________________NSLog(@\"创建表格失败\");\n\
    ________________}else{\n\
    ____________________NSLog(@\"创建表格成功\");\n\
    ________________}\n\
    ________________//创建成功后需要关闭该数据库\n\
    ________________[fmdateBase close];\n\
    ____________}else{\n\
    ________________NSLog(@\"创建数据库失败\");\n\
    ____________}\n\
    ________}\n\
    _________curFMdatabase=[self openDataBase];\n\
    ________if(_curFMdatabase==nil){\n\
    ____________NSLog(@\"%@\",@\"打开数据库失败\");\n\
    ________}\n\
    ____}\n\
    ____return _curFMdatabase;\n\
    }\n\
    \n\
    #pragma mark----------数据库相关基本操作\n\
    //1.根据数据库名,来打开一个数据库,如果打开成功,返回这个权柄(测试成功)\n\
    - (FMDatabase *)openDataBase{\n\
    ____\n\
    ____FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:self.DataBasePath];\n\
    ____if ([fmdateBase open]) {\n\
    ________return fmdateBase;\n\
    ____}\n\
    ____NSLog(@\"%@\",@\"打开数据库失败\");\n\
    ____return nil;//如果打开失败,返回空\n\
    }\n\
    //2.判断表中是否已经有这条记录\n\
    - (BOOL)HasExistInfo:(NSString *)ID{\n\
    ____if(self.curFMdatabase!=nil){//如果打开数据库成功\n\
    ________NSString *code=[NSString stringWithFormat:@\"select count(*) as 'count' from %@ where  myID = '%@'\", MyMainTable, ID];\n\
    ________FMResultSet *rs = [self.curFMdatabase executeQuery:code];\n\
    ________while ([rs next]){\n\
    ____________NSInteger count = [rs intForColumn:@\"count\"];\n\
    ____________if (0 == count){\n\
    ________________[rs close];\n\
    ________________return NO;\n\
    ____________}else{\n\
    ________________[rs close];\n\
    ________________return YES;\n\
    ________________break;\n\
    ____________}\n\
    ________}\n\
    ____}\n\
    ____return NO;\n\
    }\n\
    //3.根据表格进行 插入 修改 删除 3种命令 (测试成功)\n\
    - (BOOL)operateDataToDataBase:(NSString *)DataBaseName withCode:(NSString *)code {\n\
    ____if(self.curFMdatabase!=nil){//如果打开数据库成功\n\
    ________if(![self.curFMdatabase executeUpdate:code]){\n\
    ____________return NO;\n\
    ________}else{\n\
    ____________return YES;\n\
    ________}\n\
    ____}\n\
    ____return NO;\n\
    }\n\
    #pragma mark----------数据库查询代码\n\
    - (NSMutableArray *)selectAllData{\n\
    ____NSString *code=[NSString stringWithFormat:@\"select * from %@ order by placeTopTime asc\",MyMainTable];\n\
    ____if(self.curFMdatabase !=nil){//如果打开数据库成功\n\
    ________FMResultSet *set = [self.curFMdatabase executeQuery:code];\n\
    ________NSMutableArray *arrM=[NSMutableArray array];\n\
    ________while ([set next]) {\n\
    ____________ConversationCellModel *model=[ConversationCellModel new];\n\
    ____________model.myID=[set stringForColumn:@\"myID\"];\n\
    ____________model.placeTop=[set intForColumn:@\"placeTop\"];\n\
    ____________model.time=[set longLongIntForColumn:@\"time\"];\n\
    ____________model.placeTopTime=[set longLongIntForColumn:@\"placeTopTime\"];\n\
    ____________model.isChild=[set intForColumn:@\"ischild\"];\n\
    ____________model.iconUrl=[set stringForColumn:@\"iconUrl\"];\n\
    ____________model.name=[set stringForColumn:@\"name\"];\n\
    ____________model.message=[set stringForColumn:@\"message\"];\n\
    ____________model.uid=[set stringForColumn:@\"uid\"];\n\
    ____________\n\
    ____________if (model.myID.length>0) {\n\
    ________________[arrM addObject:model];\n\
    ____________}\n\
    ________}\n\
    ________[set close];\n\
    ________\n\
    ________if (arrM.count>0) {\n\
    ____________return arrM;\n\
    ________}else{\n\
    ____________return nil;\n\
    ________}\n\
    ____}\n\
    ____return nil;\n\
    }\n\
    #pragma mark----------数据库插入代码\n\
    - (BOOL)insertDataTextWithIschild:(NSInteger)ischild WithIconUrl:(NSString *)iconUrl WithName:(NSString *)name WithMessage:(NSString *)message WithUid:(NSString *)uid{\n\
    ____NSString *myID=[ZHNSString getRandomStringWithLenth:20];\n\
    ____while([self HasExistInfo:myID]==YES){\n\
    ________myID=[ZHNSString getRandomStringWithLenth:20];\n\
    ____}\n\
    ____long long time=[DateTools getCurInterval];\n\
    ____NSString *code=[NSString stringWithFormat:@\"insert into %@ (myID,placeTop,time,placeTopTime,ischild,iconUrl,name,message,uid) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')\",MyMainTable,myID,@(0),@(time),@(0),@(ischild),iconUrl,name,message,uid];\n\
    ____if([self operateDataToDataBase:MyDataBaseName withCode:code]){\n\
    ________return YES;\n\
    ____}else{\n\
    ________return NO;\n\
    ____}\n\
    ____return YES;\n\
    }\n\
    #pragma mark----------数据库更新代码\n\
    - (void)setPlaceTop:(BOOL)placeTop WithmyID:(NSString *)myID{\n\
    ____long long placeTopTime=[DateTools getCurInterval];\n\
    ____NSString *code=[NSString stringWithFormat:@\"update %@ set placeTop = '%@', placeTopTime='%@' where myID = '%@'\",MyMainTable ,@(placeTop),@(placeTopTime),myID];\n\
    ____[self upDataWithCode:code WithmyID:myID];\n\
    }\n\
    \n\
    - (void)upDataWithCode:(NSString *)code WithmyID:(NSString *)myID{\n\
    ____if([self HasExistInfo:myID]==YES){\n\
    ________if([self operateDataToDataBase:MyDataBaseName withCode:code]){\n\
    ____________NSLog(@\"修改成功\");\n\
    ________}\n\
    ________else NSLog(@\"修改失败\");\n\
    ____}else NSLog(@\"你要修改的数据不存在\");\n\
    }\n\
    - (void)upDataWithIschild:(NSInteger)ischild WithIconUrl:(NSString *)iconUrl WithName:(NSString *)name WithMessage:(NSString *)message WithUid:(NSString *)uid WithmyID:(NSString *)myID{\n\
    ____NSString *code=[NSString stringWithFormat:@\"update %@ set ischild = '%@' , iconUrl = '%@' , name = '%@' , uid = '%@' where myID = '%@'\",MyMainTable ,@(ischild),name,message,uid,myID];\n\
    ____[self upDataWithCode:code WithmyID:myID];\n\
    }\n\
    #pragma mark----------数据库删除代码\n\
    - (void)deleteDataWithmyID:(NSString *)myID{\n\
    ____if([self HasExistInfo:myID]==YES){\n\
    ________NSString *code=[NSString stringWithFormat:@\"delete from %@ where myID = '%@'\",MyMainTable,myID];\n\
    ________if([self operateDataToDataBase:MyDataBaseName withCode:code]){\n\
    ____________NSLog(@\"删除成功\");\n\
    ________}else{\n\
    ____________NSLog(@\"删除失败\");\n\
    ________}\n\
    ____}else{\n\
    ________NSLog(@\"你要删除的数据不存在\");\n\
    ____}\n\
    }\n\
    @end";
    
    text=[text stringByReplacingOccurrencesOfString:@"____" withString:@""];
        
    }
    
    text=[codeHelp getRepeatCodeWithOringalCode:text];
    text=[[ZHWordWrap new]wordWrapText:text];
    [self saveText:text toFileName:@[[dic[@"类名"] stringByAppendingString:@".m"]]];
    return text;
    
}

@end