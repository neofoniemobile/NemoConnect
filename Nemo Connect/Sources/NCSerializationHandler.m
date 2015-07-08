//
//  NCSerializationHandler.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCSerializationHandler.h"

@implementation NCSerializationHandler

+ (void)deserializeData:(NSData *const)data withSerializer:(id<NCSerializer>)serializationObject toDeserializationClass:(NSString *)deserializationClass withCompletitionBlock:(void (^)(id serializedData, NSError *error))callbackBlock
{
    id deserializedObject;
    NSError *deserializationError = nil;

    if (serializationObject && data)
    {
        deserializedObject = [serializationObject deserializeData:data withDeserializationClass:NSClassFromString(deserializationClass) error:&deserializationError];

        if (!deserializedObject && !deserializationError)
        {
            deserializationError = [self deserializationErrorWithData:data];
        }
    }
    else
    {
        deserializationError = [self deserializationErrorWithData:data];
    }

    if (callbackBlock)
    {
        callbackBlock(deserializedObject, deserializationError);
    }
}

+ (NSError *)deserializationErrorWithData:(NSData *const)data
{
    NSDictionary *userDictionary;

    if (data)
    {
        userDictionary = @{ kNCSerializationErrorUserInformationDictionaryOriginalDataKey : data };
    }

    return [NSError errorWithDomain:kNCSerializationErrorDomain code:kNCSerializationErrorCode userInfo:userDictionary];
}

@end
