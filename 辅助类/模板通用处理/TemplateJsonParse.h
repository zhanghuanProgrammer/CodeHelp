#import <Foundation/Foundation.h>

@interface TemplateJsonParse : NSObject

/**原始数据*/
@property (nonatomic,strong)NSDictionary *parameterData;

/**最大模板文件夹路径*/
@property (nonatomic,copy)NSString *path;

/**把当前时间作为桌面上的文件夹*/
@property (nonatomic,copy)NSString *curDataDirector;

/**模板文件路径*/
@property (nonatomic,strong)NSArray *templates;


- (NSString *)creatCode;

@end
