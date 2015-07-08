//
//  NCSerializer.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;
#import "NCNetworkPlistKeys.h"

/**
 *  Serialisation
 */
@protocol NCSerializer <NSObject>

@required

/**
 *  Deserialization method
 *
 *  @param data                 data to deserialize
 *  @param deserializationClass blueprint, expected object class name, the deserialization class
 *
 *  @return deserialised result object
 */
- (id)deserializeData:(NSData *)data withDeserializationClass:(Class)deserializationClass error:(NSError **)error;

@optional

/**
 *  Deserialized Data as Dictionary
 *
 *  @return dictionary
 */
- (NSDictionary *)deserializedDictionary;

@end
