//
//  HipChatCompatPlugin.m
//  HipChatCompat
//
//  Created by Brian Hartvigsen on 10/30/15.
//  Copyright © 2015 Brian Hartvigsen. All rights reserved.
//

#import "HipChatCompatPlugin.h"

#define HCCCodeAttribute @"HipchatCodeMessage"
#define HCCQuoteAttribute @"HipchatQuoteMessage"

#define HCCCodeTrigger @"/code "
#define HCCQuoteTrigger @"/quote "


@implementation HipChatCompatPlugin

- (NSString *) pluginAuthor
{
    return @"Brian Hartvigsen";
}

- (NSString *) pluginVersion
{
    return @"1.0.0";
}

- (NSString *) pluginDescription
{
    return @"Implements /code and /quote from Hipchat";
}

- (NSString *) pluginURL
{
    return @"";
}

- (void) installPlugin
{
    [adium.contentController registerContentFilter:self ofType:AIFilterMessageDisplay direction:AIFilterOutgoing];
    [adium.contentController registerContentFilter:self ofType:AIFilterMessageDisplay direction:AIFilterIncoming];

    [adium.contentController registerHTMLContentFilter:self direction:AIFilterOutgoing];
    [adium.contentController registerHTMLContentFilter:self direction:AIFilterIncoming];
}

- (void) uninstallPlugin
{
    [adium.contentController unregisterHTMLContentFilter:self];
    [adium.contentController unregisterContentFilter:self];
}

- (CGFloat)filterPriority
{
    return DEFAULT_FILTER_PRIORITY;
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject *)content
{
    if ([content isKindOfClass:[AIContentMessage class]] && content.message.length > 0) {
        AIContentMessage *message = (AIContentMessage *)content;
        NSMutableString *html = [inHTMLString mutableCopy];
        if ([[[message message] attribute:HCCCodeAttribute atIndex:0 effectiveRange:NULL] boolValue])
        {
            [html replaceCharactersInRange:[html rangeOfString:HCCCodeTrigger] withString:@""];
            return [NSString stringWithFormat:@"<pre style=\"border: 1px solid black; margin: 0; padding: 10px; border-radius: 3px; background-color: #EFEFEF\"><code style=\"font-family: Menlo, 'Bitstream Vera Sans Mono', 'DejaVu Sans Mono', Monaco, Consolas, monospace;\">%@</code></pre>", html];
        }
        else if ([[[message message] attribute:HCCQuoteAttribute atIndex:0 effectiveRange:NULL] boolValue])
        {
            [html replaceCharactersInRange:[html rangeOfString:HCCQuoteTrigger] withString:@""];
            return [NSString stringWithFormat:@"<blockquote style='border-left:1px black solid; margin: 0 0 0 19px; padding: 0 20px;'>%@</blockquote>", html];
        }
        
    }
    return inHTMLString;
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)inAttributedString context:(id)context
{
    if (inAttributedString &&
        [inAttributedString length]) {
        NSMutableAttributedString *attribString = [inAttributedString mutableCopy];
        if ([[inAttributedString string] rangeOfString:HCCCodeTrigger
                                         options:NSCaseInsensitiveSearch].location == 0)
        {
            [attribString addAttribute:HCCCodeAttribute value:[NSNumber numberWithBool:YES] range:NSMakeRange(0, [attribString length])];
        }
        else if ([[inAttributedString string] rangeOfString:@"/quote "
                                              options:NSCaseInsensitiveSearch].location == 0)
        {
            [attribString addAttribute:HCCQuoteAttribute value:[NSNumber numberWithBool:YES] range:NSMakeRange(0, [attribString length])];

        }
        return attribString;
    }
    return inAttributedString;
}

@end
