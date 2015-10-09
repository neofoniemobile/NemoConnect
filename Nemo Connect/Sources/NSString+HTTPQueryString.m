//
//  NSString+HTTPQueryString.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NSString+HTTPQueryString.h"

@implementation NSString (HTTPQueryString)

+ (NSString *)HTTPQueryStringWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *queryComponents = [[NSMutableArray alloc] initWithCapacity:parameters.count];

    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [queryComponents addObject:[self URLEncodedStringWithKey:key value:value]];
    }];

    return [queryComponents componentsJoinedByString:@"&"];
}

+ (NSString *)URLEncodedStringWithKey:(NSString *)key value:(NSString *)value
{
    NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"[]."]];
    NSString *encodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    return [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
}

@end
