#import <UIKit/UIKit.h>
#import "Class<#index#>Model.h"
@interface {{ 自定义Cell }}Model : NSObject

@property (nonatomic,copy)NSString *title{{ 自定义Cell }}1;
@property (nonatomic,copy)NSString *title{{ 自定义Cell }}2;
@property (nonatomic,copy)NSString *title{{ 自定义Cell }}3;
@property (nonatomic,copy)NSString *title{{ 自定义Cell }}4;
@property (nonatomic,copy)NSString *title{{ 自定义Cell }}5;

@property (nonatomic,copy)NSString *content{{ 自定义Cell }}1;
@property (nonatomic,copy)NSString *content{{ 自定义Cell }}2;
@property (nonatomic,copy)NSString *content{{ 自定义Cell }}3;
@property (nonatomic,copy)NSString *content{{ 自定义Cell }}4;
@property (nonatomic,copy)NSString *content{{ 自定义Cell }}5;

@property (nonatomic,assign)BOOL isSelect{{ 自定义Cell }}1;
@property (nonatomic,assign)BOOL isSelect{{ 自定义Cell }}2;
@property (nonatomic,assign)BOOL isSelect{{ 自定义Cell }}3;
@property (nonatomic,assign)BOOL isSelect{{ 自定义Cell }}4;
@property (nonatomic,assign)BOOL isSelect{{ 自定义Cell }}5;

@property (nonatomic,assign)NSInteger age{{ 自定义Cell }}1;
@property (nonatomic,assign)NSInteger age{{ 自定义Cell }}2;
@property (nonatomic,assign)NSInteger age{{ 自定义Cell }}3;
@property (nonatomic,assign)NSInteger age{{ 自定义Cell }}4;
@property (nonatomic,assign)NSInteger age{{ 自定义Cell }}5;

@property (nonatomic,assign)CGFloat width{{ 自定义Cell }}1;
@property (nonatomic,assign)CGFloat width{{ 自定义Cell }}2;
@property (nonatomic,assign)CGFloat width{{ 自定义Cell }}3;
@property (nonatomic,assign)CGFloat width{{ 自定义Cell }}4;
@property (nonatomic,assign)CGFloat width{{ 自定义Cell }}5;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)Class<#index#>Model *nextModel;

@end
