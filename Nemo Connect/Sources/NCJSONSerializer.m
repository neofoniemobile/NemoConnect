//
//  NCJSONSerializer.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCJSONSerializer.h"

@interface NCJSONSerializer ()

@property (nonatomic, strong) NSDictionary *jsonDictionary;

@end

@implementation NCJSONSerializer

- (id)deserializeData:(NSData *)data withDeserializationClass:(Class)deserializationClass error:(NSError **)error
{
    NSParameterAssert(data);
    NSParameterAssert(deserializationClass);

    __block BOOL keyFound = NO;

    id serializedObject = [[deserializationClass alloc] init];

    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    [self.jsonDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){

        if ([serializedObject respondsToSelector:NSSelectorFromString(key)])
        {
            keyFound = YES;
            [serializedObject setValue:obj forKey:(NSString *)key];
        }
    }];

    if (*error)
    {
        serializedObject = nil;
    }

    return serializedObject;
}

@end
