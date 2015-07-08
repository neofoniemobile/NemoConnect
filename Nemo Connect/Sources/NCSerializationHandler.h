//
//  NCSerializationHandler.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCSerializer.h"

/**
 *  Serialisation handler class
 */
@interface NCSerializationHandler : NSObject

/**
 *  Deserialization method
 *
 *  @param data                 object to serialize
 *  @param serializationObject  serializer instance
 *  @param deserializationClass top level object
 *  @param callbackBlock        completion block
 */
+ (void)deserializeData:(NSData *const)data withSerializer:(id<NCSerializer>)serializationObject toDeserializationClass:(NSString *)deserializationClass withCompletitionBlock:(void (^)(id serializedData, NSError *error))callbackBlock;

@end
