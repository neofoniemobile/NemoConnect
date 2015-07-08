//
//  NSObject+DictionaryRepresentation.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

/**
 *  NSObject dictionary extension
 *
 *  This class will discover all the properties on the object and try to transform it into a hash table format.
 *  This implementation is working as a normal reflection.
 */
@interface NSObject (DictionaryRepresentation)

/**
 * Returns an NSDictionary containing the properties of an object that are not nil.
 */
- (NSDictionary *)dictionaryRepresentation;

/**
 * Returns a string representation for query parameters.
 */
- (NSString *)stringRepresentation;

@end
