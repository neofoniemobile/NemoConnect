//
//  NSObject+DictionaryRepresentation.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import ObjectiveC;

#import "NSObject+DictionaryRepresentation.h"

@implementation NSObject (DictionaryRepresentation)

- (NSDictionary *)dictionaryRepresentation
{
    unsigned int count = 0;

    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];

    for (int i = 0; i < count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];

        // Only add to the NSDictionary if it's not nil.
        if (value)
        {
            [dictionary setObject:value forKey:key];
        }
    }

    free(properties);

    return dictionary;
}

- (NSString *)stringRepresentation
{
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    NSString *string = [[NSString alloc] init];

    for (int i = 0; i < count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];

        if ([key isEqualToString:@"remoteId"])
        {
            key = @"id";
        }

        // Only add to the NSDictionary if it's not nil.
        if (value)
        {
            if ([value isKindOfClass:[NSString class]])
            {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
            }
            else if ([value respondsToSelector:@selector(stringValue)])
            {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [value stringValue]]];
            }
            else if ([value isKindOfClass:[NSArray class]])
            {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [value componentsJoinedByString:@","]]];
            }
        }
    }

    free(properties);

    // Remove the first &
    if ([string length])
    {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }

    return string;
}

@end
