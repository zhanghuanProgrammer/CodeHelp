#import "AppDelegate.h"
#import "FMDatabase.h"
#import "SIngleCategroy.h"
#import "ZHFileManager.h"


#define FilePath [NSHomeDirectory() stringByAppendingString:@"/Desktop/CodeHelp/代码助手.plist"]
#define DataBasePath [NSHomeDirectory() stringByAppendingString:@"/Desktop/CodeHelp/myDataBase.rdb"]

#define MyMainTable @"MainTable"
#define MyDataBaseName @"myDataBase.rdb"
@interface AppDelegate ()
- (IBAction)classAction:(id)sender;


@property (weak)                IBOutlet NSTextField        *InputText;
@property (unsafe_unretained)   IBOutlet NSTextView         *outPutText;
@property (weak) IBOutlet       NSWindow                    *window;
@property (nonatomic,retain)    NSMutableDictionary         *dataDic;
@property (nonatomic,retain)    NSMutableArray              *dataArr;
@property (nonatomic,copy)      NSString                    *oldStr;
@property (nonatomic,retain)    NSMutableArray              *searchArr;
@property (nonatomic,retain)    NSTimer                     *myTimer;
@property (nonatomic,copy)      NSString                    *storyBoardChangeDate;
@property (nonatomic,assign)    BOOL                        delete;
@property (nonatomic,assign)    BOOL                        myDescription;


@property (nonatomic,assign)BOOL needSearchDataFormDataBase;

@property (strong,nonatomic)FMDatabase *curFMdatabase;
- (IBAction)OK:(id)sender;
- (IBAction)AddValue:(id)sender;
- (IBAction)ChangeData:(id)sender;
@property (weak) IBOutlet NSTextField *KeyValue;
- (IBAction)deleteValue:(id)sender;
@property (weak) IBOutlet NSButton *className;
- (IBAction)searchSwitchAction:(id)sender;
@property (weak) IBOutlet NSButton *searChSwitch;

@end

@implementation AppDelegate

- (BOOL)fuzzy{
    //判断输入中书否含有@
    if([self.InputText.stringValue rangeOfString:@"@"].location!=NSNotFound){
        NSString *intValue=[self.oldStr substringFromIndex:[self.oldStr rangeOfString:@"@"].location+1];
        if([self isIntValue:intValue]){
            NSInteger index=[intValue intValue];
            if(self.searchArr.count>=index&&index!=0){
                self.InputText.stringValue=[self.searchArr[index-1] substringFromIndex:[self.searchArr[index-1] rangeOfString:@":"].location+2];
                self.oldStr=self.InputText.stringValue;
            }else return NO;
        }else return NO;
    }
    return YES;
}
- (IBAction)OK:(id)sender {
    self.outPutText.textColor=[NSColor blackColor];
    [self fuzzy];
    if([self.InputText.stringValue hasPrefix:@"show@D"]){
        [self showAllDataBaseData];
        return;
    }
    if([self.InputText.stringValue hasPrefix:@"show@F"]){
        [self showAllClassFunction];
        return;
    }
    if(self.outPutText.string.length==0){
        self.outPutText.string=@"你的输出框不能为空  \n\t\t或者 \n请确定你找到了确定需要操作的关键字描述";
        return;
    }
    if([self fuzzy]==NO||self.dataDic[self.InputText.stringValue]==nil){
        self.outPutText.string=@"请确定你找到了确定需要操作的关键字描述";
        return;
    }
    //如果对应的value值是查询,则在数据库中查询
    //如果对应的是操作,则生成类,并且执行方法得到数据,将数据显示出来
    
    NSString *myValue=self.dataDic[self.InputText.stringValue];
    if(myValue.length==0){
        self.outPutText.string=@"不明操作";
    }else if([myValue isEqualToString:@"查询"]){
        [self selectDataWithTitle:self.InputText.stringValue];
    }else{
        Class class = NSClassFromString(myValue);
        id myClass=[[class alloc] init];
        if([self.outPutText.string hasPrefix:@"温馨提示:"]||self.myDescription==YES){
            if([myClass respondsToSelector:@selector(Begin:)]){
                [myClass performSelector:@selector(Begin:) withObject:self.outPutText.string];
                NSString *outCome=[SIngleCategroy getValueWithIdentity:@"value"];
                if (outCome.length>0&&outCome!=nil) {
                    self.outPutText.string=outCome;
                }else{
                    self.outPutText.string=@"操作完成!";
                }
            }
            else self.outPutText.string=@"你的类里面没有声明和实现- (void)Begin:(NSString *)str;";
        }else{
            self.outPutText.string=[NSString stringWithFormat:@"温馨提示:%@" ,myClass];
            self.myDescription=YES;
        }
    }
    self.delete=NO;
}

