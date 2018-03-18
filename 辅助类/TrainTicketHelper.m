#import "TrainTicketHelper.h"
#import "ZHFileManager.h"
#import "ZHJson.h"
#import "ZHJsonToXML.h"
#import "NSArray+ZH.h"
#import "NSDictionary+ZH.h"
#import "ZHNSString.h"

@implementation TrainTicketHelper
- (NSString *)description{
    return @"请点击确认";
}

- (void)Begin:(NSString *)str{
    
    NSArray *files=[ZHFileManager subPathFileArrInDirector:@"/Users/mac/Desktop/Data" hasPathExtension:@[@".txt"]];
    
    NSMutableArray *carNames=[NSMutableArray array];
    
    NSInteger progress=-1;
    for (NSInteger i=0,count=files.count; i<count; i++) {
        @autoreleasepool {
            NSString *filePath=files[i];
            NSString *text=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            
            NSDictionary *dic=[NSDictionary dictionaryWithJsonString:text];
            NSInteger index=-1;
            for (NSString *key in dic) {
                NSArray *value=dic[key];
                if(index!=-1)break;
                for (NSInteger j=0; j<value.count; j++) {
                    NSString *subString=value[j];
                    if([subString isEqualToString:@"站名"]){
                        index=j;
                        break;
                    }
                }
            }
            
            for (NSString *key in dic) {
                NSArray *value=dic[key];
                if (value.count>index) {
                    NSString *subString=value[index];
                    if(![subString isEqualToString:@"站名"]){
                        if([carNames containsObject:subString]==NO)
                            [carNames addObject:subString];
                    }
                }
            }
            
            if((NSInteger)(i*1.0*100/count)>progress){
                progress=(NSInteger)(i*1.0*100/count);
                NSLog(@"progress:%zd",progress+1);
            }
        }
    }
    
    [[carNames jsonPrettyStringEncoded]writeToFile:@"/Users/mac/Desktop/CarNams.m" atomically:yearMask encoding:NSUTF8StringEncoding error:nil];
}

@end
