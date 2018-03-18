#import <UIKit/UIKit.h>
@interface {{ 自定义Cell }}CellModel : NSObject

{% for imageView in {{ 自定义Cell }}.UIImageView %}
@property (nonatomic,copy)NSString *{{ imageView }};
{% /for %}
{% for label in {{ 自定义Cell }}.UILabel %}
@property (nonatomic,copy)NSString *{{ label }};
{% /for %}
{% for button in {{ 自定义Cell }}.UIButton %}
@property (nonatomic,copy)NSString *{{ button }};
{% /for %}
{% for textView in {{ 自定义Cell }}.UITextView %}
@property (nonatomic,copy)NSString *{{ textView }};
{% /for %}

@end