- (IBAction)AddValue:(id)sender{
    //注意,添加数据时:1不能重复,2,不仅要添加到字典中去,而且还要添加到数据库中,并且dataArr也许要做相应修改,3,需要两个字段都不能为空
    
    if(self.KeyValue.stringValue.length==0||self.outPutText.string.length==0){
        self.outPutText.string=@"关键字和内容都不能为空";
        return;
    }
    if(self.dataDic[self.KeyValue.stringValue]!=nil){
        self.outPutText.string=@"这条数据的关键字已经存在,请另外再换一条数据";
        return;
    }
    if(self.className.state==1){
        NSString *saveValue=[self.outPutText.string copy];
        NSString *myKeyValue=[self.KeyValue.stringValue copy];
        [self.dataDic setValue:saveValue forKey:myKeyValue];
        [self reloadData];
        self.delete=NO;
        self.outPutText.string=@"添加类成功,请手动导入类文件";
        [self.dataDic writeToFile:FilePath atomically:YES];
        self.className.state=0;
        return;
    }
    [self.dataDic setValue:@"查询" forKey:self.KeyValue.stringValue];
    [self reloadData];
    [self insertDataWithTitle:self.KeyValue.stringValue withContext:self.outPutText.string];
    self.delete=NO;
    [self.dataDic writeToFile:FilePath atomically:YES];
}
- (IBAction)ChangeData:(id)sender {
    //注意:修改数据时,1,关键字必须在,2,只需要改变数据库中的数据 3,需要两个字段都不能为空
    if(self.KeyValue.stringValue.length==0||self.outPutText.string.length==0){
        self.outPutText.string=@"关键字和内容都不能为空";
        return;
    }
    if(self.dataDic[self.KeyValue.stringValue]==nil){
        self.outPutText.string=@"这条数据的关键字不存在,请检查";
        return;
    }
    [self updataDataWithTitle:self.KeyValue.stringValue withContext:self.outPutText.string];
    [self.dataDic writeToFile:FilePath atomically:YES];
    self.delete=NO;
}
- (IBAction)deleteValue:(id)sender {
    //注意 删除数据时,1,必须关键字存在于数据库中,2,删除时,不仅需要删除当前数据库中的这条数据,而且还需要删除字典中的数据,并且dataArr也许要做相应修改
    if(self.outPutText.string.length==0){
        self.outPutText.string=@"请确定你找到了确定需要操作的关键字描述";
        return;
    }
    if([self fuzzy]==NO||self.dataDic[self.InputText.stringValue]==nil){
        self.outPutText.string=@"请确定你找到了确定需要操作的关键字描述";
        return;
    }
    
    NSString *myValue=self.dataDic[self.InputText.stringValue];
    if(myValue.length==0){
        self.outPutText.string=@"不明操作";
    }else if([myValue isEqualToString:@"查询"]){
        if(self.delete==NO){
            self.outPutText.string=@"再次点击删除才真正删除";
            self.delete=YES;
            return;
        }
        if(self.InputText.stringValue.length==0){
            self.outPutText.string=@"关键字不能为空";
            return;
        }
        if(self.dataDic[self.InputText.stringValue]==nil){
            self.outPutText.string=@"这条数据的关键字不存在,请检查";
            return;
        }
        [self.dataDic removeObjectForKey:self.InputText.stringValue];
        [self reloadData];
        [self deleteDataWithTitle:self.InputText.stringValue];
        [self.dataDic writeToFile:FilePath atomically:YES];
        self.delete=NO;
    }else{
        if(self.delete==NO){
            self.outPutText.string=@"再次点击删除才真正删除";
            self.delete=YES;
            return;
        }
        [self.dataDic removeObjectForKey:self.InputText.stringValue];
        [self reloadData];
        self.outPutText.string=@"删除成功";
        self.delete=NO;
        [self.dataDic writeToFile:FilePath atomically:YES];
    }
}

