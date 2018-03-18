#import <Cocoa/Cocoa.h>

@protocol MGTemplateFilter <NSObject>

- (NSArray *)filters;

- (id)filterInvoked:(NSString *)filter withArguments:(NSArray *)args onValue:(NSObject *)value;

@end
