//
//  NCWebServiceParameterParser.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCWebServiceParameterParser.h"
#import "NSObject+DictionaryRepresentation.h"
#import "NCNetworkPlistKeys.h"

@implementation NCWebServiceParameterParser

- (NSString *)parseServiceQueryString:(NSString *)serviceRootQuery parameters:(NSDictionary *)parameters
{
    NSMutableString *mutableServiceRootQuery = [serviceRootQuery mutableCopy];

    NSString *pattern = @"%\\d\\[.+\\]|%\\d";
    NSError *error;

    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *subString;
    NSString *parameterObject;

    NSArray *matches = [regexp matchesInString:mutableServiceRootQuery options:0 range:NSMakeRange(0, [mutableServiceRootQuery length])];

    while ([matches count] > 0)
    {

        NSTextCheckingResult *const aResult = [matches lastObject];

        subString = [[mutableServiceRootQuery substringWithRange:aResult.range] stringByReplacingOccurrencesOfString:@"%" withString:@""];

        NSRange range = [subString rangeOfString:@"["];

        if (range.location == NSNotFound)
        {
            parameterObject = [parameters objectForKey:subString];
        }
        else
        {
            NSString *propertyName = [subString substringWithRange:NSMakeRange(range.location + 1, subString.length - range.length - 2)];
            NSString *parameterKey = [subString substringToIndex:range.location];

            parameterObject = [[parameters objectForKey:parameterKey] valueForKey:propertyName];
        }

        if ([parameterObject isKindOfClass:[NSString class]])
        {

            if ([parameterObject length] == 0)
            {
                NSLog(@"Parameter object for call it's invalid, parameter length should not be zero.");
            }

            [mutableServiceRootQuery replaceCharactersInRange:aResult.range withString:parameterObject];
        }
        else
        {
            NSString *string = [parameterObject stringRepresentation];

            if ([string length])
            {
                [mutableServiceRootQuery replaceCharactersInRange:aResult.range withString:string];
            }
            else
            {
                NSLog(@"Parameter object for call it's not valid! On call %@ with parameters %@", serviceRootQuery, parameters);
                break;
            }
        }

        matches = [regexp matchesInString:mutableServiceRootQuery options:0 range:NSMakeRange(0, [mutableServiceRootQuery length])];
    }

    return mutableServiceRootQuery;
}

- (NSDictionary *)parseWebServiceParameter:(NSString *)webServiceParameter configuration:(NSDictionary *)parameters parameters:(NSDictionary *)param
{
    NSMutableDictionary *headerDictionary = [[NSMutableDictionary alloc] init];

    id parameterObject = parameters[kNCWebServiceRequest][webServiceParameter];

    if ([parameterObject isKindOfClass:[NSDictionary class]])
    {
        for (NSString *key in parameterObject)
        {
            id value = [parameterObject objectForKey:key];
            NSString *object;

            if ([value isKindOfClass:[NSString class]])
            {
                NSString *pattern = @"%\\d\\[.+\\]|%\\d";
                NSError *error;

                NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
                NSString *subString;

                NSArray *matches = [regexp matchesInString:value options:0 range:NSMakeRange(0, [value length])];

                if ([matches count] > 0)
                {
                    NSTextCheckingResult *const aResult = [matches lastObject];

                    subString = [[value substringWithRange:aResult.range] stringByReplacingOccurrencesOfString:@"%" withString:@""];

                    NSRange range = [subString rangeOfString:@"["];

                    if (range.location == NSNotFound)
                    {
                        object = [param objectForKey:subString];
                    }
                    else
                    {
                        NSString *propertyName = [subString substringWithRange:NSMakeRange(range.location + 1, subString.length - range.length - 2)];
                        NSString *parameterKey = [subString substringToIndex:range.location];

                        object = [[param objectForKey:parameterKey] valueForKey:propertyName];
                    }
                }

            }

            if (!object && value)
            {
                [headerDictionary setObject:value forKey:key];
            }
            else
            {
                [headerDictionary setObject:object forKey:key];
            }
        }
    }

    return headerDictionary;
}
@end
