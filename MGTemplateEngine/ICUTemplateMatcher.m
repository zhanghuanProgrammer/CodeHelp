
#import "ICUTemplateMatcher.h"

@implementation ICUTemplateMatcher

+ (ICUTemplateMatcher *)matcherWithTemplateEngine:(MGTemplateEngine *)theEngine
{
	return [[ICUTemplateMatcher alloc] initWithTemplateEngine:theEngine];
}

- (id)initWithTemplateEngine:(MGTemplateEngine *)theEngine
{
	if ((self = [super init])) {
		self.engine = theEngine; 
	}
	
	return self;
}

- (void)engineSettingsChanged
{
	self.markerStart = _engine.markerStartDelimiter;
	self.markerEnd = _engine.markerEndDelimiter;
	self.exprStart = _engine.expressionStartDelimiter;
	self.exprEnd = _engine.expressionEndDelimiter;
	self.filterDelimiter = _engine.filterDelimiter;
	self.templateString = _engine.templateContents;
	
	_Pragma("clang diagnostic push");
	_Pragma("clang diagnostic ignored \"-Wformat-nonliteral\"");
	NSString *basePattern = @"(\\Q%@\\E)(?:\\s+)?(.*?)(?:(?:\\s+)?\\Q%@\\E(?:\\s+)?(.*?))?(?:\\s+)?\\Q%@\\E";
	NSString *mrkrPattern = [NSString stringWithFormat:basePattern, self.markerStart, self.filterDelimiter, self.markerEnd];
	NSString *exprPattern = [NSString stringWithFormat:basePattern, self.exprStart, self.filterDelimiter, self.exprEnd];
	_Pragma("clang diagnostic pop");
	self.regex = [NSString stringWithFormat:@"(?m)(?:%@|%@)", mrkrPattern, exprPattern];
}

- (NSDictionary *)firstMarkerWithinRange:(NSRange)range
{
	NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:self.regex options:0 error:NULL];
	NSTextCheckingResult *result = [expr firstMatchInString:self.templateString options:0 range:range];
	NSRange matchRange = [result rangeAtIndex:0];
	NSMutableDictionary *markerInfo = nil;
	if (matchRange.length > 0) {
		markerInfo = [NSMutableDictionary dictionary];
		[markerInfo setObject:[NSValue valueWithRange:matchRange] forKey:MARKER_RANGE_KEY];
		
		NSString *matchString = [self.templateString substringWithRange:matchRange];
		NSRange localRange = NSMakeRange(0, [matchString length]);
		NSTextCheckingResult *localResult = [expr firstMatchInString:matchString options:0 range:localRange];
		
		NSString *matchType = nil;
		NSRange mrkrSubRange = [localResult rangeAtIndex:1];
		BOOL isMarker = (mrkrSubRange.length > 0); 
		NSUInteger offset = 0;
		if (isMarker) {
			matchType = MARKER_TYPE_MARKER;
		} else  {
			matchType = MARKER_TYPE_EXPRESSION;
			offset = 3;
		}
		[markerInfo setObject:matchType forKey:MARKER_TYPE_KEY];
		
		NSRange markerRange = NSMakeRange(0, [matchString length]);
		markerRange = [localResult rangeAtIndex:(NSUInteger)(2 + offset)];
		
		if (markerRange.length > 0) {
			NSString *markerString = [matchString substringWithRange:markerRange];
			NSArray *markerComponents = [self argumentsFromString:markerString];
			if (markerComponents && [markerComponents count] > 0) {
				[markerInfo setObject:[markerComponents objectAtIndex:0] forKey:MARKER_NAME_KEY];
				NSUInteger count = [markerComponents count];
				if (count > 1) {
					[markerInfo setObject:[markerComponents subarrayWithRange:NSMakeRange(1, count - 1)] 
								   forKey:MARKER_ARGUMENTS_KEY];
				}
			}
			
			NSRange filterRange = [localResult rangeAtIndex:(NSUInteger)(3 + offset)];
			if (filterRange.length > 0) {
				NSString *filterString = [matchString substringWithRange:filterRange];
				
				localRange = NSMakeRange(0, [filterString length]);
				NSString *space = @" ";
				NSRegularExpression *delimExpr = [NSRegularExpression regularExpressionWithPattern:@":(?:\\s+)?" options:0 error:NULL];
				NSTextCheckingResult *delimResult = [delimExpr firstMatchInString:filterString options:0 range:localRange];
				NSRange filterArgDelimRange = [delimResult range];
				if (filterArgDelimRange.length > 0) {
					filterString = [NSString stringWithFormat:@"%@%@%@", 
									[filterString substringWithRange:NSMakeRange(0, filterArgDelimRange.location)], 
									space, 
									[filterString substringWithRange:NSMakeRange(NSMaxRange(filterArgDelimRange),
																				 localRange.length - NSMaxRange(filterArgDelimRange))]];
				}
				
				NSArray *filterComponents = [self argumentsFromString:filterString];
				if (filterComponents && [filterComponents count] > 0) {
					[markerInfo setObject:[filterComponents objectAtIndex:0] forKey:MARKER_FILTER_KEY];
					NSUInteger count = [filterComponents count];
					if (count > 1) {
						[markerInfo setObject:[filterComponents subarrayWithRange:NSMakeRange(1, count - 1)] 
									   forKey:MARKER_FILTER_ARGUMENTS_KEY];
					}
				}
			}
		}
	}
	
	return markerInfo;
}


- (NSArray *)argumentsFromString:(NSString *)argString
{
	NSString *argsPattern = @"\"(.*?)(?<!\\\\)\"|'(.*?)(?<!\\\\)'|(\\S+)";
	NSRegularExpression *argsRegex = [NSRegularExpression regularExpressionWithPattern:argsPattern options:0 error:NULL];
	NSMutableArray *args = [NSMutableArray array];
	
	NSUInteger location = 0;
	while (location != NSNotFound) {
		NSRange searchRange  = NSMakeRange(location, [argString length] - location);
		NSTextCheckingResult *result = [argsRegex firstMatchInString:argString options:0 range:searchRange];
		NSRange entireRange = [result rangeAtIndex:0], matchedRange = [result rangeAtIndex:1];

		if (matchedRange.length == 0) {
			matchedRange = [result rangeAtIndex:2];

			if (matchedRange.length == 0) {
				matchedRange = [result rangeAtIndex:3];
			}
		}
		
		location = NSMaxRange(entireRange) + ((entireRange.length == 0) ? 1 : 0);
		if (matchedRange.length > 0) {
			[args addObject:[argString substringWithRange:matchedRange]];
		} else {
			location = NSNotFound;
		}
	}
	return args;
}

@end