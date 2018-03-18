#import "ZHTableViewCollectionView.h"
#import "ZHWordWrap.h"

@implementation ZHTableViewCollectionView
- (NSString *)description{
    
    NSString *filePath=[self creatFatherFile:@"TableViewCollectionViewController" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)",@"是否需要titleForSection 1:0 (不填写么默认为否)",@"是否需要heightForSection 1:0 (不填写么默认为否)",@"是否需要右边的滑栏 1:0 (不填写么默认为否)",@"是否需要按拼音排序 1:0 (不填写么默认为否)",@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)",@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)",@"-----------------------------------------------",@"-----------------------------------------------",@"自定义CollectionViewCell,以逗号隔开",@"是否需要对应的(CollectionView)Model 1:0 (不填写么默认为否)"]];
    
    [self openFile:filePath];
    
    return @"指导文件已经创建在桌面上: TableViewCollectionViewController指导文件.m  ,请勿修改指定内容,否则格式不对将无法生成TableViewCollectionView的ViewController";
}
- (void)Begin:(NSString *)str{
    
    NSDictionary *dic=[self getDicFromFileName:@"TableViewCollectionViewController"];
    
    if(![self judge:dic[@"最大文件夹名字"]]){
        [self saveData:@"没有填写文件夹名字,创建MVC失败!"];
        return;
    }
    
    NSString *fatherDirector=[self creatFatherFileDirector:dic[@"最大文件夹名字"] toFatherDirector:nil];
    [self creatFatherFileDirector:@"controller" toFatherDirector:fatherDirector];
    [self creatFatherFileDirector:@"view" toFatherDirector:fatherDirector];
    [self creatFatherFileDirector:@"model" toFatherDirector:fatherDirector];
    
    //如果没有填写dic[@"ViewController的名字"]那么就默认只生成MVC文件夹
    if (![self judge:dic[@"ViewController的名字"]]) {
        [self saveData:@"没有填写 ViewController的名字 那么就默认只生成MVC文件夹"];
        return;
    }
    //1.创建ViewController.h
    
    NSMutableString *textStrM=[NSMutableString string];
    
    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@ViewController : UIViewController",dic[@"ViewController的名字"]],@"",@"@end",@""] ToStrM:textStrM];
    
    [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"controller",[NSString stringWithFormat:@"%@ViewController.h",dic[@"ViewController的名字"]]]];
    
    [textStrM setString:@""];
    
    //创建ViewController.m
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@ViewController.h\"",dic[@"ViewController的名字"]],@""] ToStrM:textStrM];
    
    NSString *cells=dic[@"自定义Cell,以逗号隔开"];
    NSArray *arrCells=[cells componentsSeparatedByString:@","];
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@TableViewCell.h\"",cell]] ToStrM:textStrM];
        }
    }
    
    NSString *cells_CollectionView=dic[@"自定义CollectionViewCell,以逗号隔开"];
    
    NSArray *arrCells_CollectionView=[cells_CollectionView componentsSeparatedByString:@","];
    
    if ([self judge:cells_CollectionView]) {
        for (NSString *cell in arrCells_CollectionView) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CollectionViewCell\"",cell]] ToStrM:textStrM];
        }
    }
    
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\n@interface %@ViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>\n",dic[@"ViewController的名字"]],@"@property (weak, nonatomic) IBOutlet UITableView *tableView;\n@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;\n"] ToStrM:textStrM];
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"@property (weak, nonatomic) IBOutlet UIView *MI_View;",@"@property (weak, nonatomic) IBOutlet UILabel *MI_Label;",@"@property (nonatomic,assign)NSInteger time_count;//这个属性是为了让MI_View消失"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"@property (nonatomic,strong)NSMutableArray *dataArrTableView;",@""] ToStrM:textStrM];
    [self insertValueAndNewlines:@[@"@property (nonatomic,strong)NSMutableArray *dataArrCollectionView;",@""] ToStrM:textStrM];
    
    if ([dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"@property (nonatomic,strong)NSMutableArray *sectionDataArr;"] ToStrM:textStrM];
    }
    
    
    [self insertValueAndNewlines:@[@"@end",@"\n",[NSString stringWithFormat:@"@implementation %@ViewController",dic[@"ViewController的名字"]]] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (NSMutableArray *)dataArrTableView{",@"if (!_dataArrTableView) {",@"_dataArrTableView=[NSMutableArray array];",@"}",@"return _dataArrTableView;",@"}"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (NSMutableArray *)dataArrCollectionView{",@"if (!_dataArrCollectionView) {",@"_dataArrCollectionView=[NSMutableArray array];",@"}",@"return _dataArrCollectionView;",@"}"] ToStrM:textStrM];
    
    if ([dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (NSMutableArray *)sectionDataArr{\n\
                                       if (!_sectionDataArr) {\n\
                                       _sectionDataArr=[NSMutableArray array];\n\
                                       }\n"] ToStrM:textStrM];
        
        if (![dic[@"是否需要按拼音排序 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
            [self insertValueAndNewlines:@[@"for (NSInteger i=0; i<26; i++) {\n\
                                           [_sectionDataArr addObject:[NSString stringWithFormat:@\"%C\",(unichar)('A'+i)]];\n\
                                           }\n"] ToStrM:textStrM];
        }
        
        [self insertValueAndNewlines:@[@"return _sectionDataArr;\n}"] ToStrM:textStrM];
    }
    
    
    [self insertValueAndNewlines:@[@"\n- (void)viewDidLoad{",@"[super viewDidLoad];",@"self.tableView.delegate=self;",@"self.tableView.dataSource=self;",@"//self.edgesForExtendedLayout=UIRectEdgeNone;",@"[self addFlowLayoutToCollectionView:self.collectionView];"] ToStrM:textStrM];
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"self.MI_View.hidden=YES;\n\
                                       self.MI_Label.textColor=[UIColor whiteColor];\n\
                                       self.MI_View.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];\n\
                                       [self.MI_View cornerRadius];"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"/**为collectionView添加布局*/\n\
                                   - (void)addFlowLayoutToCollectionView:(UICollectionView *)collectionView{\n\
                                   UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];\n\
                                   \n\
                                   flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平\n\
                                   //    flow.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直\n\
                                   \n\
                                   flow.minimumInteritemSpacing = 10;\n\
                                   \n\
                                   flow.minimumLineSpacing = 10;\n\
                                   \n\
                                   collectionView.collectionViewLayout=flow;\n\
                                   \n\
                                   // 设置代理:\n\
                                   self.collectionView.delegate=self;\n\
                                   self.collectionView.dataSource=self;\n\
                                   \n\
                                   collectionView.backgroundColor=[UIColor whiteColor];//背景颜色\n\
                                   \n\
                                   collectionView.contentInset=UIEdgeInsetsMake(20, 20, 20, 20);//内嵌值\n\
                                   }\n"] ToStrM:textStrM];
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (void)setMI_labelText:(NSString *)text{\n\
                                       if ([self.MI_Label.text isEqualToString:text]||[text isEqualToString:@\"_\"]) {\n\
                                       return;\n\
                                       }\n\
                                       \n\
                                       self.MI_View.hidden=NO;\n\
                                       self.MI_Label.text=text;\n\
                                       \n\
                                       [UIView animateWithDuration:0.25 animations:^{\n\
                                       self.MI_View.alpha=1.0;\n\
                                       _time_count++;\n\
                                       NSLog(@\"+++%ld\",_time_count);\n\
                                       } completion:^(BOOL finished) {\n\
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\n\
                                       NSLog(@\"%ld\",_time_count);\n\
                                       if (_time_count>1) {\n\
                                       _time_count--;\n\
                                       }\n\
                                       if (_time_count==1) {\n\
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\n\
                                       [UIView animateWithDuration:0.5 animations:^{\n\
                                       self.MI_View.alpha=0.0;\n\
                                       } completion:^(BOOL finished) {\n\
                                       self.MI_View.hidden=YES;\n\
                                       }];\n\
                                       });\n\
                                       }\n\
                                       });\n\
                                       }];\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (void)requestData{\n\
                                       \n\
                                       //解析数据\n\
                                       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];\n\
                                       \n\
                                       [manager GET:@\"URL\" parameters:@{@\"p\":[NSString stringWithFormat:@\"%ld\",self.page]} success:^(AFHTTPRequestOperation *operation, id responseObject) {\n\
                                       \n\
                                       <#Model#> *model=[<#Model#> new];\n\
                                       [model setValuesForKeysWithDictionary:responseObject];\n\
                                       \n\
                                       if(self.page==1){\n\
                                       [self.dataArrTableView removeAllObjects];\n\
                                       }\n\
                                       \n\
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {\n\
                                       NSLog(@\"网络出错\");\n\
                                       }];\n\
                                       }",@"\n//检查网络状态\n- (void)updateInternetStatus\n\
                                       {\n\
                                       AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];\n\
                                       [manager startMonitoring];\n\
                                       [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {\n\
                                       if (status == AFNetworkReachabilityStatusNotReachable) {\n\
                                       \n\
                                       }else{\n\
                                       //请求数据\n\
                                       [self requestData];\n\
                                       }\n\
                                       }];\n\
                                       }"] ToStrM:textStrM];
    }
    
    
    if ([dic[@"是否需要按拼音排序 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        //显示假数据
        [self insertValueAndNewlines:@[@"//- (void)getData1{\n\
                                       //    NSArray *relatedArr=@[@40,@50,@80,@80,@40,@10,@40,@50,@70,@50,@80,@10,@10,@80,@40,@40,@40,@50,@40,@70];\n\
                                       //    NSArray *FamilyArr=@[@0,@1,@0,@1,@0,@1,@0,@1,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];\n\
                                       //    NSArray *arrName=@[@\"_陈宇\",@\"_陈轩\",@\"阿宇数学老师\",@\"鲍思远爸爸\",@\"董晓妈妈\",@\"陈宇语文老师\",@\"方玉军爸爸\",@\"高欢\",@\"郝向锋\",@\"杰克\",@\"庖轩\",@\"钱宇数学老师\",@\"爱思远爸爸\",@\"妲晓妈妈\",@\"陈宇语文老师\",@\"黄玉军爸爸\",@\"张欢\",@\"石向锋\"];\n\
                                       //    NSArray *imageNameArr=@[@\"JiazhangQinyouhaoImg1\",@\"JiazhangQinyouhaoImg2\",@\"JiazhangQinyouhaoImg3\",@\"JiazhangQinyouhaoImg4\",@\"JiazhangQinyouhaoImgXitong1\",@\"JiazhangQinyouhaoImgXitong2\",@\"JiazhangQinyouhaoImgXitong3\",@\"JiazhangQinyouhaoImgXitong4\"];\n\
                                       //    \n\
                                       //    for (NSInteger i=0; i<arrName.count; i++) {\n\
                                       //        FriendsAndFamilyCellModel *model=[FriendsAndFamilyCellModel new];\n\
                                       //        model.iconImageName=imageNameArr[arc4random()%8];\n\
                                       //        model.isFamily=[FamilyArr[i] boolValue];\n\
                                       //        model.relatedDigital=[relatedArr[i] floatValue];\n\
                                       //        model.title=arrName[i];\n\
                                       //        [self.dataArrTableView addObject:model];\n\
                                       //    }\n\
                                       //    \n\
                                       //    \n\
                                       //    self.dataArrTableView=[self sortArrByChineseNames:self.dataArrTableView];\n\
                                       //}\n\
                                       "] ToStrM:textStrM];
        
        //进行排序
        [self insertValueAndNewlines:@[@"- (NSMutableArray *)sortArrByChineseNames:(NSMutableArray *)arrM{\n\
                                       \n\
                                       NSMutableDictionary *ArrSortHelpDictionary=[NSMutableDictionary dictionary];\n\
                                       [arrM sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {\n\
                                       FriendsAndFamilyCellModel *model1=obj1;\n\
                                       FriendsAndFamilyCellModel *model2=obj2;\n\
                                       NSString *pinyin1,*pinyin2;\n\
                                       if (ArrSortHelpDictionary[model1.titleName]==nil) {\n\
                                       pinyin1=[[[TranslaterChineseCharactersToPinyin translaterChineseCharactersToPinyin:model1.titleName]uppercaseString]stringByReplacingOccurrencesOfString:@\" \" withString:@\"\"];\n\
                                       [ArrSortHelpDictionary setValue:pinyin1 forKey:model1.titleName];\n\
                                       }else{\n\
                                       pinyin1=ArrSortHelpDictionary[model1.titleName];\n\
                                       }\n\
                                       \n\
                                       if (ArrSortHelpDictionary[model2.titleName]==nil) {\n\
                                       pinyin2=[[[TranslaterChineseCharactersToPinyin translaterChineseCharactersToPinyin:model2.titleName]uppercaseString]stringByReplacingOccurrencesOfString:@\" \" withString:@\"\"];\n\
                                       [ArrSortHelpDictionary setValue:pinyin2 forKey:model2.titleName];\n\
                                       }else{\n\
                                       pinyin2=ArrSortHelpDictionary[model2.titleName];\n\
                                       }\n\
                                       \n\
                                       if ([pinyin1 compare:pinyin2 options:NSCaseInsensitiveSearch]==NSOrderedAscending) {\n\
                                       return NO;\n\
                                       }\n\
                                       return YES;\n\
                                       }];\n\
                                       \n\
                                       return [NSMutableArray arrayWithArray:[self groupArrByChineseNames:arrM withArrSortHelpDictionary:ArrSortHelpDictionary]];\n\
                                       \n\
                                       }\n\
                                       \n\
                                       - (NSMutableArray *)groupArrByChineseNames:(NSMutableArray *)arrM withArrSortHelpDictionary:(NSDictionary *)ArrSortHelpDictionary{\n\
                                       \n\
                                       NSMutableArray *tempArrM=[NSMutableArray array];\n\
                                       NSMutableArray *subArrM=[NSMutableArray array];\n\
                                       NSString *firstLetter=@\"用第一个字母进行排序\";\n\
                                       \n\
                                       for (FriendsAndFamilyCellModel *model in arrM) {\n\
                                       NSString *pinyin;\n\
                                       if (ArrSortHelpDictionary[model.title]!=nil) {\n\
                                       pinyin=ArrSortHelpDictionary[model.title];\n\
                                       }else{\n\
                                       pinyin=[[[TranslaterChineseCharactersToPinyin translaterChineseCharactersToPinyin:model.title]uppercaseString]stringByReplacingOccurrencesOfString:@\" \" withString:@\"\"];\n\
                                       }\n\
                                       if (pinyin.length>0) {\n\
                                       unichar ch=[pinyin characterAtIndex:0];\n\
                                       NSString *tempStr=[NSString stringWithFormat:@\"%C\",ch];\n\
                                       if ([tempStr isEqualToString:firstLetter]) {\n\
                                       [subArrM addObject:model];\n\
                                       if ([arrM indexOfObject:model]==arrM.count-1) {\n\
                                       [tempArrM addObject:subArrM];\n\
                                       }\n\
                                       }else{\n\
                                       if (subArrM.count>0) {\n\
                                       [tempArrM addObject:subArrM];\n\
                                       }\n\
                                       subArrM=[NSMutableArray array];\n\
                                       [subArrM addObject:model];\n\
                                       if ([arrM indexOfObject:model]==arrM.count-1) {\n\
                                       [tempArrM addObject:subArrM];\n\
                                       }\n\
                                       firstLetter=[tempStr copy];\n\
                                       \n\
                                       //下面的注释适合排除特殊情况,比如需要某些人一直在前面等等,并且显示*或者特殊字符\n\
                                       //                if ([firstLetter isEqualToString:@\"_\"]) {\n\
                                       //                    [self.sectionDataArrTableView addObject:@\"＊\"];\n\
                                       //                }else\n\
                                       [self.sectionDataArrTableView addObject:[firstLetter copy]];\n\
                                       }\n\
                                       }\n\
                                       \n\
                                       }\n\
                                       \n\
                                       return tempArrM;\n\
                                       }"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"#pragma mark - collectionView的代理方法:\n\
                                   // 1.返回组数:\n\
                                   - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView\n\
                                   {\n\
                                   return 1;\n\
                                   }"] ToStrM:textStrM];
    
    
    
    [self insertValueAndNewlines:@[@"// 2.返回每一组item的个数:\n\
                                   - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section\n\
                                   {\n\
                                   return self.dataArrCollectionView.count;\n\
                                   }"] ToStrM:textStrM];
    
    
    [self insertValueAndNewlines:@[@"// 3.返回每一个item（cell）对象;\n\
                                   - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath\n\
                                   {"] ToStrM:textStrM];
    
    if ([self judge:cells_CollectionView]) {
        for (NSString *cell in arrCells_CollectionView) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@\"%@CollectionViewCell\" forIndexPath:indexPath];",cell,cell]] ToStrM:textStrM];
            
            if([dic[@"是否需要对应的(CollectionView)Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@CellModel *model=self.dataArrCollectionView[indexPath.row];",cell]] ToStrM:textStrM];
                [self insertValueAndNewlines:@[@"[cell refreshUI:model];"] ToStrM:textStrM];
            }
        }
        [self insertValueAndNewlines:@[@"return cell;"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"}"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"//4.每一个item的大小:\n\
                                   - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath\n\
                                   {\n\
                                   return CGSizeMake(100, 140);\n\
                                   }"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"// 5.选择某一个cell:\n\
                                   - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath\n\
                                   {\n\
                                   [collectionView deselectItemAtIndexPath:indexPath animated:YES];\n\
                                   NSLog(@\"选择了某个cell\");\n\
                                   }",@"\n"] ToStrM:textStrM];
    
    
    
    [self insertValueAndNewlines:@[@"#pragma mark - 必须实现的方法:",@"- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{",@"return 1;",@"}"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{",@"return self.dataArrTableView.count;",@"}",@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{"] ToStrM:textStrM];
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];",cell,cell]] ToStrM:textStrM];
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@CellModel *model=self.dataArrTableView[indexPath.row];",cell]] ToStrM:textStrM];
                [self insertValueAndNewlines:@[@"[cell refreshUI:model];"] ToStrM:textStrM];
            }
        }
        [self insertValueAndNewlines:@[@"return cell;",@"}"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{",@"return 44.0f;",@"}",@"- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{",@"[tableView deselectRowAtIndexPath:indexPath animated:YES];",@"NSLog(@\"选择了某一行\");",@"}",@"\n"] ToStrM:textStrM];
    
    
    if ([dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{\n\
                                       return self.sectionDataArrTableView;\n\
                                       }\n\
                                       - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{\n\
                                       if(section==0)\n\
                                       return @\"\";\n\
                                       return self.sectionDataArrTableView[section];\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要titleForSection 1:0 (不填写么默认为否)"] isEqualToString:@"1"]&&[dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"0"]) {
        [self insertValueAndNewlines:@[@"- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{\n\
                                       return @\"\";\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要heightForSection 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{\n\
                                       return 40.0f;\n\
                                       }\n\
                                       - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{\n\
                                       return 0.001f;\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        [self insertValueAndNewlines:@[@"-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{\n\
                                       [self setMI_labelText:title];\n\
                                       return [self.sectionDataArrTableView indexOfObject:title];\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"/**是否可以编辑*/\n- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{\nif (indexPath.row==self.dataArrTableView.count) {\nreturn NO;\n}\nreturn YES;\n}\n\n/**编辑风格*/\n- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{\nreturn UITableViewCellEditingStyleDelete;\n}\n\n",@"/**设置编辑的控件  删除,置顶,收藏*/\n- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n//设置删除按钮\n\
                                       UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@\"删除\" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {\n\
                                       [self.dataArrTableView removeObjectAtIndex:indexPath.row];\n\
                                       [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:\(UITableViewRowAnimationAutomatic)];\n\
                                       }];\n\
                                       return  @[deleteRowAction];\n\
                                       }\n\n"
                                       ] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
    [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"controller",[NSString stringWithFormat:@"%@ViewController.m",dic[@"ViewController的名字"]]]];
    
    //3.创建cells 和models
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>"] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell : UITableViewCell",cell]] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel;",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@TableViewCell.h",cell]]];
            
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@TableViewCell.h\"\n",cell]] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell ()",cell],@"@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIButton *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"@end\n"] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@implementation %@TableViewCell",cell],@"\n"] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel{",cell],@"self.nameLabel.text=dataModel.title;\n\
                                               self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];\n\
                                               //    [self.iconImageView imageWithURLString:dataModel.iconImageName];",@"}\n\n"] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"- (void)awakeFromNib {",@"// Initialization code",@"//    self.selectionStyle=UITableViewCellSelectionStyleNone;\n\
                                           //    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;",@"}\n\n",@"- (void)setSelected:(BOOL)selected animated:(BOOL)animated {",@"[super setSelected:selected animated:animated];",@"// Configure the view for the selected state",@"}\n\n",@"@end\n"] ToStrM:textStrM];
            
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@TableViewCell.m",cell]]];
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@CellModel : NSObject",cell],@"@property (nonatomic,copy)NSString *iconImageName;",@"//@property (nonatomic,copy)NSString *<#ImageView#>;",@"//@property (nonatomic,copy)NSString *<#ImageView#>;",@"@property (nonatomic,copy)NSString *title;",@"//@property (nonatomic,copy)NSString *<#titleName#>;",@"//@property (nonatomic,copy)NSString *<#titleName#>;",@"@end\n"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.h",cell]]];
                
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell],@"\n",[NSString stringWithFormat:@"@implementation %@CellModel",cell],@"\n@end\n"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.m",cell]]];
            }
        }
    }
    
    //3.创建cells 和models(collectionView)
    
    if ([self judge:cells_CollectionView]) {
        for (NSString *cell in arrCells_CollectionView) {
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>"] ToStrM:textStrM];
            if([dic[@"是否需要对应的(CollectionView)Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@CollectionViewCell : UICollectionViewCell",cell]] ToStrM:textStrM];
            if([dic[@"是否需要对应的(CollectionView)Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel;",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@CollectionViewCell.h",cell]]];
            
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CollectionViewCell.h\"\n",cell]] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@CollectionViewCell ()",cell],@"@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIButton *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"@end\n"] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@implementation %@CollectionViewCell",cell],@"\n"] ToStrM:textStrM];
            if([dic[@"是否需要对应的(CollectionView)Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel{",cell],@"self.nameLabel.text=dataModel.title;\n\
                                               self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];\n\
                                               //    [self.iconImageView imageWithURLString:dataModel.iconImageName];",@"}\n\n"] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"- (void)awakeFromNib {",@"// Initialization code",@"}\n",@"- (void)setSelected:(BOOL)selected{\n\
                                           [super setSelected:selected];\n\
                                           }\n\
                                           - (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView{\n\
                                           [super setSelectedBackgroundView:selectedBackgroundView];\n\
                                           }",@"@end\n"] ToStrM:textStrM];
            
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@CollectionViewCell.m",cell]]];
            
            if([dic[@"是否需要对应的(CollectionView)Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@CellModel : NSObject",cell],@"@property (nonatomic,copy)NSString *iconImageName;",@"//@property (nonatomic,copy)NSString *<#ImageView#>;",@"//@property (nonatomic,copy)NSString *<#ImageView#>;",@"@property (nonatomic,copy)NSString *title;",@"//@property (nonatomic,copy)NSString *<#titleName#>;",@"//@property (nonatomic,copy)NSString *<#titleName#>;",@"@end\n"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.h",cell]]];
                
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell],@"\n",[NSString stringWithFormat:@"@implementation %@CellModel",cell],@"\n@end\n"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.m",cell]]];
            }
        }
    }
    
    
    //如果需要StroyBoard
    if([dic[@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        //这里有较多需要判断的情况
        //1.假如  ViewController的名字 不存在
        if (![self judge:dic[@"ViewController的名字"]]) {
            [self saveStoryBoard:@"" TableViewCells:nil toFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
        }else{
            //没有cells
            if (![self judge:dic[@"自定义Cell,以逗号隔开"]]) {
                [self saveStoryBoard:dic[@"ViewController的名字"] TableViewCells:nil toFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
            }else{//有cells
                NSArray *arr=[dic[@"自定义Cell,以逗号隔开"] componentsSeparatedByString:@","];
                NSMutableArray *arrM=[NSMutableArray array];
                for (NSString *str in arr) {
                    [arrM addObject:[str stringByAppendingString:@"TableViewCell"]];
                }
                [self saveStoryBoard:dic[@"ViewController的名字"] TableViewCells:arrM toFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
            }
        }
    }
    
    [[ZHWordWrap new]wordWrap:[self getDirectoryPath:dic[@"最大文件夹名字"]]];
    
    [self saveData:@"创建完成"];
}
- (void)repeat{
    NSString *homeDirectory=NSHomeDirectory();
    homeDirectory=[homeDirectory stringByAppendingPathComponent:@"Desktop/TableViewViewController.m"];
    NSString *text=[NSString stringWithContentsOfFile:homeDirectory encoding:NSUTF8StringEncoding error:nil];
    NSInteger index=[text rangeOfString:@"ZH"].location;
    NSInteger end=[text rangeOfString:@"\"" options:1 range:NSMakeRange(index+1, text.length-index-1)].location;
    NSString *oldZH64=[text substringWithRange:NSMakeRange(index, end-index)];
    NSString *ZH64=[text substringWithRange:NSMakeRange(index+2, end-index-2)];
    NSInteger zh64Value=[ZH64 integerValue];
    zh64Value++;
    NSLog(@"%@:%ld:%@",ZH64,zh64Value,[NSString stringWithFormat:@"ZH%ld",zh64Value]);
    text=[text stringByReplacingOccurrencesOfString:oldZH64 withString:[NSString stringWithFormat:@"ZH%ld",zh64Value]];
    [text writeToFile:homeDirectory atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self Begin:nil];
}
@end