- (void)showAllDataBaseData{
    NSMutableString *text=[NSMutableString string];
    int i=1;
    for (NSString *keyValue in self.dataDic) {
        if([self.dataDic[keyValue] isEqualToString:@"查询"]){
            [text appendFormat:@"%d: %@\n",i++,keyValue];
        }
    }
    self.outPutText.string=text;
}
- (void)showAllClassFunction{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"显示所有的类(自定义类名)\n"];
    int i=1;
    for (NSString *keyValue in self.dataDic) {
        if([self.dataDic[keyValue] isEqualToString:@"查询"]==NO){
            [text appendFormat:@"%d: %@(%@)\n",i++,keyValue,self.dataDic[keyValue]];
        }
    }
    self.outPutText.string=text;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self loadData];
}
- (void)loadData{
    
    _needSearchDataFormDataBase=YES;
    
    self.dataDic=[NSMutableDictionary dictionaryWithContentsOfFile:FilePath];
    if (_needSearchDataFormDataBase) {
        self.dataArr=[NSMutableArray arrayWithArray:[self.dataDic.allKeys copy]];
    }else{
        self.dataArr=[NSMutableArray array];
        for (NSString *key in self.dataDic) {
            if ([self.dataDic[key] isEqualToString:@"查询"]) {
                [self.dataArr addObject:key];
            }
        }
    }
    
    self.searchArr=[NSMutableArray array];
    
    self.InputText.font=[NSFont systemFontOfSize:20];
    self.outPutText.font=[NSFont systemFontOfSize:20];
    self.myTimer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updata) userInfo:nil repeats:YES];
    self.myTimer.fireDate=[NSDate distantPast];
    
    [self creatMainPath];
}
- (void)reloadData{
    [self.dataArr removeAllObjects];
    if (_needSearchDataFormDataBase) {
        self.dataArr=[NSMutableArray arrayWithArray:[self.dataDic.allKeys copy]];
    }else{
        if (self.dataArr==nil) {
            self.dataArr=[NSMutableArray array];
        }
        
        for (NSString *key in self.dataDic) {
            
            if (![self.dataDic[key] isEqualToString:@"查询"]) {
                [self.dataArr addObject:key];
            }
        }
    }
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.dataDic writeToFile:FilePath atomically:YES];
}
- (void)updata{
    if([self.oldStr isEqualToString:self.InputText.stringValue]==NO){
        self.oldStr=self.InputText.stringValue;
        self.myDescription=NO;
        if([self.oldStr rangeOfString:@"@"].location!=NSNotFound){
            NSString *intValue=[self.oldStr substringFromIndex:[self.oldStr rangeOfString:@"@"].location+1];
            if([self isIntValue:intValue]){
                NSInteger index=[intValue intValue];
                if(self.searchArr.count>=index&&index!=0){
                    self.outPutText.string=self.searchArr[index-1];
                }
            }
        }
        else{
            [self.searchArr removeAllObjects];
            int count=1;
            for (NSString *tempStr in self.dataArr) {
                if ([self exsitTargetString:self.oldStr inText:tempStr]) {
                    [self.searchArr addObject:[NSString stringWithFormat:@"%d: %@",count++,tempStr]];
                }
            }
            self.outPutText.string=[self.searchArr componentsJoinedByString:@"\n"];
        }
    }
}
- (BOOL)exsitTargetString:(NSString *)targetString inText:(NSString *)text{
    targetString=[targetString lowercaseString];
    text=[text lowercaseString];
    unichar ch1,ch2;
    
    while (text.length>0&&targetString.length>0) {
        ch1=[text characterAtIndex:0];
        ch2=[targetString characterAtIndex:0];
        if (ch1==ch2) {
            text=[text substringFromIndex:1];
            targetString=[targetString substringFromIndex:1];
        }else{
            text=[text substringFromIndex:1];
        }
        
        if (targetString.length==0) {
            return YES;
        }
        if (text.length==0) {
            return NO;
        }
    }
    return NO;
}
- (BOOL)isIntValue:(NSString *)string{
    if(string.length>0){
        unichar ch;
        for (NSInteger i=0; i<string.length; i++) {
            ch=[string characterAtIndex:i];
            if(!(ch>='0'&&ch<='9')){
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
/*
 功能分成两块:
 1.可以实现查看代码 (导入数据库)
 2.可以实现生成代码 (导入类,调用方法)
 */


#pragma mark----------数据库相关操作
- (FMDatabase *)curFMdatabase{
    if(_curFMdatabase==nil){
        if([[NSFileManager defaultManager] fileExistsAtPath:DataBasePath]==NO){//判断数据库是否存在
            FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:DataBasePath];
            if ([fmdateBase open]) {
                NSString *codeMainTable=@"create table if not exists MainTable (id integer primary key autoincrement,title text,context text)";
                if(![fmdateBase executeUpdate:codeMainTable]){
                    NSLog(@"创建表格失败");
                }else{
                    NSLog(@"创建表格成功");
                }
                //创建成功后需要关闭该数据库
                [fmdateBase close];
            }else{
                NSLog(@"创建数据库失败");
                self.outPutText.string=@"创建数据库失败";
            }
        }
        _curFMdatabase=[self openDataBase:@"myDataBase.rdb"];
        if(_curFMdatabase==nil){
            self.outPutText.string=@"打开数据库失败";
        }
    }
    return _curFMdatabase;
}
//1.根据数据库名,来打开一个数据库,如果打开成功,返回这个权柄(测试成功)
- (FMDatabase *)openDataBase :(NSString *)name{
    
        FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:DataBasePath];
        if ([fmdateBase open]) {
            return fmdateBase;
        }
    self.outPutText.string=@"数据库打开失败";
    return nil;//如果打开失败,返回空
}
//4.判断表中是否已经有这条记录
- (BOOL)HasExistInfo:(NSString *)title{
    if(self.curFMdatabase!=nil){//如果打开数据库成功
        NSString *code=[NSString stringWithFormat:@"select count(*) as 'count' from %@ where  title = '%@'", @"MainTable", title];
        FMResultSet *rs = [self.curFMdatabase executeQuery:code];
        while ([rs next]){
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count){
                [rs close];
                return NO;
            }else{
                [rs close];
                return YES;
                break;
            }
        }
    }
    return NO;
}
//4.添加数据(测试成功)
- (void)insertDataWithTitle:(NSString *)title withContext:(NSString *)context{
    if([self HasExistInfo:title]==YES){
        self.outPutText.string=[NSString stringWithFormat:@"标题  %@  已存在,请另取标题",title];
        return;
    }
    NSString *code=[NSString stringWithFormat:@"insert into %@ (title,context) values ('%@','%@')",@"MainTable",title,[self enCode:context] ];
    if([self operateDataToDataBase:@"myDataBase.rdb" withCode:code]){
        self.outPutText.string=@"添加数据成功";
    }else{
        self.outPutText.string=@"添加数据失败";
    }
}
//4.删除某一条数据(测试成功)
- (void)deleteDataWithTitle:(NSString *)title{
    if([self HasExistInfo:title]==YES){
        NSString *code=[NSString stringWithFormat:@"delete from %@ where title = '%@'",@"MainTable",title];
        if([self operateDataToDataBase:@"myDataBase.rdb" withCode:code]){
            self.outPutText.string=@"删除数据成功";
        }else{
            self.outPutText.string=@"删除数据失败";
        }
    }else{
        self.outPutText.string=@"你要删除的数据不存在";
    }
}
//4.修改某条数据(测试成功)
- (void)updataDataWithTitle:(NSString *)title withContext:(NSString *)context{
    if([self HasExistInfo:title]==YES){
        NSString *code=[NSString stringWithFormat:@"update %@ set context = '%@' where title = '%@'",MyMainTable ,[self enCode:context],title];
        if([self operateDataToDataBase:MyDataBaseName withCode:code]){
            self.outPutText.string=@"修改数据成功";
        }else{
            self.outPutText.string=@"修改数据失败";
        }
    }else{
        self.outPutText.string=@"你要修改的数据不存在";
    }
}
//4.查询数据
- (void)selectDataWithTitle:(NSString *)title{
    NSString *code=[NSString stringWithFormat:@"select * from MainTable where title = '%@'",title];
    if(self.curFMdatabase !=nil){//如果打开数据库成功
        FMResultSet *set = [self.curFMdatabase executeQuery:code];
        NSMutableString *resultText=[NSMutableString string];
        while ([set next]) {
            NSString *data=[self deCode:[set stringForColumn:@"context"]];
            [resultText appendString:data];
        }
        [set close];
        if(resultText.length>0){
            self.outPutText.string=resultText;
        }else{
            self.outPutText.string=@"这条数据已经不存在";
        }
    }
}
//4.根据表格进行 插入 修改 删除 3种命令 (测试成功)
- (BOOL)operateDataToDataBase:(NSString *)DataBaseName withCode:(NSString *)code {
    if(self.curFMdatabase!=nil){//如果打开数据库成功
        if(![self.curFMdatabase executeUpdate:code]){
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}
//3.如果主目录不存在,就创建主目录
- (void)creatMainPath{
    BOOL temp;
    if(![[NSFileManager defaultManager] fileExistsAtPath:FilePath isDirectory:&temp])
        [[NSFileManager defaultManager] createDirectoryAtPath:FilePath withIntermediateDirectories:YES attributes:nil error:nil];
}
//处理数据存储单引号所引起的问题
- (NSString *)enCode:(NSString *)text{
    NSMutableString *temp=[NSMutableString string];
    NSInteger lenth=text.length;
    unichar ch;
    for(NSInteger i=0;i<lenth;i++){
        ch=[text characterAtIndex:i];
        if(ch=='\''){
            [temp appendString:@"@@"];
        }
        else [temp appendFormat:@"%C",ch];
    }
    return temp;
}
- (NSString *)deCode:(NSString *)text{
    NSMutableString *temp=[NSMutableString string];
    NSInteger lenth=text.length;
    unichar ch;
    for(NSInteger i=0;i<lenth-1;i++){
        ch=[text characterAtIndex:i];
        if(ch=='@'&&[text characterAtIndex:i+1]=='@'){
            [temp appendString:@"'"];
            i++;
        }
        else [temp appendFormat:@"%C",ch];
    }
    if([text characterAtIndex:lenth-1]!='@')
        [temp appendFormat:@"%C",[text characterAtIndex:lenth-1]];
    return temp;
}
- (IBAction)classAction:(id)sender {
    if(self.className.state==1)
        self.outPutText.string=@"注意,这里需要写你的类文件名字";
}
- (IBAction)searchSwitchAction:(id)sender {
    
    if (self.searChSwitch.state==0) {
        _needSearchDataFormDataBase=NO;
        [self reloadData];
    }else{
        _needSearchDataFormDataBase=YES;
        [self reloadData];
    }
    
}
@end
