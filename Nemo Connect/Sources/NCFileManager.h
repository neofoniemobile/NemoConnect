//
//  NCFileManager.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

/**
 *  File manager util class
 *
 *  Containing some useful methods
 */
@interface NCFileManager : NSObject

/**
 *  Calculate the size of the file under the path
 *
 *  @param path absolute path to the file
 *
 *  @return size of the file in uint64_t
 */
+ (uint64_t)totalBytesForFileWithPath:(NSString *)path;

/**
 *  Generate unique file name
 *
 *  @param characters number of characters
 *
 *  @return generated name
 */
+ (NSString *)uniqueNameWithNumberOfCharacters:(NSUInteger)characters;

/**
 *  Saving NSData as file into the tmp folder
 *
 *  @param data           data
 *  @param uniqueFileName file name must be unique
 *
 *  @return full path of the file
 */
+ (NSURL *)saveDataToTemporaryFolder:(NSData *)data name:(NSString *)uniqueFileName;

/**
 *  Removing file from tmp folder with name
 *
 *  @param name name of the file
 *
 *  @return error object
 */
+ (NSError *)removeDataFileFromTemporaryFolderWithName:(NSString *)name;

@end
